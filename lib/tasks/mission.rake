namespace :mission do

  task mission_fake: :environment do
    Mission.destroy_all
    fake_data = [{
        name: "ALPHA Camp Demo Day 快速通關",
        level: 1,
        description: "提供 ALPHA Camp Demo Day 快速升級管道。",
        participant_number: 1,
        xp: 9999,
        tag: "緊急任務"
      }, {
        name: "機場正受到霸閣控制 - 運算思維突破點",
        level: 1,
        description: "請問一週有多少人從松山機場進入台灣？",
        participant_number: 1,
        xp: 250,
        tag: "Basic"
      }, {
        name: "自動販賣機錯誤 - 運算思維突破點",
        level: 1,
        description: "請在網路上尋找兩個我們日常生活常會碰到，甚至在不知覺中經常使用的演算法例子。請嘗試把他的 input, output, 與邏輯解釋。",
        participant_number: 1,
        xp: 250,
        tag: "Basic"
      },
      {
        name: "生活機能障礙 - 運算思維突破點",
        level: 1,
        description: "找一個你日常生活碰到的問題，設計一個來解決這個問題的演算法。",
        participant_number: 1,
        xp: 250,
        tag: "Basic"
      }, {
        name: "電子看板遭受入侵 - CSS 選擇器實際應用",
        level: 1,
        description: "請說明 CSS 選擇器如何選擇對應的元素",
        participant_number: 2,
        xp: 280,
        tag: "HTML, CSS"
      },
      {
        name: "公務單位填表長龍 - HTML 表單實戰",
        level: 1,
        description: "建立一個使用者的註冊表單，並用 CSS 加上樣式",
        participant_number: 2,
        xp: 280,
        tag: "HTML, CSS"
      }, {
        name: "國外大軍來援 - LeetCode 實戰",
        level: 2,
        description: '請至 LeetCode 建立一個帳號並用 JavaScript 語言升級至 5 等',
        participant_number: 2,
        xp: 350,
        tag: "JavaScript"
      }, {
        name: "國外大軍來援 - CodeWar 實戰",
        level: 2,
        description: '請至 CodeWar 建立一個帳號並用 Ruby 語言升級至 5 等',
        participant_number: 2,
        xp: 350,
        tag: "Ruby"
      },{
        name: "資料庫遭國防布掩蓋 - SQL 基本",
        level: 2,
        description: '請根據以下 Table 進行作答，作答方式是將問題複製貼上在輸入框裡，並依序將答案填寫入內：',
        participant_number: 2,
        xp: 350,
        tag: "SQL"
      }, {
        name: "探員崛起 - 打造自己的個人網頁",
        level: 2,
        description: "你的一位設計師朋友幫你畫好了 Wireframe，因此你最後會應用所學，做出一個簡單的個人網站，如圖片展示",
        participant_number: 1,
        xp: 350,
        tag: "HTML, CSS"
      }, {
        name: "相位轉移 - Exchange Seats",
        level: 2,
        description: "Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.\r\n" +
          "\r\n" +
          "The column id is continuous increment.\r\n" +
          "Mary wants to change seats for the adjacent students.\r\n" +
          "Can you write a SQL query to output the result for Mary?\r\n" +
          "+---------+---------+\r\n" +
          "|    id   | student |\r\n" +
          "+---------+---------+\r\n" +
          "|    1    | Abbot   |\r\n" +
          "|    2    | Doris   |\r\n" +
          "|    3    | Emerson |\r\n" +
          "|    4    | Green   |\r\n" +
          "|    5    | Jeames  |\r\n" +
          "+---------+---------+\r\n" +
          "For the sample input, the output is:\r\n" +
          "+---------+---------+\r\n" +
          "|    id   | student |\r\n" +
          "+---------+---------+\r\n" +
          "|    1    | Doris   |\r\n" +
          "|    2    | Abbot   |\r\n" +
          "|    3    | Green   |\r\n" +
          "|    4    | Emerson |\r\n" +
          "|    5    | Jeames  |\r\n" +
          "+---------+---------+\r\n",
        participant_number: 1,
        xp:350,
        tag: "SQL"
    },{
        name: "暗網局資料庫成立 - 畫出一個 ERD",
        level: 3,
        description: '畫ERD 圖可以讓我們從無到有，逐漸看到一個資料庫的全貌，因而能用 ERD 圖去確定資料之間的關係，讓工程師在寫 code 之前，能對資料的結構與關聯有個全貌，確認有無遺漏。',
        participant_number: 2,
        xp: 380,
        tag: "SQL"
      }, {
        name: "紅寶的逆襲 - Ruby 物件導向",
        level: 3,
        description: '認識 programming paradigm，認識 Procedural Programming 與 Object-Oriented Programming 的差別，認識 Object-Oriented Programming 的概念。',
        participant_number: 2,
        xp: 380,
        tag: "Ruby"
      }, {
        name: "數位英雄 - 用 JavaScript 實作一個「英雄打怪」的小遊戲",
        level: 3,
        description: '在這次的實作裡，我們會從遊戲需求的角度出發，去思考如何對遊戲需求進行拆解，以下會是「英雄打怪」的遊戲需求和構思畫面：',
        participant_number: 2,
        xp: 390,
        tag: "JavaScript"
      }, {
        name: "小傑・富力士來援 - 用 Ruby 寫一個剪刀石頭布的遊戲",
        level: 3,
        description: "透過打造一個遊戲，一步一步觀察與練習從 idea -> pseudocode -> code 的實作過程。",
        participant_number: 2,
        xp: 390,
        tag: "Ruby"
      }, {
        name: "暗網局分部成立 - 響應式網站建立",
        level: 4,
        description: '請你使用 Bootstrap，建立一個新的網站專案',
        participant_number: 2,
        xp: 420,
        tag: "HTML, CSS, Bootstrap"
      }, {
        name: "暗網時光機 - 認識版本控制",
        level: 4,
        description: '認識版本控制，了解傳統備份資料的缺點，知道什麼是版本控制，明白為什麼要使用版本控制，清楚版本控制可以提高開發效率。',
        participant_number: 2,
        xp: 450,
        tag: "Git"
      }, {
        name: "接續暗網時光網路 - 將專案推上 GitHub",
        level: 5,
        description: '瞭解 GitHub 的基本功能，建立一個 GitHub 帳號與專案，並且了解本地端與遠端 Github 的同步關係',
        participant_number: 2,
        xp: 520,
        tag: "Git"
      }, {
        name: "零誤點的暗網鐵路局 - 認識 Rails",
        level: 5,
        description: '在介紹 Rails 之前，先聽聽 Rails 的魅力。Rails 雖然在台灣不是很普遍 (相對於其他後端語言如 PHP、JAVA 等)，但在歐美，Ruby on Rails 是很多網路科技公司的核心技術。就讓我們開始了解神奇的 Rails 吧！',
        participant_number: 2,
        xp: 550,
        tag: "Rails, Ruby"
      }, {
        name: "暗網鐵路局初架構 - Rails 鷹架",
        level: 5,
        description: '利用 Rails Scaffold 快速完成你的第一個專案。從 Scaffold 中了解 Rails 的基本精神。',
        participant_number: 2,
        xp: 590,
        tag: "Rails, Ruby"
      }, {
        name: "站在前人的肩上 - Git clone",
        level: 6,
        description: '完成以下事項：能使用 git clone 指令把你想要的 GitHub 專案複製到本機端，能使用 GitHub 上的 fork 功能把其 GitHub 上其他人的專案複製到自己的 GitHub Repository 裡。',
        participant_number: 2,
        xp: 600,
        tag: "Git"
      }, {
        name: "暗網局分部討論區 - Rails CRUD",
        level: 6,
        description: '建立一個基本的討論區功能，具有完成新增文章，讀取文章，編輯和刪除文章的功能，以及對應到的頁面',
        participant_number: 2,
        xp: 620,
        tag: "Rails, Ruby"
      }, {
        name: "暗網局分部代辦任務中心 - Rails 進階",
        level: 6,
        description: '建立一個基本的待辦清單，具有完成新增清單，讀取清單，編輯和刪除清單的功能，以及對應到的頁面',
        participant_number: 2,
        xp: 680,
        tag: "Rails, Ruby"
      }, {
        name: "暗網局組織重整 - Rails 優化",
        level: 7,
        description: '了解重構的基本概念，利用 before_action 回呼重構 controller，利用 partial 局部頁面重構 View 頁面程式碼。',
        participant_number: 2,
        xp: 710,
        tag: "Rails, Ruby"
      }, {
        name: "被發現了！快改變造型 - Rails 套版",
        level: 7,
        description: '整合目前學習到的知識，將 Bootstrap 套用到已經建立好的 Rails app，完成基本的 RWD 網站。',
        participant_number: 2,
        xp: 730,
        tag: "Rails, Ruby, Bootstrap"
      }, {
        name: "暗網局的破產危機 - Rails 金流",
        level: 7,
        description: '瞭解線上金流與第三方支付服務，能夠從 API 技術文件裡確認串接 API 的必要金鑰，能夠取得必要金鑰，能夠從 API 技術文件裡確認需要傳遞的參數格式',
        participant_number: 2,
        xp: 750,
        tag: "Rails, Ruby"
      }, {
        name: "探員互助會 - Git 協作",
        level: 8,
        description: '利用 Github 服務，能夠與多人同時操作 Git 版本控制，並審核合併團隊成員的程式碼。',
        participant_number: 2,
        xp: 810,
        tag: "Git"
      }, {
        name: "暗網局分部，正式上線 - Rails 部署",
        level: 8,
        description: '知道部署的實作階段，認識不同的雲端服務平台，能夠選擇合適的雲端服務方案，將程式完成部署',
        participant_number: 2,
        xp: 860,
        tag: "Rails, Ruby"
      }, {
        name: "資料庫發生錯誤 - Duplicate Emails",
        level: 8,
        description: "Write a SQL query to find all duplicate emails in a table named Person.\r\n" +
          "\r\n" +
          "+----+---------+\r\n" +
          "| Id | Email   |\r\n" +
          "+----+---------+\r\n" +
          "| 1  | a@b.com |\r\n" +
          "| 2  | c@d.com |\r\n" +
          "| 3  | a@b.com |\r\n" +
          "+----+---------+\r\n" +
          "For example, your query should return the following for the above table:\r\n" +
          "\r\n" +
          "+---------+\r\n" +
          "| Email   |\r\n" +
          "+---------+\r\n" +
          "| a@b.com |\r\n" +
          "+---------+\r\n",
        participant_number: 1,
        xp:890,
        tag: "SQL"
    },{
        name: "美食中的霸閣，使用 Rails 消滅他",
        level: 9,
        description: "製作一個美食論壇，使用者可以在上面評論美食\r\n" + "管理者可以更新餐廳照片\r\n" + "請部署於GCP上面",
        participant_number: 2,
        xp:930,
        tag: "Rails, Ruby"
    },{
        name: "高速往復鐵路 - Reverse Nodes in k-Group",
        level: 9,
        description:  "Given a linked list, reverse the nodes of a linked list k at a time and return its modified list.\r\n" +
          "\r\n" +
          "k is a positive integer and is less than or equal to the length of the linked list. If the number of nodes is not a multiple of k then left-out nodes in the end should remain as it is.\r\n" +
          "\r\n" +
          "You may not alter the values in the nodes, only nodes itself may be changed.\r\n" +
          "\r\n" +
          "Only constant memory is allowed.\r\n" +
          "\r\n" +
          "For example,\r\n" +
          "Given this linked list: 1->2->3->4->5\r\n" +
          "\r\n" +
          "For k = 2, you should return: 2->1->4->3->5\r\n" +
          "\r\n" +
          "For k = 3, you should return: 3->2->1->4->5",
        participant_number: 2,
        xp:950,
        tag: "JavaScript"
    },{
        name: "暗網局資料庫升級 - Nth Highest Salary",
        level: 10,
        description: "Write a SQL query to get the nth highest salary from the Employee table.\r\n" +
          "\r\n" +
          "+----+--------+\r\n" +
          "| Id | Salary |\r\n" +
          "+----+--------+\r\n" +
          "| 1  | 100    |\r\n" +
          "| 2  | 200    |\r\n" +
          "| 3  | 300    |\r\n" +
          "+----+--------+\r\n" +
          "For example, given the above Employee table, the nth highest salary where n = 2 is 200. If there is no nth highest salary, then the query should return null.\r\n" +
          "\r\n" +
          "+------------------------+\r\n" +
          "| getNthHighestSalary(2) |\r\n" +
          "+------------------------+\r\n" +
          "| 200                    |\r\n" +
          "+------------------------+\r\n",
        participant_number: 2,
        xp:1010,
        tag: "SQL"
    },{
        name: "暗網局統一暗語 - Regular Expression Matching",
        level: 10,
        description: "mplement regular expression matching with support for '.' and '*'.\r\n" +
          "\r\n" +
          "'.' Matches any single character.\r\n" +
          "'*' Matches zero or more of the preceding element.\r\n" +
          "\r\n" +
          "The matching should cover the entire input string (not partial).\r\n" +
          "\r\n" +
          "The function prototype should be:\r\n" +
          "bool isMatch(const char *s, const char *p)\r\n" +
          "\r\n" +
          "Some examples:\r\n" +
          "isMatch(\"aa\",\"a\") → false\r\n" +
          "isMatch(\"aa\",\"aa\") → true\r\n" +
          "isMatch(\"aaa\",\"aa\") → false\r\n" +
          "isMatch(\"aa\", \"a*\") → true\r\n" +
          "isMatch(\"aa\", \".*\") → true\r\n" +
          "isMatch(\"ab\", \".*\") → true\r\n" +
          "isMatch(\"aab\", \"c*a*b\") → true\r\n",
        participant_number: 2,
        xp:1050,
        tag: "JavaScript"
    },{
        name: "假的 Stack Overflow 霸霸閣",
        level: 10,
        description: "使用者可以創建新帳號\r\n" +
          "使用者帳號欄位請包含：（* 為必填欄位）姓名 *  Email *密碼 *公司 職稱 簡介 個人網站連結Twitter 連結  GitHub 連結\r\n" +
          "使用者可以登入／登出帳戶\r\n" +
          "使用者不需登入就可以瀏覽問題和解答\r\n" +
          "使用者需要登入才可以發表問題\r\n" +
          "使用者需要登入才可以發表解答\r\n" +
          "使用者註冊帳號時需要填寫姓名、Email、密碼\r\n" +
          "使用者的 Email 唯一、不可重複\r\n" +
          "使用者可以在其他使用者的個人頁面瀏覽以下資訊：\r\n" +
          "個人頁面資訊：姓名、公司、職稱、個人網站連結、Twiiter 連結、GitHub 連結\r\n" +
          "已發表的問題數量\r\n" +
          "已發表的解答數量\r\n" +
          "獲得最多 upvote 問題的 upvote 數量\r\n" +
          "獲得最多 upvote 解答的 upvote 數量\r\n" +
          "獲得的 upvote 總數（問題＋解答）\r\n" +
          "使用者可以瀏覽自己的個人頁面資訊\r\n" +
          "使用者可以編輯自己的個人頁面資訊\r\n" +
          "使用者可以發表問題\r\n" +
          "發表問題的欄位請包含：（* 為必填欄位）標題 *內容 *\r\n" +
          "使用者可以在首頁瀏覽問題列表\r\n" +
          "在列表上的每個問題，請包含以下資訊：問題標題  問題內容摘要（只摘要前 100 字）  問題發問者（顯示姓名） 問題發表時間 問題獲得 favorite 的數量  問題獲得 upvote 的數量  問題獲得解答的數量\r\n" +
          "使用者點選問題後可以瀏覽以下資訊：問題標題  問題內容 問題發問者（顯示姓名） 問題發表時間 問題獲得 favorite 的數量 問題獲得 upvote 的數量 問題獲得解答的數量 顯示所有答的列表（依照解答獲得的 upvote 數量排序）\r\n" +
          "\r\n" +
          "在解答列表上的每個解答，請包含以下資訊：\r\n" +
          "顯示解答者（顯示姓名）\r\n" +
          "解答發表時間\r\n" +
          "解答獲得的 upvote 數量\r\n" +
          "使用者可以 upvote 問題\r\n" +
          "使用者可以對已發表的問題發表解答（一個文字輸入欄位）\r\n" +
          "使用者可以 upvote 其他使用者的解答\r\n" +
          "使用者可以 favorite 問題\r\n" +
          "使用者可以在一個獨立的頁面瀏覽 favorite 問題的列表",
        participant_number: 2,
        xp:1080,
        tag: "Rails, Ruby"
    },{
        name: "國防布再現 - Consecutive Numbers",
        level: 11,
        description: "Write a SQL query to find all numbers that appear at least three times consecutively.\r\n" +
        "\r\n" +
        "+----+-----+\r\n" +
        "| Id | Num |\r\n" +
        "+----+-----+\r\n" +
        "| 1  |  1  |\r\n" +
        "| 2  |  1  |\r\n" +
        "| 3  |  1  |\r\n" +
        "| 4  |  2  |\r\n" +
        "| 5  |  1  |\r\n" +
        "| 6  |  2  |\r\n" +
        "| 7  |  2  |\r\n" +
        "+----+-----+\r\n" +
        "For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.\r\n" +
        "\r\n" +
        "+-----------------+\r\n" +
        "| ConsecutiveNums |\r\n" +
        "+-----------------+\r\n" +
        "| 1               |\r\n" +
        "+-----------------+\r\n",
        participant_number: 1,
        xp:1100,
        tag: "SQL"
    },{
        name: "通往 Firebase 與 JSON 的機密之路",
        level: 11,
        description: "利用Firebase的服務，使用JavaScript實作一個Todolist\r\n" + "https://firebase.google.com/\r\n" + "https://tw.alphacamp.co/2016/07/22/firebase/",
        participant_number: 2,
        xp:1130,
        tag: "JavaScript, HTML, CSS"
    },{
        name: "Rails 期中小魔王 - 一起來打敗霸閣",
        level: 11,
        description: "User stories\r\n" +
          "以下為「社群網站」專案的 User stories：\r\n" +
          "\r\n" +
          "除了註冊和登入頁，使用者一定要登入才能使用網站\r\n" +
          "使用者能創建帳號、登入、登出\r\n" +
          "除了信箱和密碼，使用者在註冊時還能設定自己的名稱\r\n" +
          "使用者的名稱不能重覆，若有重覆會跳出錯誤\r\n" +
          "使用者能編輯自己的名稱、介紹和大頭照\r\n" +
          "使用者能瀏覽所有的推播 (tweet)\r\n" +
          "使用者能在首頁看見跟隨者 (followers) 數量排列前 10 的使用者推薦名單\r\n" +
          "點擊其他使用者的名稱時，能瀏覽該使用者的個人資料及推播\r\n" +
          "使用者能新增推播（限制在 140 字裡）\r\n" +
          "使用者能回覆別人的推播\r\n" +
          "使用者可以追蹤/取消追蹤其他使用者（不能追蹤自己）\r\n" +
          "使用者能對別人的推播按 Like/Unlike\r\n" +
          "任何登入使用者都可以瀏覽特定使用者的以下資料：\r\n" +
          "Tweets：排序依日期，最新的在前\r\n" +
          "Following：該使用者的關注清單，排序依照追蹤紀錄成立的時間，愈新的在愈前面\r\n" +
          "Follower：該使用者的跟隨者清單，排序依照追蹤紀錄成立的時間，愈新的在愈前面\r\n" +
          "Like：該使用者 like 過的推播清單，排序依 like 紀錄成立的時間，愈新的在愈前面\r\n" +
          "管理者登入網站後，能夠進入後台頁面\r\n" +
          "管理者可以瀏覽所有的推播與推播回覆內容\r\n" +
          "管理者可以刪除使用者的推播\r\n" +
          "管理者可以瀏覽站內所有的使用者清單\r\n" +
          "該清單會列出他們的活躍程度（包括推播數量、關注人數、跟隨者人數、like 過的推播數）\r\n" +
          "管理者可以瀏覽站內所有的使用者清單，該清單按推播文數排序",
        participant_number: 2,
        xp:1170,
        tag: "Rails, Ruby, HTML, CSS, JavaScript"
    },{
        name: "暗網局資料庫 - SQL 的試煉",
        level: 12,
        description: "The Trips table holds all taxi trips. Each trip has a unique Id, while Client_Id and Driver_Id are both foreign keys to the Users_Id at the Users table. Status is an ENUM type of (‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’).\r\n" +
        "\r\n" +
        "+----+-----------+-----------+---------+--------------------+----------+\r\n" +
        "| Id | Client_Id | Driver_Id | City_Id |        Status      |Request_at|\r\n" +
        "+----+-----------+-----------+---------+--------------------+----------+\r\n" +
        "| 1  |     1     |    10     |    1    |     completed      |2013-10-01|\r\n" +
        "| 2  |     2     |    11     |    1    | cancelled_by_driver|2013-10-01|\r\n" +
        "| 3  |     3     |    12     |    6    |     completed      |2013-10-01|\r\n" +
        "| 4  |     4     |    13     |    6    | cancelled_by_client|2013-10-01|\r\n" +
        "| 5  |     1     |    10     |    1    |     completed      |2013-10-02|\r\n" +
        "| 6  |     2     |    11     |    6    |     completed      |2013-10-02|\r\n" +
        "| 7  |     3     |    12     |    6    |     completed      |2013-10-02|\r\n" +
        "| 8  |     2     |    12     |    12   |     completed      |2013-10-03|\r\n" +
        "| 9  |     3     |    10     |    12   |     completed      |2013-10-03| \r\n" +
        "| 10 |     4     |    13     |    12   | cancelled_by_driver|2013-10-03|\r\n" +
        "+----+-----------+-----------+---------+--------------------+----------+\r\n" +
        "The Users table holds all users. Each user has an unique Users_Id, and Role is an ENUM type of (‘client’, ‘driver’, ‘partner’).\r\n" +
        "\r\n" +
        "+----------+--------+--------+\r\n" +
        "| Users_Id | Banned |  Role  |\r\n" +
        "+----------+--------+--------+\r\n" +
        "|    1     |   No   | client |\r\n" +
        "|    2     |   Yes  | client |\r\n" +
        "|    3     |   No   | client |\r\n" +
        "|    4     |   No   | client |\r\n" +
        "|    10    |   No   | driver |\r\n" +
        "|    11    |   No   | driver |\r\n" +
        "|    12    |   No   | driver |\r\n" +
        "|    13    |   No   | driver |\r\n" +
        "+----------+--------+--------+\r\n" +
        "Write a SQL query to find the cancellation rate of requests made by unbanned clients between Oct 1, 2013 and Oct 3, 2013. For the above tables, your SQL query should return the following rows with the cancellation rate being rounded to two decimal places.\r\n" +
        "\r\n" +
        "+------------+-------------------+\r\n" +
        "|     Day    | Cancellation Rate |\r\n" +
        "+------------+-------------------+\r\n" +
        "| 2013-10-01 |       0.33        |\r\n" +
        "| 2013-10-02 |       0.00        |\r\n" +
        "| 2013-10-03 |       0.50        |\r\n" +
        "+------------+-------------------+\r\n",
        participant_number: 1,
        xp:1200,
        tag: "SQL"
    },{
        name: "開放資料的霸閣, 使用 Ajax 收服他",
        level: 12,
        description: "請至政府開放資料平台（https://data.gov.tw/）搜尋可用的api\r\n" + "並且利用 Ajax 抓取 API 的資料，實作出一個網站\r\n" + "範例參考https://github.com/guahsu/JavaScript-TravelMap",
        participant_number: 2,
        xp:1250,
        tag: "JavaScript, HTML, CSS"
    },{
        name: "Rails 期末大魔王 - 最終試煉",
        level: 12,
        description:  "使用Rails  架設一個加強版的論壇\r\n" +
          "\r\n" +
          "「後台管理介面」\r\n" +
          "進入後台必須有管理員 (admin) 權限\r\n" +
          "請撰寫 seed.rb，新增一組預設管理員，限定帳號：admin@example.com；密碼：12345678\r\n" +
          "後台可以 CRUD 文章的分類 (但不能刪除已經有被使用的分類)\r\n" +
          "後台可以瀏覽所有使用者清單，清單上可一目了然使用者的姓名、基本資料、是否有管理員 (admin) 權限\r\n" +
          "後台可以把其他使用者加為管理員 (admin)\r\n" +
          "管理員 (admin) 在前台瀏覽文章時，可以刪除任何人的文章\r\n" +
          "\r\n" +
          "\r\n" +
          "「文章 CRUD」\r\n" +
          "使用者可以瀏覽文章總表，並且在總表上一目瞭然：\r\n" +
          "每篇主題有多少回覆數 (replies_count)\r\n" +
          "每篇文章有多少瀏覽數 (viewed_count)\r\n" +
          "使用者可以瀏覽文章詳細內容\r\n" +
          "可以在同一頁直接進行回覆 (Comment)\r\n" +
          "在同一頁看見回覆內容，每頁最多顯示 20 筆回覆\r\n" +
          "若使用者是該文章/回覆的作者，在本頁面可以同步進行編輯和刪除\r\n" +
          "使用者瀏覽文章總表時，預設是按 id 排序，但也可以自訂：\r\n" +
          "可選擇用「最後回覆時間」排序文章\r\n" +
          "可選擇用「最多人進行回覆」排序文章\r\n" +
          "可選擇用最多人瀏覽數排序文章\r\n" +
          "使用者可以張貼文章，每頁顯示 20 筆\r\n" +
          "張貼文章時，可以附檔上傳一張相片\r\n" +
          "使用者張貼文章時，可以選擇 Category (多選)，例如 [ ] 商業類 [ ] 技術類 [ ] 心理類\r\n" +
          "使用者可以瀏覽特定分類的文章\r\n" +
          "使用者瀏覽特定分類文章時，也可以進行分頁和進行排序\r\n" +
          "\r\n" +
          "\r\n" +
          "「Profile」\r\n" +
          "在任何一個地方點擊使用者暱稱可以進行 Profile 頁，看到個人簡介，包括：\r\n" +
          "該使用者張貼過的文章\r\n" +
          "該使用者回覆過的文章\r\n" +
          "使用者可以收藏/取消收藏文章（按鈕以 AJAX 實作），且可以在 Profile 頁裡瀏覽自己收藏的文章列表\r\n" +
          "\r\n" +
          "\r\n" +
          "「全站最新快訊」\r\n" +
          "新增一個全站最新快訊的頁面，顯示以下資訊：\r\n" +
          "全站有多少使用者\r\n" +
          "全站總共有多少主題和回覆\r\n" +
          "最熱門的文章（最多人回覆）\r\n" +
          "聲量最大的使用者（最多回覆數）\r\n" +
          "\r\n" +
          "\r\n" +
          "「文章狀態」\r\n" +
          "新增文章時可以選擇草稿 (Draft) 狀態\r\n" +
          "草稿狀態只有自己看得到，稍候可以編輯將狀態改成「發布」。\r\n" +
          "草稿狀態的文章會統一歸進 Profile 頁面裡",
        participant_number: 2,
        xp:1290,
        tag: "Rails, Ruby, HTML, CSS, JavaScript"
    }]
    fake_data.each do |newfake|
      file = File.open("#{Rails.root}/public/mission/mission_#{ rand(1..12) }.jpg")
      mission = Mission.new
      mission.name = newfake[:name]
      mission.level = newfake[:level]
      mission.image = file
      mission.description = newfake[:description]
      mission.participant_number = newfake[:participant_number]
      mission.invitation_number = 5
      mission.xp = newfake[:xp]
      new_tags = newfake[:tag].split(",").reject { |c| c.empty? }
      mission.tag_list.add(new_tags)
      mission.save
      puts "create mission #{mission.name}"
    end
  end
end
