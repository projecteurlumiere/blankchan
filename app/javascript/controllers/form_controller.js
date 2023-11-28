import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.heading = document.getElementsByClassName("heading")[0];
    this.footing = document.getElementsByClassName("footing")[0];
    this.footer = document.querySelector("footer");

    this.formFrame = document.getElementById("new-post-form");
    this.formFrameDisplay = this.formFrame.style.display;
    console.log(this.formFrame.parentNode.classList[0]);

    this.formPosition = "initial"; // initial, heading, footing, none (when display none)
  }

  callToTop(e){
    this.#checkFrame(e);

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

    if (this.formPosition == "heading") { this.#hideForm(); return }

    this.#showForm();
    this.formPosition = "heading"
  }

  callToBottom(e){
    this.#checkFrame(e);

    try {
      this.heading.removeChild(this.formFrame);
      this.footing.appendChild(this.formFrame);
    }
    catch(err) {
      if (!err.name == "NotFoundError") {
        throw new Error("Unexpected error when moving the form")
      }
    }

    if (this.formPosition == "footing") { this.#hideForm(); return }
    this.#showForm();

    this.formPosition = "footing";

    if (this.formFrame.innerText) {
      this.footer.scrollIntoView({ behavior: "smooth", block: "start" })
    }
    else {
      document.addEventListener("turbo:frame-load", (e) => { this.#scrollWhenLoaded(e) })
    }
  }

  #checkFrame(e) {
    if (this.formFrame.innerText) { e.preventDefault() }
  }

  #hideForm() {
    this.formFrame.style.display = "none";
    this.formPosition = "none"
  }

  #showForm() {
    this.formFrame.style.display = "";
  }

  #scrollWhenLoaded(e) {
    if (e.target == this.formFrame) {
      this.footer.scrollIntoView({ behavior: "smooth", block: "start" })

      document.removeEventListener("turbo:frame-load", (e) => { this.#scrollWhenLoaded(e) })
    }
  }
}