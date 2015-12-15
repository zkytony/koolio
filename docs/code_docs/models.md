# Models

All models inherit from `ActiveRecord::Base`

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
_activities_ and _notifications_. A user is also _trackable_, in a sense that
events such as following another user is an activity of User model.
Also, a user has many _uploaded\_files_.

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

To access shared decks of variaous types, here are some examples:
```ruby
# Get all decks this user can edit, including those that he created
user.editable_decks
# Get only decks that are shared to this user for view
user.decks_shared_for_view
```

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
user.comment(card, message)
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

## Deck

The Deck model represents a deck, which is used to store cards. A deck
belongs to one user, the creator of the deck.  A deck has these properties:

* title _required, length <= 175_; the title for the deck.
* description 
* user_id _required_; the creator's user id
* open _default_ `true`. _true or false only_; whether this deck is open to the public or not
* created_at
* updated_at

As mentioned before, a deck _belongs to its creator_ and it has many _cards_.
Yet this deck can be _shared to_ other users as editors or viewers. A deck also
has many _tags_, which help categorize this deck. A deck is _recommendable_ and
_trackable_, which means it can be recommended by one user to another, and it
has trackable activities. These are discussed later. A deck can be _favored_
by a user.

#### relations with `users`:

To get the creator of a `deck`, one should use:
```ruby
deck.creator
```

To check if a given user is the creator of this deck:
```ruby
deck.creator?(user)
```

##### Share to

A deck can be shared to another user, with a given role. Role can either
be `"editor"` or `"viewer"`, case-insensitive. Returns `false` when
given other values. For example:
```ruby
deck.share_to(user, "viewer")
deck.share_to(user, "editor")
deck.share_to(user, "spokesman") # returns false
```
Presumably `share_to` is called when it is verified if the `current_user`
can edit this `deck`. But this has not been guaranteed yet.

Also, a deck can be `unshared` to a given user. Returns false if the
given user is the creator of this `deck`, because unsharing is not possible.
Returns true otherwise, including the case when the given user is not
shared before.
```ruby
deck.unshare(user)
```

Here are some ways to access the shared users:
```ruby
# Get all shared users
deck.shared_users
# Get only editors
deck.editors
# Get only viewers - those who cannot edit the deck
deck.normal_viewers
```

The role of the shared user can be changed. As `share_to`, the role
can only be `"editor"` or `"viewer"` case insensitive. Returns `false`
when given other values. For example:
```ruby
# If the user was shared to as viewer, his role can be changed to editor
# like this:
deck.change_share_role(user, "editor")

deck.change_share_role(user, "spokesman") # returns false
```
**TODO**: unknown behavior when user is not shared to already.

Given a user, the deck can check if that user can editor or view this deck:
```ruby
# editable only when the given user has the permission to edit the deck.
deck.editable_by?(user)
# viewable if the deck is open, or if the deck is shared to that user.
deck.viewable_by(user) 
```

##### Recommend by

A deck may be recommended by a user to another. One can check that by:
```ruby
deck.is_recommended_by?(user)
deck.is_recommended_to?(user)
```

#### relations with `cards`:

To add a card to a `deck`, it is preferred to call:
```ruby
deck.build_card(card_params, user)
```
which will check if `deck` is editable by the given user.
If not, then the card will not be built.

#### relations with `tags`:
To get all tags of a `deck`, simply:
```ruby
deck.tags
```

To add a tag to a `deck`:
```ruby
deck.add_tag(tag_params)
```
Refer to Tag model for what `tag_params` may be

To remove a tag:
```ruby
# Given a tag model
deck.remove_tag(tag)
```

To remove all tags:
```ruby
deck.remove_all_tags
```

To obtain a string of all tags for this deck separated by comma:
```ruby
deck.tags_by_name
```

## Card

The Card model represents a card, which can hold contentds on both sides.
A card belongs to a user, which is its creator. It also belongs to the
deck that stores this card.

A card has these properties:

* front_content
* back_content
* deck_id  the id of the deck that holds this card
* user_id  the id of the user that created this card
* flips  the number of flips this card currently has
   **TODO:**This field currently has no actual functionality associated
* hide  _default_ `false`. If set to true, then this card is hidden and
  nobody but the creator can view it.
* likes  number of likes this card has currently
* created_at
* updated_at

A card belongs to one user and one deck. It has many _comments_. Users
can _like_ a card. A card is also recommendable and trackable, which means
a user can recommend a card to another user, and the activities of a card
can be tracked.

#### relations with `users`:

To get the creator of a `card`, one should use:
```ruby
card.creator
```

To check if a given user is the creator of this card:
```ruby
card.creator?(user)
```

To check if a user can view this card:
```ruby
card.viewable_by?(user)
```
This is true if the user is the creator, or if the card is not hidden and
its deck can be viewed by the given user.

Just like recommending decks, a user can recommend a card to another user.
To check if the card is recommended to or by a user:
```ruby
card.is_recommended_by?(user)
card.is_recommended_to?(user)
```

To get all users that liked this card
```ruby
card.liked_users
```

#### relations with `comments`:

To get all comments made to this card
```ruby
card.comments
```

## Comment

The Comment model represents one comment. It belongs to one user and one card.
Users can like a comment. A comment has these properties:

* content the text content of this comment
* user_id the id of the user that made the comment
* card_id the id of the card to which the comment is made
* likes the number of likes this comment currently has
* created_at
* updated_at

A comment is trackable.

#### relations with `users`:
To get the user that made the comment, simply:
```ruby
comment.user
```

To get all users that liked this comment:
```ruby
comment.liked_users
```

#### relations with `cards`:
To get the card that the comment is made to, simply:
```ruby
comment.card
```

## Tag

The Tag model represents a tag for a deck. It has a _many to many_
relationship with decks. A tag has these properties:

* name _required, unique_
* created_at
* updated_at

#### relations with `decks`:

To get all decks that has this `tag`, simply:
```ruby
tag.decks
```

## UploadedFile

The UploadedFile model represents a file uploaded by a user. It utilizes
the `carrier_wave` gem. It mounts the `UserFileUploader` to `name` field. An uploaded
file has thse properties:

* name  _required_ the file name
* type  _required, length <= 255_ the type of the file
* user_id _required_ the id of the user that uploaded the file
* created_at
* updated_at

For more details about how to use this model, please refer to the carrierwave gem.

## Recommendation

## Notification

## Activity

## LikeCard

## LikeComment

## Favorite

## Relationship
