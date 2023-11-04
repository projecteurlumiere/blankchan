//* primitive image preview (like lightbox)
//* functionality: open on click, fits all screens, scrolling to zoom, close on click anywhere
//* creates event listeners if constructor supplied with picsNodelist,
//* otherwise works with stimulus (it will track img tags in the tag attached to stimulus controller - simply call selectOnePicByEvent(e) in the controller)
// * Zoom step (-0.2 ~ 20% by default)
// requires an empty div to function (html id #lightbox by default)
// requires img's width and height. by default it looks for attributes in the img (data-img-width & data-img-height) to calculate initial size
//! does not calculate img's dimensions on its own
// TODO calculate position depending on cursor's position (zoom to cursor, etc)

class Lightbox {
  constructor({
    picsNodelist,
    lightboxTag = document.body.querySelector("#lightbox"),
    zoomStep = -0.2
  } = {} ) {
    this.lightbox = lightboxTag;
    this.#configureLightbox(zoomStep);
    if (picsNodelist) this.#selectPics(picsNodelist);
  }

  selectOnePicByEvent(e) {
    if (e.target.tagName.toLowerCase() != "img") return

    this.#openLightbox(e);
  }

  #configureLightbox(zoomStep) {
    this.#configureLightboxExit();
    this.#configureZoom(zoomStep);
  }

  #configureLightboxExit() {
    document.body.addEventListener("click", () => {
      // * clicking on pic fires a click event
      // * this event listener catches the same event later
      // * in order this event not to close the picture prematurely, lightboxDisplay is introduced in (openlightbox) to skip the first event
      if (this.lightboxDisplay < 1) { this.lightboxDisplay++; return }

      this.#resetLightbox();
    })
  }

  #configureZoom(zoomStep){
    this.scale = 1;

    document.body.addEventListener("wheel", (e) => {
      if (this.lightboxDisplay != 1) return
      if (!this.lightbox.classList.contains("lightbox-active")) return

      e.preventDefault();

      this.scale += Math.sign(e.deltaY) * zoomStep; // btw, if zoomStep is positive, it will invert mouse wheel action
      this.scale = Math.min(Math.max(0.125, this.scale.toFixed(3)), 4); // restricts scale & removes long floating point

      if (Math.abs(1 - this.scale).toFixed(3) < Math.abs(zoomStep) && this.scale != 1) this.scale = 1 // return to 1 size if it's kinda close

      this.lightbox.style.transform = `translate(-50%, -50%) scale(${this.scale})`;
    },{ passive: false })
  }

  #selectPics(picsNodelist){
    picsNodelist.forEach(e => {
      e.addEventListener("click", (e) => {
        this.selectOnePicByEvent(e)
      })
    });
  }

  #adjustInitialSize(e, imageWidth = e.target.getAttribute("data-img-width"), imageHeight = e.target.getAttribute("data-img-height")) {
    let desiredHeight, desiredWidth

    if (imageWidth > window.innerWidth && imageHeight > window.innerHeight) {
      [desiredWidth, desiredHeight] = this.#initialSizeForLargeImage(imageWidth, imageHeight);
    }
    else if (imageWidth > window.innerWidth) {
      [desiredWidth, desiredHeight] = [`${window.innerWidth - 20}px`, "auto"];
    }
    else if (imageHeight > window.innerHeight) {
      [desiredWidth, desiredHeight] = ["auto", `${window.innerHeight - 20}px`]
    }

    this.lightbox.children[0].style.width = desiredWidth
    this.lightbox.children[0].style.height = desiredHeight
  }

  #initialSizeForLargeImage(imageWidth, imageHeight) {
    // AI generated piece starts
    let imageAspectRatio = imageWidth / imageHeight;
    let windowAspectRatio = window.innerWidth / window.innerHeight;

    if (imageAspectRatio > windowAspectRatio) {
      // Image is wider relative to its height than the window is, fit to window width
      [desiredWidth, desiredHeight] = [`${window.innerWidth - 20}px`, auto];
    } else {
      // Image is taller relative to its width than the window is, fit to window height
      [desiredWidth, desiredHeight] = ["auto", `${window.innerHeight - 20}px`]
    }
    // AI generated piece over

    return [desiredWidth, desiredHeight]
  }

  #openLightbox(e) {
    let link = e.target.getAttribute("data-full-link");

    if (this.lightbox.innerHTML.includes(link)) { this.#resetLightbox(); return }

    this.#resetLightbox();
    this.lightbox.innerHTML = `<img src="${link}">`
    this.lightbox.classList.add("lightbox-active")
    this.#adjustInitialSize(e);
    this.lightboxDisplay = 0
  }

  #resetLightbox() {
    this.lightbox.innerHTML = "";
    this.lightbox.classList.remove("lightbox-active")
    this.lightboxDisplay = 0;
    this.scale = 1;
    this.lightbox.style.transform = "";
  }
}

export { Lightbox }