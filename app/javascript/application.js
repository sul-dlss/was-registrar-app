// Entry point for the build script in your package.json
import * as bootstrap from "bootstrap";
import {DataTable} from "simple-datatables"
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

// import HelloController from "./controllers/hello_controller"

window.Stimulus = Application.start()
// Stimulus.register("hello", HelloController)

document.addEventListener("DOMContentLoaded", function() {
  const dataTable = new DataTable("#collection-table", {
    paging: false,
    labels: {
      placeholder: 'Filter...',
    },
    columns: [{ select: 0, sort: 'asc' }]
  });
} );
