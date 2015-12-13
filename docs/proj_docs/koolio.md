# KOOLIO

## Introduction

Koolio is a social network website that let users create and share two-sided
flippable cards (flashcards). Users can group cards with decks, which can also
be shared to other users. Since the type of contents on each side of the card
is decided by the user, the cards are flexible and can convey various kinds
of information in ways that can reflect the user's personality. Since cards
are flippable, they may attract users to know what is on the other side.

## Project Objectives

Posts on current social media are getting lame, and mostly useless for the
users. We need more cool stuff. It is cool to share moments, thoughts,
knowledge via a social media platform, but it is even cooler to exhaust the
creativity of the users, so that their effort is rewarded by other users'
interaction with their posts; not just likes, comments - but flipping and
look what's on the other side. And they want to have their effort rewarded.
Cool platform. That is what Koolio aims to do.

We believe this project is going to reflect the true creativity of the internet.
Its potential cannot be described before it is released. Think about it,
decks of cards of two sided information. A little guidance can explode
a user's interest.

## Site User Roles

In general, users can be "editors", "visitors".

As editors, users create decks and cards, and they are the source of the
content for the website; they can also share decks/cards as public, or
to a specific set of users as visitors or editors (for decks). As visitors,
users can view public decks/cards, and can view decks/cards that are specifically
shared to them.

## Functional Requirements Per User Role

#### Editor:

* **Create cards by editing both sides**. First choose the type of content on
  that side, then go through a simple process to provide the content. The
  cards will go to "default" deck by default; but user can decide to put
  the card in another deck.
* **Create decks with a title and description and tags.** The process of setting
  up a new deck is simple. 
* **Choose the scope of the deck.** The default scope is "public". But the user
  can change it to specific set of people. Temtative sets are "mutual followers",
  "followers", "certain people", "private".
* **Choose the scope of a card in a deck.**  The cards inside a non-public deck has the
  same scope by default. The user can later set certain cards to "private", or only
  viewable by "certain people", even though the deck is shared with more people.
* **Share a deck to other users as "editor"**, which means the shared users can
  also create or edit or delete cards in the deck.

#### Viewer

* **View the other side of the card by a click.**.
* **Follow a user.** The viewer's suggestion page will display cards made by
  the followed user. Viewer can also unfollow.
* **Make comment on a card.**
* **Like a card or comment.**
* **Mark a deck as favorite.** Without following the author, the user can get
  the updates of that particular card in the viewer's suggestions page.
* **Identify mutually-followed users.** The viewer should be able to know who
  is mutual-follow relationship with him/herself.
* **Recommend content (card, deck) to mutually followed user.** This will result
  in a notification in the target user.
* **Search for cards/decks.** Type keyword in the searchbar, cards/decks of
  relevance will show up. By default, the user searches for decks and cards
  simoutaneously.
