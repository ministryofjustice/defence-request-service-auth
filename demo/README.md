# DS Auth Demo App

This is a very basic Rails application to illustrate how to use the
`ds-auth-omniauth` gem.

## Usage
Visit the root of the site and you should be redirected to the Auth app
to log in. Once logged in, you will be redirected back to the
application.

## Environment Variables
see .example.env

## Local Setup
To get the application running locally, you need to:

 * ### Install ruby 2.2.2
 	It is recommended that you use a ruby version manager such as [rbenv](http://rbenv.org/) or [rvm](https://rvm.io/)

 * ### Bundle the gems
       cd demo
       bundle install

 * ### Register the application in the Auth app

 Log into the Auth, visit `/oauth/applications`, and create a new
application.

 * ### Configure the application

 Create a new `.env.local` file within the root of this demo project,
and assign values for the required `ENV` variables as per
`.example.env`. The `DS_AUTH_APPLICATION_ID` and
`DS_AUTH_APPLICATION_SECRET` values can be found as part of the last
step.

 * ### Start the server
 		bundle exec rails server

 * ### Use the app

 	You can find the service app running on `http://localhost:3000`
