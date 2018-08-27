[![Build Status](https://travis-ci.org/MLSDev/rails-chats-api.svg?branch=master)](https://travis-ci.org/MLSDev/rails-chats-api)

# Rails Chats API - Sample Application

## Install

### Clone repository
```
git clone https://github.com/MLSDev/rails-chats-api
```

### Install gems
```
cd rails-chats-api
```

```
bundle install
```

### Run migrations
```
rake db:migrate
```

### Run specs
```
rake
```

### Run server
```
rails s
```

## API documentation

### Sign Up
```
curl -H 'Accept: application/json' \
     -d 'user[email]=john@mcclane.com&user[password]=superhero&user[password_confirmation]=superhero' \
     localhost:3000/profile
```

### Sign In
```
curl -H 'Accept: application/json' \
     -d 'session[email]=john@mcclane.com&session[password]=superhero' \
     localhost:3000/session
```

### Get own Profile info
```
curl -H 'Accept: application/json' \
     -H 'Authorization: Token token="XXXX-YYYY-ZZZZ"' \
     localhost:3000/profile
```

### Show Profile Chats (Chat Index)
```
curl -H 'Accept: application/json' \
          -H 'Authorization: Token token="XXXX-YYYY-ZZZZ"' \
          localhost:3000/chats/
```

### Create Chat
```
curl -H 'Accept: application/json' \
     -H 'Authorization: Token token="XXXX-YYYY-ZZZZ"' \
     -d 'chat[recipient_id]=:id' \
     localhost:3000/chats
```

### Join in the Chat
```
curl -H 'Accept: application/json' \
     -H 'Authorization: Token token="XXXX-YYYY-ZZZZ"' \
     -X POST localhost:3000/chats/:id/add
```

### Leave Chat
```
curl -H 'Accept: application/json' \
     -H 'Authorization: Token token="XXXX-YYYY-ZZZZ"' \
     -X DELETE localhost:3000/chats/:id/leave
```

### Show Chat
```
curl -H 'Accept: application/json' \
     -H 'Authorization: Token token="XXXX-YYYY-ZZZZ"' \
     localhost:3000/chats/:id
```

### Message Create
```
curl -H 'Accept: application/json' \
          -H 'Authorization: Token token="XXXX-YYYY-ZZZZ"' \
          -d 'message[body]=...' \
          localhost:3000/chats/:id/messages
```

### Message Index
```
curl -H 'Accept: application/json' \
          -H 'Authorization: Token token="XXXX-YYYY-ZZZZ"' \
          localhost:3000/chats/:id/messages
```