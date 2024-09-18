import { Application } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails"; // Import Turbo
import { Rails } from "@rails/ujs";
const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

// Start Turbo
Turbo.start();
Rails.start();

export { application };
import Rails from "@rails/ujs";
