import { Application } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails"; // Import Turbo

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

// Start Turbo
Turbo.start();


export { application };
