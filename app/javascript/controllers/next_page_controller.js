import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    let observer_options = {
      threshold: 1.0,
    };

    let observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.style.display = "none"
          entry.target.click();
        }
      })
    }, observer_options);

    observer.observe(this.element);
  }
}
