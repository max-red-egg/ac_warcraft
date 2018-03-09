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
  adapter: postgresql
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000

development:
  <<: *default
  database: acwarcraft_development

test:
  <<: *default
  database: acwarcraft_test

production:
  <<: *default
  database: acwarcraft_production

```
Install PostgreSQL on your local machine, and create a database "acwarcraft_development"

## Generate seed data and fake user
seed file generate a admin role
```
$ rails db:seed
```
fake user
```
$ rails dev:fake_user
```

