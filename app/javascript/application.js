// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
//= require clipboard

document.addEventListener("load", function () {
    new ClipboardJS('.copy-link-btn');
});


