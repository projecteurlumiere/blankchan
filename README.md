# README

This toy imageboard is my first time playing with the Rails framework.
The name comes from it having no styles and being all white and blank
before I cloned one of the existing designs.

It has basic functions of creating posts and topics, attaching images, replying to posts, and so on.
It also has some form of (custom) authentication in place, and admin & moderator roles.

With aggressive caching of single posts, it has acceptable performance when cache is warmed up.
While first visits to dev seeded pages are going to be fairly slow,
the subsequent visits to the same updated page tend to be quick enough.
Relying on CDN for image load would improve the performance considerably.

## Dependencies
- Ruby 3.2.2
- PostgreSQL
- libvips

## Development Setup
### First launch

- Install Ruby dependencies:
```sh
  bundle i
```

- Migrate the database:
```sh
  bundle exec rails db:migrate
```

- Before seeding the db, adjust the number of desired forums, topics and posts in `db/seeds.rb`.

Seeding with the existing configuration will *take time*. If you don't have it, reduce the number of boards, topics per board, and posts per board to be created.

```ruby
  n_boards = 10
  n_topics = 30
  n_posts = 250
  n_pics = 1..3 # per post
  n_total_pics = 25 # variety of fake pictures
```

Note that at least one board is seeded with images so that you can appreciate Blankchan being an *image*board.

- Seed the db
```sh
  bundle exec rails db:seed
```

- Turn on caching in the development environment
```sh
  bundle exec rails dev:cache
```

- Consult `db/passcode.txt` to obtain admin's passphrase if you want to test admin's functions

### Launching dev server
```sh
  bundle exec rails s
```
