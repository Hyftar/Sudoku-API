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

This API uses JWT authentication, which means that every requests needs the header `Authorization: <KEY>`

You can receive a key for a user by submitting a POST request to the `/authenticate/` route containing the user name and password as **parameters** (`username: <USERNAME>` and `password: <PASSWORD>`)

The request will return the JWT for the user that will expire after 24 hours, after which, the user has to authenticate again.

#### Starting a game

To start (join) a game, you need to send a *POST* request to `/join/`,
this request may contain a `board_id` parameter which specifies the board
on which the user wants to play on. Like so:

```json
{
    "board_id": "294"
}
```

#### Playing in a game

Once the user has started a game, he may start sending requests to `/play/`,
a *GET* request will display the current state of the board.
While a *POST* request with the following parameter structure as the body of the request
will play on the board:
```json
{
    "play": {
        "position": "52",
        "content": "3"
    }
}
```

After making a move, the response contains information about the current state of the board.

Once a board is completed, the game will automatically be finished, and the
user will be free to start a new game.

#### Exiting a game before completion

A game can be exited before completion by sending a *DELETE* request to `/quit/`

#### Getting highscores

You can get the highscores of a specific board by sending a *GET* request to
`/scores` with the `board_id` as the body of the request. Like so:

```json
{
    "board_id": "3223"
}
```
