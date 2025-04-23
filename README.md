# README

This toy imageboard is my first time playing with the Ruby on Rails.
The name comes from it having no styles and being all white and blank
before I cloned one of the existing designs.

While it works, it's never been supposed to be deployed.

It has basic forum functions: 
creating posts and topics, attaching images, replying to posts, text formatting, user roles, and so on. 
Some sprinkles of Hotwire JS deliver user expiernce comparable to the existing imageboards: 
users can do infinite scroll for new topics and magnify attached images by clicking on them.

Blankchan also features a form of (custom) authentication for admin & moderator roles as well as for "premium" users.

With aggressive caching of single posts, it has acceptable performance when cache is warmed up.
While first visits to dev seeded pages are going to be fairly slow,
the subsequent visits to the same updated page tend to be quick enough.
Relying on CDN for image load would improve the performance considerably.

# Screenshots
<details>
  <summary>
    Posts (mobile layout)
  </summary>
  
  ![Posts](https://github.com/user-attachments/assets/87673f13-2295-4c32-8dc9-bfe42a088bc4)

</details>
<details>
  <summary>
     Topics (desktop layout)
  </summary>

  ![Topics](https://github.com/user-attachments/assets/4d91f27f-2983-4b3a-bb32-8d7880cab245)

</details>
<details>
  <summary>
    Foldable new post form; design is as old school as the genre suggests
  </summary>
  
  ![Admin dashboard](https://github.com/user-attachments/assets/d844ac66-f519-4ab6-9d85-f9030305e66b)

</details>

<details>
  <summary>
    One of the two grim admin dashboards
  </summary>

  ![Admin dashboard](https://github.com/user-attachments/assets/e6ac9994-b6ce-4215-8c53-98a487c1ba53)

</details>

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
