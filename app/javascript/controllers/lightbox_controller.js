import { Controller } from "@hotwired/stimulus"
import { Lightbox } from "lightbox";

export default class extends Controller {
  connect() {
    this.lightbox = new Lightbox();
  }

  showPic(e) {
    this.lightbox.selectOnePicByEvent(e);
  }
}
