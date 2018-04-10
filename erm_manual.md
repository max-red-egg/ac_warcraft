# 暗碼局探員生存手冊
 * [專案初始化](#專案初始化)
 * [登入暗碼局](#登入暗碼局)
 * [介面說明](#介面說明)
 * [挑戰任務](#挑戰任務)
 * [任務邀請(邀請函)](#任務邀請(邀請函))
 * [探員資料庫](#探員資料庫)
 * [個人檔案](#個人檔案)
 * [暗碼局品質管理](#暗碼局品質管理)
 
# 專案初始化
 [專案初始化](README.md)
# 登入暗碼局
[www.erm.zone](http://www.erm.zone)
![登入畫面](https://github.com/max-red-egg/pic_for_web/raw/master/public_1.png)
點選「關於暗碼局」，可以閱讀暗碼局的小故事
![登入畫面](https://github.com/max-red-egg/pic_for_web/raw/master/public_2.png)

## 創建一個帳號
可以使用email註冊，或者是建議你可以直接點選Github註冊！
![註冊畫面](https://github.com/max-red-egg/pic_for_web/raw/master/public_3.png)
## 使用GitHub登入
使用GitHub登入，可以直接在提交答案的部分直接選取自己的repo來提交。
# 介面說明
![介面說明](https://github.com/max-red-egg/pic_for_web/raw/master/interface.png)
- 通知:navbar上面鈴鐺按鈕，可以檢視最新的通知。使用action cable實作，可即時收到通知。
- 緊急招募：navbar上的火焰按鈕，可以檢視最新的緊急招募任務。
- 戰情中心：暗碼局戰情看板，可以看到全站資訊、追蹤探員的最新動態、推薦的任務等等。
- 任務資訊
   - 秘密任務室：可以瀏覽所有的任務。
   - 進行中任務：目前正在進行的任務。
   - 組隊中任務：探員自己發起，正在組隊中的任務。
- 秘密通訊：可以瀏覽所有任務的邀請函。如有未讀訊息，會有紅色的數字提醒。
- 探員資料庫：可以瀏覽全站所有探員。如對哪位探員有興趣，可以直接發起任務邀請。
- 個人檔案：個人檔案瀏覽及修改。

# 挑戰任務
挑戰任務流程可詳見README.md裡面的[user story](https://github.com/max-red-egg/ac_warcraft#user-story)
## 選擇任務
你可以在 `側邊欄 > 任務資訊 > 秘密任務室` 中挑選你有興趣的任務，並可以使用篩選及搜尋的功能。
![mission board](https://github.com/max-red-egg/pic_for_web/raw/master/mission_board1.png)

如果等級不足或正在挑戰中，則無法再次發起任務。
![mission board](https://github.com/max-red-egg/pic_for_web/raw/master/mission_board.png)
- Team# : 任務人數，你可以跳戰一人任務，或者選擇兩人任務邀請其他探員共同組隊。
- Level : 任務等級。如果自己的等級不足，則無法挑戰該任務。
- XP : 挑戰任務成功後可獲得的經驗值。
- Tag : 依據任務屬性的tag分類。該tag會影響系統推薦你的任務、在個人資訊中也可以看到你挑戰任務種類的比例。

## 挑選隊友
挑選兩人任務，隨即會進入到組隊畫面。或者你也可以從`側邊欄 > 任務資訊 > 組隊中任務`進入到本畫面

![組隊](https://github.com/max-red-egg/pic_for_web/raw/master/teaming_board.png)

於組隊頁面下方可以挑選適合的隊友，可以搜尋探員名字、篩選條件，並且檢視探員個人資訊來考慮是否邀請對方參加任務。

![組隊](https://github.com/max-red-egg/pic_for_web/raw/master/filter.png)

## 發送邀請
每個任務都會限制邀請函發送數量。

![邀請數量](https://github.com/max-red-egg/pic_for_web/raw/master/invitation_number.png)

發送邀請函後，該探員會跳到上區塊，代表你正在邀請他。
可以點選聊天按鈕，與對方進行線上即時對話(使用action cable實作)
![邀請函](https://github.com/max-red-egg/pic_for_web/raw/master/inivte_chat.png)

當有任何一個受邀探員接受邀請，則任務立即啟動

## 緊急招募
緊急招募按鈕可以把招募資訊公告在右上角「緊急招募看板」內，一但有探員同意，任務立即啟動。
![緊急招募](https://github.com/max-red-egg/pic_for_web/raw/master/recruits.png)
## 提交答案
提交答案必須先儲存後，才可點選提交按鈕。只有綁定github帳號的探員可以使用github來提交答案。
每次更新答案，系統都會發送通知給你的隊友！
![更新答案](https://github.com/max-red-egg/pic_for_web/raw/master/answer_update.png)


## 評價隊友
當任務完成或放棄，可以在該任務內互相留下隊員的評價。當留下評價後，才可以看到對方的對你的評價！
![review](https://github.com/max-red-egg/pic_for_web/raw/master/review.png)

# 任務邀請(邀請函)
在任務邀請區塊，可以看到你所有收到及發出的邀請函。有未讀的訊息會標示未讀數量，一但讀取，數字會自動消失
![任務邀請](https://github.com/max-red-egg/pic_for_web/raw/master/invitation_list.png)
 
# 探員資料庫
## 追蹤探員
各個探員的頁面都可以看到一個追蹤按鈕，按下即可追蹤那個使用者。
## 邀請組隊
可以直接在各個使用者的資訊頁點擊邀請組隊，系統會直接列出符合邀請人以及被邀請人的任務，選擇好任務後系統便會自動邀請對方一起挑戰選擇的任務。
# 個人檔案
## 個人資訊
- 大頭照
- 自我介紹
- 邀請開放狀態
- Level
- XP
## 近期追蹤的探員
## 防守範圍
## 獲得的評價
## 執行過的任務

