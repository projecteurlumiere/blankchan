import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("hello world");
    this.scale = 1

    this.#configureLightbox();

    this.#configureZoom();

    this.#configureShowcases();
  }

  #configureLightbox() {
    this.lightbox = document.querySelector("#lightbox");
    this.#configureLightboxExit()
  }

  #configureLightboxExit() {
    document.addEventListener("click", () => {
      if (this.lightboxDisplay < 1) { this.lightboxDisplay++; return }
      console.log("i'm on fire")
      this.lightbox.innerHTML = ""
      this.lightbox.style.transform = "";
      this.scale = 1
      this.lightboxDisplay = 0
    })
  }

  #configureZoom(){
    document.addEventListener("wheel", (e) => {
      if (this.lightboxDisplay < 1) return
      e.preventDefault();

      this.lightbox.style.transform = `translate(-50%, -50%) scale(${this.scale})`;

      this.scale += e.deltaY * -0.01;

      // Restrict scale
      this.scale = Math.min(Math.max(0.125, this.scale), 4);
    },{ passive: false })
  }

  #configureShowcases(){
    let showcases = document.querySelectorAll(".images-showcase");

    showcases.forEach(e => {
      e.addEventListener("click", (e) => {
        if (e.target.tagName.toLowerCase() != "img") return

        let link = e.target.getAttribute("data-full-link");

        this.lightbox.innerHTML = `<img src=${link}></img>`

        this.#adjustInitialSize(e);

        this.lightboxDisplay = 0
      })
    });
  }

  #adjustInitialSize(e) {
    let imageWidth = e.target.getAttribute("data-img-width");
    let imageHeight = e.target.getAttribute("data-img-height");

    let desiredHeight
    let desiredWidth

    if (imageWidth > window.innerWidth && imageHeight > window.innerHeight) {
      console.log("img is both");

      // AI generated piece starts
      let imageAspectRatio = imageWidth / imageHeight;
      let windowAspectRatio = window.innerWidth / window.innerHeight;

      if (imageAspectRatio > windowAspectRatio) {
        // Image is wider relative to its height than the window is, fit to window width
        desiredWidth = `${window.innerWidth - 20}px`;
        desiredHeight = "auto";
      } else {
        // Image is taller relative to its width than the window is, fit to window height
        desiredWidth = "auto";
        desiredHeight = `${window.innerHeight - 20}px`;
      }
      // AI generated piece over
    }
    else if (imageWidth > window.innerWidth) {
      console.log("img is wider than window");

      desiredWidth = `${window.innerWidth - 20}px`;
      desiredHeight = "auto";
    }
    else if (imageHeight > window.innerHeight) {
      console.log("img is higher than window");

      desiredWidth = "auto";
      desiredHeight = `${window.innerHeight - 20}px`;
    }

    this.lightbox.children[0].style.width = desiredWidth
    this.lightbox.children[0].style.height = desiredHeight
  }
}
