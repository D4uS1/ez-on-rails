# ez-on-rails

EzOnRails provides a rails backend that is ez to use with all your needs to build fast applications having a frontend and a backend.
It provides many features like a built in permission system, an easy to configure administration view, built in controllers with CRUD functionality, builtin features like searching, generators for your models, generators for your api etc.

Have a look at the [documentation](https://github.com/D4uS1/ez-on-rails/wiki/Documentation) to see the features and concepts.

You can make use of the [ez-on-rails-react](https://github.com/D4uS1/ez-on-rails-react) package to interact with the backend.
This provides components for user account management, like login, registration, password reset etc.
It also provides hooks to easily interact with the backend.

## Installation
It is recommended to install ez-on-rails only on new rails systems.
This gem was not yet tested on already existing systems.

### 1. Insert the gem to the Gemfile
```
gem 'ez_on_rails',
    '>=0.8.0',
    git: 'https://github.com/D4uS1/ez-on-rails',
    glob: 'EzOnRails/ez_on_rails.gemspec',
    branch: 'v0.8.0'
```

Version branches start with "v" followed by the gems version number, e.g. "v0.8.0".

### 2. run bundle install...
...and get some coffee...

### 3. Run the ezapp generator.
```
rails generate ez_on_rails:ezapp My-Application-Name
```
This copies the necessary files for the ez-on-rails engine.

### 4. Migrate and seed the database
```
rails db:migrate
rails db:seed
```
This will create the necessary database tables to get the [permission system](https://github.com/D4uS1/ez-on-rails/wiki/Permission-System) to work. 
The seeds are provided with default access restrictions to the [adminisration area](https://github.com/D4uS1/ez-on-rails/wiki/Administration-Area)

### 5. Check if it works
Visit your application page in a browser. You should now see the ez-on-rails welcome page.
You can visit the login page by clicking on the user icon in the top right corner. 
If you sign in as administrator, an administrator menu will appear.
The default credentials were created in the seeds. Normally those are
* email: administrator@example.com
* password: 1replace_me3_after3_install7

## Usage
### 1. Generate some scaffolds
### 2. Add them scaffolds to the main menu
### 3. Restrict access to pages
### 4. Restrict access to persons hwo own the records
### 5. Change administration view
### 6. Generate the api 
### 7. Test everything


## Development notes
Note that the engine is placed in the [EzOnRails](https://github.com/D4uS1/ez-on-rails/tree/main/EzOnRails) Directory of this repository. 
The root directory contains a test application that can be started via Docker to test the engine.
The rails way to test the engine using a dummy app did not work here, because there were some issues related to webpacker.
After hours of trying to get it work i decided to just create a full test application.

You can have a look at the [documentation in the wiki](https://github.com/D4uS1/ez-on-rails/wiki/Documentation) to see how to install and use ez-on-rails.
