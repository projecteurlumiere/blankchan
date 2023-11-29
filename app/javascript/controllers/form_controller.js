import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "formTextField" ]

  connect() {
    // TODO: use targets or anything in-built targets
    this.headingLink = document.getElementsByClassName("new-post-link")[0];
    this.heading = document.getElementsByClassName("heading")[0];
    this.footing = document.getElementsByClassName("footing")[0];
    this.footer = document.querySelector("footer");

    this.formFrame = document.getElementById("new-post-form");
    this.formFrameDisplay = this.formFrame.style.display;

    this.formPosition = "initial"; // initial, heading, footing, none (when display none), fixed (unused)
  }

  callToTop(e){
    this.#checkFrame(e);
    if (this.formPosition == "fixed") { this.hideForm(); }

    if (this.formPosition == "initial") { this.formPosition = "heading"; return }

    try {
      this.footing.removeChild(this.formFrame);
      this.heading.appendChild(this.formFrame);
    }
    catch(err) {
      if (!err.name == "NotFoundError") {
        throw new Error("Unexpected error when moving the form")
      }
    }

    if (this.formPosition == "heading") { this.hideForm(); return }

    this.#showForm();
    this.formPosition = "heading"
  }

  callToBottom(e){
    this.#checkFrame(e);
    if (this.formPosition == "fixed") { this.hideForm(); }

    try {
      this.heading.removeChild(this.formFrame);
      this.footing.appendChild(this.formFrame);
    }
    catch(err) {
      if (!err.name == "NotFoundError") {
        throw new Error("Unexpected error when moving the form")
      }
    }

    if (this.formPosition == "footing") { this.hideForm(); return }

    this.#showForm();
    this.formPosition = "footing";

    if (this.formFrame.innerText) {
      this.footer.scrollIntoView({ behavior: "smooth", block: "start" })
    }
    else {
      this.#doWhenFrameLoaded(this.formFrame, this.#scrollTo, this.footer)
    }
  }

  callToFixed(e){
    if (e.ctrlKey == true) return; // only reply() gets triggered
    if (this.formFrame.style.position === "fixed") return;

    if (!this.formFrame.innerText) {
      this.headingLink.click();
      this.#doWhenFrameLoaded(this.formFrame, this.#fix, this.formFrame)
    }

    this.formFrame.classList.add("fixed");
    this.#showForm();

    e.target.scrollIntoView({ behavior: "smooth", block: "start" })

    this.formPosition = "fixed";
  }

  reply(reply_e){
    let id = reply_e.params.id

    if (this.formFrame.innerText) {
      this.#pasteTextAtCaret(this.formTextFieldTarget, `>>${id}\n`);
    }
    else {
      this.#doWhenFrameLoaded(this.formFrame, this.#pasteTextAtCaret, "#post_text", `>>${id}\n`)
    }
  }

  style(e) {
    e.preventDefault();

    let [pieceToSave, start, finish] = this.#saveSelectedText();

    let tag = this.#getTagString(e)
    if (tag == undefined) { return }

    let modifier = this.#calculateModifier(tag)

    this.#pasteTextAtCaret(this.formTextFieldTarget, tag, -modifier);

    if (pieceToSave != undefined) {
      this.#pasteTextAtCaret(this.formTextFieldTarget, pieceToSave);
      this.formTextFieldTarget.focus();
      this.formTextFieldTarget.setSelectionRange(start + modifier - 1, finish + modifier - 1)
    }
  }

  hideForm() {
    this.formFrame.style.display = "none";
    this.#unfixForm();
    this.formPosition = "none"
  }

  // callTo function

  #checkFrame(e) {
    if (this.formFrame.innerText) { e.preventDefault() }
  }

  #showForm() {
    this.formFrame.style.display = "";
  }

  #unfixForm() {
    this.formFrame.classList.remove("fixed");
  }

  #doWhenFrameLoaded(targetFrame, func, ...args) {
    document.addEventListener("turbo:frame-load", (frame_e) => {
      if (frame_e.target == targetFrame) {
        func(...args)
      }
    }, { once: true })
  }

  #scrollTo(target) {
    target.scrollIntoView({ behavior: "smooth", block: "start" })
  }

  #fix(target){
    target.classList.add("fixed");
  }

  // reply text pasting

  #pasteTextAtCaret(textElement, text, modifier = 0) {
    // textElement should be dom element but it will attempt to query select the input
    try {
      textElement = document.querySelector(textElement);
    }
    catch(err) {
      if (!err.name == "SyntaxError") {
      throw new Error("Error when selecting dom element")
      }
    }

    const beforeCaret = textElement.value.substring(0, textElement.selectionStart);
    const afterCaret = textElement.value.substring(textElement.selectionEnd, textElement.value.length);

    textElement.value = beforeCaret + text + afterCaret;

    // Position the caret after the inserted text
    let caretPosition = beforeCaret.length + text.length + modifier;

    textElement.selectionStart = caretPosition;
    textElement.selectionEnd = caretPosition;
  }

  // style functions

  #saveSelectedText() {
    let pieceToSave;

    let start = this.formTextFieldTarget.selectionStart;
    let finish = this.formTextFieldTarget.selectionEnd;

    if (start != finish) {
      pieceToSave = this.formTextFieldTarget.value.substring(start, finish).trim();

      if ((pieceToSave.length) != finish - start) {
        finish = finish - (finish - pieceToSave.length)
      }
    }

    return [pieceToSave, start, finish]
  }

  #getTagString(e){
    switch (e.target.classList[0]) {
      case "bold":
        return"<b></b>"
      case "italic":
        return "<i></i>"
      case "underline":
        return "<u></u>"
      case "strikethrough":
        return "<s></s>"
      default:
        return
    }
  }

  #calculateModifier(tag) {
    if (tag.length % 2 == 0) {
      return (tag.length / 2)
    }
    else {
      return ((tag.length + 1) / 2)
    }
  }
}
