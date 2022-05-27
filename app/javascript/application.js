// Entry point for the build script in your package.json
import * as bootstrap from "bootstrap";
import {DataTable} from "simple-datatables"

document.addEventListener("DOMContentLoaded", function() {
  const dataTable = new DataTable("#collection-table", {
    paging: false,
    labels: {
      placeholder: 'Filter...',
    },
    columns: [{ select: 0, sort: 'asc' }]
  });
} );
