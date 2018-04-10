# ALPHACamp 程式學習魔獸爭霸
Demoday project by 賣紅蛋小隊

## 目錄
 * [User Stroy](#user-stroy)
 * [專案初始化](#專案初始化)
 * [自動化測試](#自動化測試)


## User Stroy

### 目的

打造一個遊戲化專題 -- 找戰友解任務的程式學習平台。

主要解決的痛點為：如何挑選出適合的隊友。利用一系列篩選，互動，評價功能，幫助使用者找到「對的人」，一起學習。

### 產品故事

國家星際防衛部發現，有一個外星物種「霸格」已經入侵本國。「霸格」他神出鬼沒，潛入我們的生活中，近日發生的少子化、空氣汙染、人口老化，所有證據都指向是「霸格」所引起的。

經過防衛部多年來調查。「霸格」最害怕的就是乾淨無瑕的程式碼。由於防衛部被立法院砍預算，替代役又退場，人力嚴重不足，因此指派我 Mr.E，成立一個秘密ERM暗碼局，希望能秘密招募探員抵(抗)霸格，維護世界和平。

暗碼局的探員們平時隱藏身分，白天是菜販、工人、上班族、家庭主婦、學生，夜晚的時間便打開電腦，兩人組隊領取任務，撰寫乾淨無瑕的程式碼來消滅霸格。

抵霸格過程漫長且許辛苦，ERM 暗碼局希望能號召你一起加入！

### User Story

完整操作手冊請見[這裏](erm_manual.md)

#### 1.使用者相關

1. user 可以註冊
    * user 可以輸入 email 後註冊一個帳號
    * user 在註冊後，會收到註冊確認信（ Mailgun 串接 ）
    * user 可以透過 Github 帳號直接註冊與登入（ Github 串接 ）
2. user 可以編輯自己的 profile，包含
    * 個人資料
    * 頭像（ Gravatar 串接 ）
    * 邀請狀態設定：目前是否接收邀請
3. user 可以在探員資料庫，瀏覽其他探員資訊
    * 列出所有探員
    * 點擊其他探員，可以看到該探員資訊，包含
        * 基本資訊
        * 已完成的任務列表，與類型相關資訊
        * 過往團隊成員給的評價
    * 篩選出特定探員
4. user 可以追蹤其他探員

#### 2.挑戰任務與組隊功能（提供三種組隊方式，增加組隊完成率）

1. 任務挑戰
    * user 可以瀏覽任務清單，查看細節，
    * user 依喜好排序並篩選任務
    * user 可以挑選任務，開始任務挑戰
        * user 無法挑戰超過自己等級的任務
        * user 無法挑戰自己發起且尚未完成或取消的任務
    * user 可以組隊挑戰 2 人任務（三種組隊方式，下方詳述）
    * user 可以取消任務

2. **組隊方式 1**：篩選隊友，發出組隊邀請
    * user 可以在組隊畫面，篩選隊友，發出組隊邀請。篩選功能包含：
        1. 搜尋探員（姓名，Email）
        2. 排序探員（等級，姓名，評價高低...）
        3. 列出以下探員，增加篩選效率
            * 老隊友：曾合作且完成過任務的隊友
            * 自己追蹤的探員
            * 追蹤自己的探員
        4. 其他 user profile 欄位，如性別
        5. 篩選畫面自動排除（不顯示）
            * 目前不想接任務的探員（邀請狀態設定為 off ）
            * 等級不足的探員
    * user 可以其他探員資訊中，看到以下標示，可選擇性不要邀請，以降低邀請失敗率
        * 該探員：正在執行相同任務
        * 該探員：已經完成相同的任務
        * 該探員：已經拒絕過本次邀請（但仍可再次邀請，避免對方按錯後無法重邀）
    * user 可以在邀請函列表中，看到所有邀請函
        * user 可以在邀請函中，相互對話，討論任務細節
        * user 可以在邀請函中，選擇後續動作
            * 發起者：可取消邀請
            * 受邀者：可接受或拒絕邀請

3. **組隊方式 2**：從探員資料庫中，直接邀請特定好友
    * user 可以在探員資料庫中，直接選擇特定探員，邀請組隊
    * user 點擊探員邀請組隊後，可選擇任務
        * 僅會列出雙方皆能組隊的任務
    * user 發出邀請後，仍需對方同意，任務才會啟動

4. **組隊方式 3**：發動緊急招募
    * user 若認為組隊時間過長，可在任務組隊畫面發起緊急招募
    * user 可以在右側邊欄，看到緊急招募列表
    * user 其他探員若點擊接受任務徵召，組隊立即完成，任務開始
        * user 是否能接受任務徵召，仍須受任務等級限制  
    * user 在緊急招募發動期間，仍可依照正常流程進行組隊

#### 3.任務執行，提交答案，給予評價

1. user 可以在任務執行畫面，留下任務筆記
2. user 可以儲存答案，並多次修改，再提交答案，完成任務
    * user 可以直接透過 github 撈取 repo 網址，填入答案區
3. 完成任務後，若 user 尚未給予評價，系統做以下引導，增加評價率
    * 在側邊欄與歷史任務列表中，標示尚未給評的任務
    * 進入任務時，評價框需跳動，做出視覺引導
    * 未給予他人評價前，也看不到對方給自己的評價

#### 4.即時系統提醒（ Notification ），提高使用者互動

1. user 在以下情形，會接收到提醒
    * 其他使用者邀請自己
    * 邀請函有新的對話
    * 任務狀態變更
2. user 點擊提醒標題，可引導到對應的頁面


其他專案細節請見[這裏](erm_manual.md)


## 專案初始化

### install project
Fork之後請先bundle以及資料庫遷移  
```bash
$ bundle install
$ rails db:migrate
```

### figaro gem setup
```bash
bundle exec figaro install
```
此檔案用來管理專案的環境變數，會自動加進`.gitignore`中。

### Secret Key File Configuration
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

### Database initialization
Install PostgreSQL on your local machine
在本地端安裝好PostgreSQL之後請新增開發與測試用資料庫
```bash
$ createdb acwarcraft_development
$ createdb acwarcraft_test
```

### Generate seed data and fake user
```
$ rails dev:fake_all
```

### Github登入相關設定
先到[這裏](https://github.com/settings/applications/new)註冊你的app  
url 設定為http://localhost:3000/   
callback url 設定為 http://localhost:3000/users/auth/github/callback
完成註冊程序後將GITHUB_ID以及GITHUB_SECRET存到`config/application.yml`
```yml
GITHUB_KEY: <輸入產生的key>
GITHUB_SECRET: <輸入產生的secret>
```

## 自動化測試  
測試本專案  
```bash
$ rails test
```

用guard來即時測試修改的檔案  
```bash
$ bundle exec guard
```

