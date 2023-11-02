import { Controller } from "@hotwired/stimulus"
import { Lightbox } from "lightbox";

export default class extends Controller {
  connect() {
    let picsNodelist = document.body.querySelectorAll(".images-showcase");
    this.lightbox = new Lightbox(picsNodelist);
  }
}
