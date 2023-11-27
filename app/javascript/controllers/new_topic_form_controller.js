import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.link = document.getElementById("new-post-form-link")
    // this.formFrame = document.getElementById("new-post-form");
  }

  scrollToTop(){
    this.link.scrollIntoView({ block: "start", behavior: "smooth"});
  }

}