# ez-on-rails
This package provides a set of generators to develop a full backend server in Rails including views for administrators to manage the data and an API to provide that those data to clients.

The generators help creating the application, scaffolds including its administration views and api endpoints.

The administration view is customizable by a set of partials and the scaffolds render information given by its helpers that are generated automatically.

Note that the engine is placed in the [EzOnRails](https://github.com/D4uS1/ez-on-rails/tree/main/EzOnRails) Directory of this repository. 
The root directory contains a test application that can be started via Docker to test the engine.
The rails way to test the engine using a dummy app did not work here, because there were some issues related to webpacker.
After hours of trying to get it work i decided to just create a full test application.

You can have a look at the [documentation in the wiki](https://github.com/D4uS1/ez-on-rails/wiki/Documentation) to see how to install and use ez-on-rails.
