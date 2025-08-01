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
    '>=1.1.2',
    git: 'https://github.com/D4uS1/ez-on-rails',
    branch: 'v1.1.2'
```

Version branches start with "v" followed by the gems version number, e.g. "v1.0.0".

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

### 5. Restart your server
This is necessary due to some configurations that needs to be loaded on boot time.

### 6. Check if it works
Visit your application page in a browser. You should now see the ez-on-rails welcome page.
You can visit the login page by clicking on the user icon in the top right corner. 
If you sign in as administrator, an administrator menu will appear.
The default credentials were created in the seeds. Normally those are
* email: administrator@example.com
* password: <the secure random password that was generated by the generator and can be found in the db/seeds.rb file for the admin user>

## Example usage (Tutorial)
### 1. Generate some scaffolds
```
rails generate ez_on_rails:ezscaff Magazine title:string abo_price:integer
rails generate ez_on_rails:ezscaff Article title:string published_at:datetime magazine:belongs_to
```
This generates the scaffolds by creating the following things: 
* the controller having the default CRUD and some useful additional actions
* the views for those actions, written in [slim](https://github.com/slim-template/slim)
* the routes for those actions,
* a helper with a special render_info function to customize the appearance of the fields in this views
* json builders using [jb](https://github.com/amatsuda/jb)
* the model that has the necessary fields to work with the EzOnRails permission system
* the migration for that model
* i18n locale files (currently for german and english)
* model and request tests using [rspec](https://github.com/rspec/rspec-rails), including the factories using [factory bot](https://github.com/thoughtbot/factory_bot_rails)
* a default restriction entry in the seeds to restrict the access to admins

### 2. Migrate and seed
```
rails db:migrate
rails db:seed
```
The seeds are needed because the generator created the entries to restrict the access to the models scaffold actions into the seed file.

### 3. Add them scaffolds to the main menu
In our case, we want to see the magazines and articles in the main menu, hence users accessing the backend can navigate to them.

Open the file __app/helpers/ez_on_rails/menu_structure_helper.rb__.

Append the entries for the magazines and articles to the menu structure method. It should look like this:

```
...
  def menu_structure
    {
      main_menus: [
          ...
          {
            controller: 'magazines',
            action: 'index',
            label: Magazine.model_name.human(count: 2),
            invisible: false
          },
          {
            controller: 'articles',
            action: 'index',
            label: Article.model_name.human(count: 2),
            invisible: false
          },
          ...
      ]
    }
  end

```

Visit cour application page and sign into your super administrator account, you will now see the menu entries targeting the specified actions.

### 4. Restrict access to pages
Per default, the restriction in the seeds was generated for super admins.

But in our case, we would like to have the magazine and article pages accessible for authors.
We can change this by using the administration backend views.

1. Visit the user management page, by clicking on the administration menu entry, and navigate to the user management.
2. Navigate to the groups and create a group called __Author__, for now you can create every fields except the name
3. Navigate back to the user management (you can use the breadcrumbs) and go to the group accesses
4. Add two new entries for the created Author group, one for the controller __articles__ and one for __magazines__. In this case, the other fields needs to be blank, because we have no namespace, and we want to restrict all actions of the controller and not only a specific one.
5. Delete the access entry already created for the super admins to the controllers
6. Thats it, the access is now granted to people hwo are in the Author group
7. You can now add registered users to the author group. You can assign the groups in the user managements group assignments section. Feel free to test it by creating a test user, assign the authors group to him, and sign in the user.

So as you can see you can change the permissions in the administration backend, but this has one disadvantage. If you want to create the same permissions on other systems, like staging, tests or development systems, you need to recreate it. Hence lets create seed entries to make the changes permanent.

Open the file __db/seeds.rb__ and add the following lines:

Don't forget to remove the entry that was created by the generator, to restrict the access to the super administrator.
```
author_group = EzOnRails::Group.find_or_create_by! name: 'Author' do |group|
  group.name = 'Author'
end

EzOnRails::GroupAccess.find_or_create_by! group: author_group, controller: 'magazines' do |access|
  access.group = author_group
  access.controller = 'magazines'
end

