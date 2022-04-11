# ez-on-rails
This package provides a set of generators to develop a full backend server in Rails including views for administrators to manage the data and an API to provide those data to clients.

It provides a set of generators to create the application, scaffolds including its administration views and api endpoints.

The administration view is customizable over a set of partials and the scaffolds render information given by its helpers that are generated automaticly.

The full documentation is currently only available in German, you can read it [here](https://github.com/D4uS1/ez-on-rails/blob/main/EzOnRails/README.md).
I will create an english version that is more structured in the near future.

Note that the engine is placed in the [EzOnRails](https://github.com/D4uS1/ez-on-rails/tree/main/EzOnRails) Directory of this repository. 
The root directory contains an test application that can be started via Docker to test the engine.
The rails way to test the engine using a dummy app did not work here, because there were some issues related to webpacker.
After hours of trying to get it work i decided to just create a full test application.

