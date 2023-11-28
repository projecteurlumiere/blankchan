import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "formTextField" ]

  connect() {
    this.headingLink = document.getElementsByClassName("new-post-link")[0];
    this.heading = document.getElementsByClassName("heading")[0];
    this.footing = document.getElementsByClassName("footing")[0];
    this.footer = document.querySelector("footer");

    this.formFrame = document.getElementById("new-post-form");
    this.formFrameDisplay = this.formFrame.style.display;
    console.log(this.formFrame.parentNode.classList[0]);

    this.formPosition = "initial"; // initial, heading, footing, none (when display none), fixed (unused)
  }

  callToTop(e){
    this.#checkFrame(e);

    if (this.formPosition == "fixed") { this.hideForm(); }

    this.formFrame.style.position = "";

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
      document.addEventListener("turbo:frame-load", (e) => { this.#scrollWhenLoaded(e) })
    }
  }

  reply(reply_e){
    console.log("reply is triggered");
    console.log(reply_e.params.id);

    let id = reply_e.params.id

    if (this.formFrame.innerText) {
      this.#pasteTextAtCaret(this.formTextFieldTarget, `>>${id}\n`);
    }
    else {
      document.addEventListener("turbo:frame-load", (frame_e) => { console.log(id) ;this.#pasteReplyWhenLoaded(frame_e, id) })
    }

    // if no form - wait for form
    // if form - paste e-target-id or something into the form. cool!
  }

  style(e) {
    e.preventDefault();

    let tag = "";
    let pieceToSave;

    let start = this.formTextFieldTarget.selectionStart;
    let finish = this.formTextFieldTarget.selectionEnd;

    console.log(start);
    console.log(finish);
    if (start != finish) {
      pieceToSave = this.formTextFieldTarget.value.substring(start, finish).trim();

      if ((pieceToSave.length) != finish - start) {
        finish = finish - (finish - pieceToSave.length)
      }

    }

    console.log(pieceToSave);

    switch (e.target.classList[0]) {
      case "bold":
        tag = "<b></b>"
        break
      case "italic":
        tag = "<i></i>"
        break
      case "underline":
        tag = "<u></u>"
        break
      case "strikethrough":
        tag = "<s></s>"
        break
      default:
        return
    }

    let modifier = 0

    if (tag.length % 2 == 0) {
      modifier = (tag.length / 2)
    }
    else {
      modifier = ((tag.length + 1) / 2)
    }

    this.#pasteTextAtCaret(this.formTextFieldTarget, tag, -modifier);

    if (pieceToSave != undefined) {
      this.#pasteTextAtCaret(this.formTextFieldTarget, pieceToSave);
      this.formTextFieldTarget.focus();
      this.formTextFieldTarget.setSelectionRange(start + modifier - 1, finish + modifier - 1)
    }
  }

  callToFixed(e){
    console.log("call to fixxed!");

    if (e.ctrlKey == true) return; // only reply() gets triggered
    if (this.formFrame.style.position === "fixed") return;


    if (!this.formFrame.innerText) {
      console.log("click happens");

      this.headingLink.click();
      document.addEventListener("turbo:frame-load", (frame_e) => { this.#fixWhenLoaded(frame_e) })

    }

    this.formFrame.classList.add("fixed");
    this.#showForm();

    e.target.scrollIntoView({ behavior: "smooth", block: "start" })

    // if ctrl is pressed - skip entirely
    // if form is already fixed - skip

    // if no form - call for form somehow
    // if form exists - give it position fixed

    // if other buttons are clicked - unfix position anyway

    // hide form on click on something

    this.formPosition = "fixed";
  }

  hideForm() {
    this.formFrame.style.display = "none";
    this.#unfixForm();
    this.formPosition = "none"
  }

  #checkFrame(e) {
    if (this.formFrame.innerText) { e.preventDefault() }
  }

  #showForm() {
    this.formFrame.style.display = "";
  }

  #unfixForm() {
    this.formFrame.classList.remove("fixed");
  }

  #scrollWhenLoaded(e) {
    if (e.target == this.formFrame) {
      this.footer.scrollIntoView({ behavior: "smooth", block: "start" })

      document.removeEventListener("turbo:frame-load", (e) => { this.#scrollWhenLoaded(e) })
    }
  }

  #pasteReplyWhenLoaded(frame_e, id) {
    if (frame_e.target == this.formFrame) {
      this.#pasteTextAtCaret(this.formTextFieldTarget, `>>${id}\n`);

      document.removeEventListener("turbo:frame-load", (frame_e) => { this.#pasteReplyWhenLoaded(frame_e, id) })
    }
  }

  #fixWhenLoaded(frame_e){
    if (frame_e.target == this.formFrame) {
      this.formFrame.classList.add("fixed");

      document.removeEventListener("turbo:frame-load", (frame_e) => { this.#fixWhenLoaded(frame_e) })
    }
  }

  // reply text pasting

  #pasteTextAtCaret(textElement, text, modifier = 0) {
    const beforeCaret = textElement.value.substring(0, textElement.selectionStart);
    const afterCaret = textElement.value.substring(textElement.selectionEnd, textElement.value.length);

    textElement.value = beforeCaret + text + afterCaret;

    // Position the caret after the inserted text
    this.#setCaretPosition(textElement, beforeCaret.length + text.length + modifier);
  }

  #setCaretPosition(textElement, start, end = start) {
    textElement.selectionStart = start;
    textElement.selectionEnd = end;
  }
}