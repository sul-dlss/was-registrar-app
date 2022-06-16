// Entry point for the build script in your package.json
import * as bootstrap from "bootstrap";
import {DataTable} from "simple-datatables"
import "@hotwired/turbo-rails"
import "./controllers"

document.addEventListener("turbo:frame-render", function() {
  const collectionTable = document.querySelector("#collection-table")
  if(collectionTable) {
    const dataTable = new DataTable(collectionTable, {
      paging: false,
      labels: {
        placeholder: 'Filter...',
      },
      columns: [{ select: 0, sort: 'asc' }]
    });
  }
  const registrationTable = document.querySelector("#registration-jobs-table")
  if(registrationTable) {
    const dataTable = new DataTable(registrationTable, {
      labels: {
        placeholder: 'Filter...',
      },
      perPage: 25,
      perPageSelect: false
    });
  }
} );
