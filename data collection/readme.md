# Data Collection
This folder contains the source code of the custom webapp we developed for data collection.

This webapp has been developed in Node.js with the following dependencies:

  * body-parser: 1.17.2;
  * express: 4.15.4;
  * express-handlebars: 3.0.0.

The source code has been organized according to the following structure:

* **data:** Folder that stores the collected data;
* **html:** Folder containing the static HTML pages of the webapp;
* **html > scenarios:** Folder containing all the scenarios used in our experiment;
* **node_modules:** Folder for node.js dependencies;
* **views:** Folder containing our handlebars HTML templates (i.e. the page that introduces a block; the page used in the trials, instructions, etc);
* **index.js:** The source code of the node.js server.
