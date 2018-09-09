# jbuilder-optionals
optional fields for jbuilder templates


## Installation
Add `jbuilder_optionals` to your Gemfile and `bundle install`:

``` ruby
gem 'jbuilder_optionals'
```
## Getting Started
after using this gem you can add optional fields on jbuilder template and when you want render tell template what fields you want to use in render 

### optional fields
``` ruby
#app/views/partials/_user.jbuilder

json.id user.id
json.optional! :username, user.username
json.optional! :phone, user.phone
```
``` ruby
json.partial! 'partials/user', user: @user
#will render: {id: 1}
```
now only you need specify what fields contains
``` ruby
json.partial! 'partials/user', user: @user, contains: [:username]
#will render: {id: 1, username: 'wise_moe'}
```

### optional partials
also you can use partials as a optional field in another partial


``` ruby
#app/views/partials/_pet.jbuilder

json.id pet.id
json.optional! :name, pet.name
```
``` ruby
#app/views/partials/_user.jbuilder

json.id user.id
json.optional! :username, user.username
json.optional! :phone, user.phone
json.optional_partial! :pet, user.pet
```
``` ruby
json.partial! 'partials/user', user: @user, contains: [:username, :pet]
# will render: {id: 1, username: 'wise_moe', pet: {id: 1}}
```
``` ruby
json.partial! 'partials/user', user: @user, contains: [:username, pet: [:name]]
# will render: {id: 1, username: 'wise_moe', pet: {id: 1, name: 'canary'}}
```

if you have many pets all of them will be render

``` ruby
#app/views/partials/_user.jbuilder

json.id user.id
json.optional! :username, user.username
json.optional! :phone, user.phone
json.optional_partial! :pets, user.pets
```
``` ruby
json.partial! 'partials/user', user: @user, contains: [:username, :pets]
# will render: {id: 1, username: 'wise_moe', pets: [{id: 1}, {id: 2}]}
```
``` ruby
json.partial! 'partials/user', user: @user, contains: [:username, pets: [:name]]
# will render: {id: 1, username: 'wise_moe', pets: [{id: 1, name: 'canary'}, {id: 2, name: 'giraffe'}]}
```

