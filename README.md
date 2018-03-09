# ALPHACamp 程式學習魔獸爭霸
Demoday project by 賣紅蛋小隊
__
## install project
```bash
$ bundle install
```

## Secret Key File Configuration
```bash
$ rails secret
```
then copy the key to `config/secret.yml`
```yml
development:
  secret_key_base: <Generated key>
```
## Database initialization
create `config/database.yml`
```yml
default: &default
  adapter: sqlite3
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000

development:
  <<: *default
  database: db/development.sqlite3

test:
  <<: *default
  database: db/test.sqlite3

production:
  <<: *default
  database: db/production.sqlite3
```

