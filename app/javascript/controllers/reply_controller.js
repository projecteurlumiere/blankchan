import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "formTextField" ]

  pastePostId(e){
    this.#pasteTextAtCaret(this.formTextFieldTarget, `>>${e.params.id}\n`);
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
