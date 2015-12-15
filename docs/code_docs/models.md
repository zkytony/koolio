# Models

## User

The User model represents a user. A user has these properties:

* username _required, unique, length <= 25_
* email _required, unique, well-formatted, length <= 255_
  * Regular expression for valid email is given by: `/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i`
* password _required, length >= 6_
  * `has_secure_password` is enabled
* first_name
* last_name
* birthday
* gender
* activated _default:_ `false`
* created_at
* updated_at

A user has many `cards`, `decks`, and `comments`,
which are the major models that can be created by a user. A user can _follow_
another user and can _be followed_ by others. A user can _favorite_ a deck, _like_
a card, and _like_ a comment. A user can _share_ his deck to other users as visitors
or editors. A user can _recommend_ contents to other users. A user has many
_activities_ and _notifications_.

#### relations with `users` (meta):

A user `user_a` can follow (or unfollow) another user `user_b` by simply calling `
```ruby
user_a.follow(user_b)
user_a.unfollow(user_b)
```


It can be checked if `user_a` is following
`user_b` by

```ruby
user_a.following?(user_b)
```

It is also possible to check if `user_a` and
`user_b` are mutually following each other, by

```ruby
user_a.following_mutually?(user_b)
```

#### relations with `cards`:

Cards of a given `user` can be accessed by
```ruby
user.cards
```
When user is `destroyed`, cards
are `destroyed`. One can check if a user owns a card by calling:
```ruby
user.owns_card?(card)
```
A user can like a card by calling:
```ruby
user.like_card(card)
user.unlike_card(card)
```

To get all cards a user has liked:
```ruby
user.liked_cards
```

To know if a user likes a card:
```ruby
ruby.liked_card?(card)
```

#### relations with `decks`:

Very similar to cards, to access a user's decks:
```ruby
user.decks
```

When user is `destroyed`, decks
are `destroyed`. One can check if a user owns a card by calling:
```ruby
user.owns_deck?(deck)
```

To let a user favorite or un-favorite a deck:
```ruby
user.favor_deck(deck)
user.unfavor_deck(deck)
```

To know if a user is favoring a deck:
```ruby
user.favoring_deck?(deck)
```

To get all decks that a user is favoring:
```ruby
user.favorite_decks
```

A user can share decks to other users as visitor or editor. Refer to
the documentation of `Deck` model for more about the `share_to` function.
A user can turn down such a deck sharing via:
```ruby
user.turndown_deck_share(deck)
```
This way the deck will not be considered shared to this user.

A user can recommend a `recommendable` to another user. `recommendable`
can be cards, decks and so on. For example:
```ruby
user_a.recommend_to(user_b, card)
```
A recommendation can be cancelled:
```ruby
user_a.cancel_recommendation(user_b, card)
```
A user can also choose to ignore the recommendation by turning it
down, so that this recommendable object will not be considered
as recommended to this user.
```ruby
user_a.turndown_recommendation(user_b, card)
```

#### relations with `comments`:

Very similar to `decks` and `cards` in the usual aspects, these are the
functiona for interacting with a user's comments or other users' comments:

User creates a comment on the given card with given message
```ruby
`user.comment(card, message)`
```

User builds but not creates a comment using `comment_params`. Refer to
`Comment` model for what the `comment_params` may contain.
```ruby
user.build_comment(comment_params)
```

User can like unlike a comment and check likedness:
```ruby
user.like_comment(comment)
user.unlike_comment(comment)
user.liked_comment?(comment)
```

Technically comments are made to cards. But one can get all
comments that a user made by simply using:
`user.comments`
