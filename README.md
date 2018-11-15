# Starter Application

## Prerequisites

1. Install Ruby via [RailsInstaller](http://railsinstaller.org/en) *(install latest version)*

2. ```
   bundle install --without production
   ```
   ​
## Running the Application
1. Install the rerun gem: `gem install rerun`

2. ```
   rerun 'bundle exec ruby app.rb'
   ```
   ​

## What is in the box

1. Authentication System: "/login", "/logout", "/sign_up"

2. User model

3. Bootstrap

   ​


## Protecting pages from non-signed in users

### authenticate!

I have created a helper method `authenticate!` which, when called, will redirect the user to the sign in page if they are not signed in. This will help you protect pages that should only be accessed by signed in users.

To define a URL in which the person must be signed in to view, use the `authenticate!` method.

For example:

```ruby
get "/dashboard" do 
  authenticate!
  erb :dashboard
end
```



### Who is Signed in?

To get information about the current signed in user, use the `current_user` method which returns the user object of the current signed in user or `nil` if no one is signed in.

In a template:

```erb
Hello <%= current_user.email %>
```



In code:

```ruby
get '/say_hello' do
	if current_user
      return "Hello #{current_user.email}!"
    else
      return "Hello World!"
    end
end
```



## Deploying to Heroku

### Deployment Instructions

1. Add all your changes on git and make a commit
2. Create a Heroku server: `heroku create`
3. Create a database for your server: `heroku addons:create heroku-postgresql:hobby-dev`
4. Push the code to Heroku: `git push heroku master`
5. I preconfigured the necessary files for this to work.
6. Verify all is working and submit your links (github and heroku) to me.