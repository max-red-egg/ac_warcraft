# ALPHACamp 程式學習魔獸爭霸
Demoday project by 賣紅蛋小隊
__
## install project
Fork之後請先bundle以及資料庫遷移  
```bash
$ bundle install
$ rails db:migrate
```

## figaro gem setup
```bash
bundle exec figaro install
```
此檔案用來管理專案的環境變數，會自動加進`.gitignore`中。

## Secret Key File Configuration
```bash
$ rails secret
```

將產生的key貼到 `config/application.yml`
```yml
SECRET_KEY_BASE: <GENERATED_KEY>
```
then copy the key to config/secret.yml
```yml
development:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>

test:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
```

## Database initialization
Install PostgreSQL on your local machine
在本地端安裝好PostgreSQL之後請新增開發與測試用資料庫
```bash
$ createdb acwarcraft_development
$ createdb acwarcraft_test
```

## Generate seed data and fake user
```
$ rails dev:fake_all
```

## Github登入相關設定
先到[這裏](https://github.com/settings/applications/new)註冊你的app  
url 設定為http://localhost:3000/   
callback url 設定為 http://localhost:3000/users/auth/github/callback
完成註冊程序後將GITHUB_ID以及GITHUB_SECRET存到`config/application.yml`
```yml
GITHUB_KEY: <輸入產生的key>
GITHUB_SECRET: <輸入產生的secret>
```

## 測試相關  
測試本專案  
```bash
$ rails test
```

用guard來即時測試修改的檔案  
```bash
$ bundle exec guard
```

