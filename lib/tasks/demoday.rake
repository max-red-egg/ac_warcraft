namespace :demoday do
  task fake_user_a: :environment do
    old_user = User.find_by(email:'shizuka@sample.com')
    #刪除user A所有參與過的 instance 
    #其中instance的review,  invite_msg, invitations, 通知
    if old_user 
      old_user.instances.each do |instance|
        instance.invitations.destroy_all
        instance.instance_msgs.destroy_all
        instance.reviews.destroy_all
        puts "instance id #{instance.id} has removed"
        instance.destroy
      end
      puts "now old_user has #{old_user.instances.count} instances"
      Notification.where(recipient: old_user).delete_all
      Notification.where(actor: old_user).delete_all
      old_user.delete
    end

    ##產生新user a
    file =  File.open("#{Rails.root}/public/avatar/usera.jpg")
    fake_users = User.where("email LIKE '%user@sample.com'")
    new_user = User.create!(
      email: "shizuka@sample.com",
      password:"12345678",
      level: 14,
      name: "靜香",
      description:"我是暗網局局長的女兒呦～啾咪",
      avatar: file,
      confirmed_at: Time.zone.now
    )
    fake_reviews = [{rating: 5,
      comment: "hen 棒！"
      },{
      rating: 5,
      comment: "整場都在cover我，不給五顆說不過去"
      },{
      rating: 5,
      comment: "太強了"
      },{
      rating: 5,
      comment: "都會用一些很神的寫法，效能也不錯，大推神隊友"
      },{
      rating: 5,
      comment: "秒解！大神受我一拜！"
      },{
      rating: 5,
      comment: "開心的一場戰役！"
      },{
      rating: 5,
      comment: "太神的隊友，大家不要跟我搶"
      },{
      rating: 5,
      comment: "人也心也美，腦袋一極棒"
      },{
      rating: 5,
      comment: "終於知道五星的實力"
      },{
      rating: 5,
      comment: "超厲害的探員！"
      },{
      rating: 5,
      comment: "不給五顆對不起我自己"
      },{
      rating: 5,
      comment: "大大～下次再合作～"
      }]
    for i in 1..20
      email = "#{i}.user@sample.com"
      fake_review = fake_reviews.sample
      team_mate = User.find_by(email: email)
      mission = Mission.where('participant_number >= ? AND level <= ?', 2,team_mate.level).sample
      members = [new_user,team_mate]
      instance = mission.instances.build(state: 'teaming', answer:FFaker::Lorem.sentence, xp: mission.xp)
      instance.members << members
      instance.save
      instance.complete!(instance.members[0])
      puts "generate instance #{instance.mission.name}"
      instance.reviews.find_by(reviewee_id: team_mate.id).update(rating:4,submit: true, comment:"不錯喔！")
      instance.reviews.find_by(reviewee_id: new_user.id).update(rating: fake_review[:rating], submit: true,comment: fake_review[:comment])
      #puts "完成了任務#{mission.id}"
    end
    new_user.xp = 30520
    new_user.level = 30
    new_user.save
  end

  task fake_user_b: :environment do
    old_user = User.find_by(email:'goda@sample.com')
    #刪除user A所有參與過的 instance 
    #其中instance的review,  invite_msg, invitations, 通知
    if old_user 
      old_user.instances.each do |instance|
        instance.invitations.destroy_all
        instance.instance_msgs.destroy_all
        instance.reviews.destroy_all
        puts "instance id #{instance.id} has removed"
        instance.destroy
      end
      puts "now old_user has #{old_user.instances.count} instances"
      Notification.where(recipient: old_user).delete_all
      Notification.where(actor: old_user).delete_all
      old_user.delete
    end

    ##產生新user
    file =  File.open("#{Rails.root}/public/avatar/userb.jpg")
    fake_users = User.where("email LIKE '%user@sample.com'")
    new_user = User.create!(
      email: "goda@sample.com",
      password:"12345678",
      level: 14,
      name: "胖虎",
      description:"我4孩紙王",
      avatar: file,
      confirmed_at: Time.zone.now
    )
    fake_reviews = [{rating: 1,
      comment: "不知道在幹嘛"
      },{
      rating: 2,
      comment: "很勉強才可以給到兩顆"
      },{
      rating: 1,
      comment: "超沒品的"
      },{
      rating: 2,
      comment: "無言的隊友"
      }]
    for i in 1..4
      email = "#{i}.user@sample.com"
      #fake_review = fake_reviews.sample
      team_mate = User.find_by(email: email)
      mission = Mission.where('participant_number >= ? AND level <= ?', 2,team_mate.level).sample
      members = [new_user,team_mate]
      instance = mission.instances.build(state: 'teaming', answer:FFaker::Lorem.sentence, xp: mission.xp)
      instance.members << members
      instance.save
      instance.complete!(instance.members[0])
      puts "generate instance #{instance.mission.name}"
      instance.reviews.find_by(reviewee_id: team_mate.id).update(rating:4,submit: true, comment:"不錯喔！")
      instance.reviews.find_by(reviewee_id: new_user.id).update(rating: fake_reviews[i-1][:rating], submit: true,comment: fake_reviews[i-1][:comment])
      #puts "完成了任務#{mission.id}"
    end
  end
  task fake_egg: :environment do
    user = User.find_by(github_username:'spreered')
    #刪除user A所有參與過的 instance 
    #其中instance的review,  invite_msg, invitations, 通知
    if user 
      user.instances.each do |instance|
        instance.invitations.destroy_all
        instance.instance_msgs.destroy_all
        instance.reviews.destroy_all
        puts "instance id #{instance.id} has removed"
        instance.destroy
      end
      puts "now old_user has #{user.instances.count} instances"
      Notification.where(recipient: user).delete_all
      Notification.where(actor: user).delete_all

    end

    ##產生新user
    user.update!(
      level: 14,
      name: "大雄",
      description:"雄宅，雄蓋讚。",
    )
    fake_reviews = [{
      rating: 3,
      comment: "能力不錯，可是不太好溝通"
      },{
      rating: 3,
      comment: "雖然能力不太優，可是是很認真的人"
      },{
      rating: 4,
      comment: "還不錯"
      },{
      rating: 4,
      comment: "愉快的合作！"
      },{
      rating: 4,
      comment: "很厲害喔！"
      },{
      rating: 4,
      comment: "是個很認真的人"
      },{
      rating: 4,
      comment: "Good!"
      },{
      rating: 5,
      comment: "hen 棒！"
      },{
      rating: 5,
      comment: "整場都在cover我，不給五顆說不過去"
      },{
      rating: 5,
      comment: "太強了"
      },{
      rating: 5,
      comment: "都會用一些很神的寫法，效能也不錯，大推神隊友"
      },{
      rating: 5,
      comment: "秒解！大神受我一拜！"
      },{
      rating: 5,
      comment: "開心的一場戰役！"
      }]
    for i in 1..13
      email = "#{i}.user@sample.com"
      #fake_review = fake_reviews.sample
      team_mate = User.find_by(email: email)
      mission = Mission.where('participant_number >= ? AND level <= ?', 2,team_mate.level).sample
      members = [user,team_mate]
      instance = mission.instances.build(state: 'teaming', answer:FFaker::Lorem.sentence, xp: mission.xp)
      instance.members << members
      instance.save
      instance.complete!(instance.members[0])
      puts "generate instance #{instance.mission.name}"
      instance.reviews.find_by(reviewee_id: team_mate.id).update(rating:4,submit: true, comment:"不錯喔！")
      instance.reviews.find_by(reviewee_id: user.id).update(rating: fake_reviews[i-1][:rating], submit: true,comment: fake_reviews[i-1][:comment])
      #puts "完成了任務#{mission.id}"

      user.followships.create(following_id: team_mate.id)
    end
  end

  task fake_announcements: :environment do
    Announcement.destroy_all
    admin = User.find_by(email: 'admin@sample.com')
    announcements = [{
      title: "Coding style 人人有責",
      content:
       "寫程式的人都或多或少會有這種感覺，別人的code看起來總不是那麼地順眼，閱讀自己的code才是像閱讀好書一樣如行雲流水般順暢。其實寫code如寫書，不僅寫給自己看，同時也寫給別人看；開發軟體也往往有如打造一件工藝品，投入其中的巧妙心思及用心，會影響到最後呈現出來的結果。所以，寫程式本身可以是一種藝術，而不僅僅是一件耗費勞力的枯燥工作。這也是為什麼Knuth要把他的巨著取名為The Art of Computer Programming，他認為打造軟體是困難的，是一種複雜度以及最後呈現結果足夠作為一件藝術品的一種過程。當然以Mr. Saturday的觀點來看，要邁入如創造藝術品般地去打造軟體這樣的一個境界，實在不是我們這種實力淺薄之人一日可成的事。所以，我還是比較喜歡寫code如寫書這個切入點。\r\n" +
       "\r\n" +
       "\r\n" +
       "既然寫code如寫書，那麼最重要的就莫過於條理清晰，脈絡分明的內容了，於是我們就需要一套令人容易了解的呈現手法來寫作了，一方面讓自己好讀，一方面也讓讀者好讀：於是coding style這種東西就出現了。這篇文章就是要來跟大家簡單介紹一些寫code最為常用的coding style，以及一般programmer彼此之間常常存在的有趣現象。",
      author_id:admin.id
    },{
      title: "大家安安，資安及國安",
      content:
       "臺灣過去十一年來，透過資安社群的蓬勃發展，慢慢的讓更多人意識到資安的重要性，更透過各種資安活動的舉辦，包括邀請國內外優秀的資安研究員參加社群場以及企業場的資安研討會，遇有重大資安事件緊急舉辦的Free Talk，甚至是現在越來越頻繁的企業漏洞通報等，加上與國內外各種資安社群的交流，也讓過往媒體上只有負面形象的「駭客」有
    了更多更正面積極的意義。\r\n" +
       "\r\n" +
       "對資安的重視與累積，並非一朝一夕可以達成，不過，成果的累積很辛苦，但要毀壞卻只要一夕之間。如同準總統蔡英文對準行政團隊說的：「八秒鐘失言，可以毀了八年的累積。」資安也是同樣的情況，因為資訊安全本身是一種信任，要累積很難、毀壞卻很容易。\r\n" +
       "\r\n" +
       "臺灣駭客協會也恰好在上週25日舉辦了成立一周年的感恩茶會上，長年支持HITCON這個社群，並一路看著臺灣駭客協會從社群到成立正式組織的臺灣科技大學資管系教授吳宗成，在茶會上一句：「臺灣的駭客是站在政府背後，而不是站在政府對面。」贏得現場如雷的掌聲。而吳宗成這句話，其實也是代表臺灣駭客社群對於法務部部長羅瑩雪在面對立委質詢時說：「臺灣駭客是站在政府對面。」的說法，予以最強而有力也是最直接的回應。",
      author_id:admin.id
    },{
      title: "資料結構不學好，底霸閣底到老",
      content:
       "在電腦科學的領域裡，資料(data)被定義為：用具體符號表示的原始元素(atom)與數據，其中包括文字、數字、圖形等。\r\n" +
       "\r\n" +
       "       資料的特性以及如何將資料加以發揮應用，也一直是人類文明以來就十分重視的問題。在電腦科學中，瞭解資料的特性無疑又是能夠更精確掌握電腦功能的主要原因。\r\n" +
       "如果依照計算機中所儲存和使用的對象，我們又可將資料分為二大類：\r\n" +
       "(1)數值資料(Numeric Data)：如0,1,2,3,4.…9所組成的資料。\r\n" +
       "(2)文數資料(Alphanumeric Data)：又稱為非數值資料(Non-Numeric Data)，像A,B,C,+,*,#等。\r\n" +
       "        對於二十一世紀的今天，資訊和電腦是息息相關的，因為在分析、處理資料的過程中，經常會使用到電腦。因為電腦具有速度快與容量大二大優點，它可以給我們很大的便利。尤其在近代的「資訊革命」洪潮中，如何掌握資訊、利用資訊，可以說是任何個人或事業體發展成功的重要原因。因為電腦的充分配合更能使資訊的功用發揮到淋漓盡至約境界。",
      author_id:admin.id
    },{
      title: "程式學好還可以選市長",
      content:
       "身處在這個「全民學程式」時代，幾年後當程式設計變成連國中生都必備的能力時，不會寫程式的人在未來就要變成少數民族。當越來越多人開始對學程式語言有興趣，大家常常問的第一個問題就是，到底該從哪個程式語言開始？\r\n" +
       "\r\n" +
       "網路上常常有文章針對熱門程式語言做分析，例如 C++、Python、Java、Javascript、Swift、Objective-C、Ruby。然後在看這些語言介紹時，我們都會看到一堆奇怪的外星名詞。物件導向？多重繼承？靜態成員函式？身為一個初學者只想大喊：\r\n" +
       "\r\n" +
       "「我就是看不懂專業術語才要學啊，可不可以先給我看一些人話！」\r\n" +
       "完全不知道該選什麼語言的下場是，讓很多人打退堂鼓，或矇著眼就選了一個看起來順眼，但學起來很痛苦的語言。",
      author_id:admin.id
    }]
    announcements.each do |announcement|
      Announcement.create!(announcement)
    end
  end
end
