import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "formTextField" ]

  connect(){
    this.form = document.querySelector("#new-post-form-container");
  }

  pastePostId(e){
    this.#pasteTextAtCaret(this.formTextFieldTarget, `>>${e.params.id}\n`);
    if (e.ctrlKey == false) this.openForm();
  }

  openForm(){
    this.form.classList.add("new-post-form-container-active");
  }

  closeForm(){
    this.form.classList.remove("new-post-form-container-active");
  }

  #pasteTextAtCaret(textElement, text) {
    const beforeCaret = textElement.value.substring(0, textElement.selectionStart);
    const afterCaret = textElement.value.substring(textElement.selectionEnd, textElement.value.length);

    textElement.value = beforeCaret + text + afterCaret;

    // Position the caret after the inserted text
    this.#setCaretPosition(textElement, beforeCaret.length + text.length);
  }

  #setCaretPosition(textElement, position) {
    textElement.selectionStart = position;
    textElement.selectionEnd = position;
  }
}
