# Hyftar Sudoku API

A simple, yet effective Sudoku game API built using Ruby on Rails v5.1.4

### Creating a user

Right now, user creation is handled via the Rails console, while it is not the
most convinient way to handle user creation, it is the simplest and most secure
way.

If you want to create a user, you can use the following commands:

`rails console`

`User.create!(name: 'USERNAME', password: 'PASSWORD', password_confirmation: 'PASSWORD' [, admin: true])`

(The parameter marked between brackets is optional and will default to false if not specified)

### Using the API

This API uses JWT authentication, which means that every requests needs the header `Authentication: <KEY>`

You can receive a key for a user by submitting a POST request to the `/authenticate/` route containing the user name and password as **parameters** (`username: <USERNAME>` and `password: <PASSWORD>`)

The request will return the JWT for the user that will expire after 24 hours, after which, the user has to authenticate again.