EzOnRails::GroupAccess.find_or_create_by! group: author_group, controller: 'articles' do |access|
  access.group = author_group
  access.controller = 'articles'
end
```
Now everytime you call __rails db:seed__ the entries are generated.

### 5. Restrict access to persons hwo own the records
For now, all authors have access to all articles and magazines. But we dont want authors to be able to update the articles of other authors.

EzOnRails provides the ability to restrict access to records with ownerships. This means that if someone creates a record, he is the only person hwo can manage it.
This is what we need, hence let us create this.

1. Just as in the step before, visit the user management page via the Adinistration main menu and navigate to __ownership infos__
2. Create a new one and enter the resource name 'Article', you have to check the "has Ownerships" checkbox here.
3. Thats it, now only authors that created the article has access to the own articles

Like in the section before, if we want to have this change permanent, we can add it to the seeds:
```
EzOnRails::OwnershipInfo.find_or_create_by! resource: 'Article' do |ownership_info|
  ownership_info.resource = 'Article'
  ownership_info.ownerships = true
end
```

### 6. Change administration view
Lets create some magazines Just visit the magazines page via the menu entry and create some.

Lets now create some articles. As you can see, you can select the magazine the article belongs to in a dropdown, showing the id of the magazines. 
This is not very nice, we want to see the titles of the magazines here. 
We can change this by opening the file __app/helpers/articles_helper.rb__.

Here you can see a method called __render_info_article__. This is a basic concept of EzOnRails. The appearance of your models in the administration views can be changed here.
Change the entry for the magazines, by adding the following entry:
```
label_method: :title
```

The method should now look like this:

```
...
  def render_info_article
    {
      title: {
        label: Article.human_attribute_name(:title)
      },
      published_at: {
        label: Article.human_attribute_name(:published_at)
      },
      magazine: {
        label: Article.human_attribute_name(:magazine),
        label_method: :title
      }
    }
  end
...
```

Now create a new magazine or update an existing one. You can now see the titles instead of the ids in the magazine dropdown menu.
This is just one thing you can change here. The render info has many possibilities to adjust the appearance. You can read about the possibilities in the [documentation](https://github.com/D4uS1/ez-on-rails/wiki/Documentation).

### 7. Generate the api
Lets create an api for the articles, hence some client application can access our data.

```
rails generate ez_on_rails:ezapi Articles --resource Article --authenticable bearer
```

Thats it, you are now able to interact with the articles via a REST endpoint located in __api/articles__.
Visit the page __/api-docs/index.html__ of your application. You can see the openapi documentation here.

The generator created the following things:
* The api controller for the default CRUD actions, and some useful additional actions
* The routes for those actions
* The views using the json builders for those actions
* Swagger schemas for the openapi documentation
* Request and Integration tests using rspec
    * The integration spec uses [rswag](https://github.com/rswag/rswag) to generate the openapi definition from the spec
* Restrictions in the seed file to restrict the access to the api for only users that are signed in

The restriction for signed in users is done by assigning the access to the __Member__ group
Feel free to change this for your needs, like you did it for the direct access to the administration view.
The only thing you need to mention about here is, that you need to pass the namespace __api__ to the access entries.

If you are using React, you can use the [ez-on-rails-react](https://github.com/D4uS1/ez-on-rails-react) package to interact with the api.
This package provides components and hooks to use ez-on-rails from the client side.

### 8. Checkout the docs
This was just a small tutorial for the usage of EzOnRails. It provides many more features and concepts to customize the backend for your needs.

Visit the [documentation](https://github.com/D4uS1/ez-on-rails/wiki/Documentation) for details. It is recommended to have a look at the basic concepts and the possibilities.

## Development notes
Note that the engine is placed in the [EzOnRails](https://github.com/D4uS1/ez-on-rails/tree/main/EzOnRails) Directory of this repository. 
The root directory contains a test application that can be started via Docker to test the engine.
The rails way to test the engine using a dummy app did not work here, because there were some issues related to webpacker.
After hours of trying to get it work i decided to just create a full test application.

You can have a look at the [documentation in the wiki](https://github.com/D4uS1/ez-on-rails/wiki/Documentation) to see how to install and use ez-on-rails.
