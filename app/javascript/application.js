// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import {Turbo} from "@hotwired/turbo-rails"

// see: https://www.youtube.com/watch?v=OZuLvOYy1Ss
// turbo_stream.action(:redirect, comments_path)
Turbo.StreamActions.redirect = function() {
  Turbo.visit(this.target)
}