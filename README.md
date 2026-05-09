# Blog Rails Application

A small Ruby on Rails blog demo featuring:

- Posts CRUD
- Nested comments for each post
- User authentication with sessions

## Getting Started

### Prerequisites

- Ruby (compatible with Rails 8.1)
- SQLite3
- Bundler

### Setup

From the `blog` directory:

```bash
bundle install
bin/setup
```

This will install gems, prepare the database, and start the development server unless you pass `--skip-server`.

### Run the app

```bash
bin/dev
```

Then open `http://localhost:3000` in your browser.

### Run tests

```bash
bundle exec rails test
```

## App Features

### Posts

- Create, read, update, and delete blog posts
- Posts use Action Text for rich content (`has_rich_text :body`)
- Posts display comments on the show page

### Comments

- Nested resource under posts
- Comments broadcast updates to the associated post

### Authentication

- Session-based login using `User.authenticate_by`
- Sign in, sign out, and password reset support
- Sessions are stored server-side and tracked by cookie
- Default seed user:

```text
email_address: user@example.com
password: password
```

## Database

This app uses PostgreSQL by default. The database is configured in `config/database.yml`.

## Notes

- `bin/setup` can be used anytime to refresh dependencies and database state
- Root path is set to `users/posts#index`
- Authentication is enforced by default for all controllers, with unauthenticated access allowed for login and password reset actions
