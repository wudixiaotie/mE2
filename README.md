This app deployed on heroku cloud
URL: http://me-2.herokuapp.com
# little blog's bug list

1.favicon √
2.upload pic gem: paperclip
3.Stay sign in √
4.forgetten password √
4.ENV['SENDGRID_USERNAME'] and ENV['SENDGRID_PASSWORD'] how to save it √
5.del routes session √
6.use slim to reconstruction erb √
7.use Draper gem for form => micropost
8.use client side validations
9.use sidekiq gem for deamon process
10.use redis gem for cache
11.search auto-complite
12.change routes when at home click post
13.bootstrap feedback
14.relationship's ajax how to deal with it?


回复 √

Twitter 允许用户使用“@replies” 的格式进行回复，回复也是一篇微博，不过内容的开头是 @ 符号加用户名。回复只会出现在被回复用户的动态列表和粉丝的动态列表中。请实现一个简化的回复功能，限制回复只可以出现在接收者和发送者的动态列表中。实现的过程可能要在 microposts 表中加入 in_reply_to 列，还要在 Micropost 模型中添加 including_replies 作用域。

因为我们的示例程序没有限制用户登录名要是唯一的，所以你可能要决定一下要采用什么方式表示用户的身份。一种方式是，结合 id 和名字，例如 @1-michael-hartl。另一种方式是，在注册表单中添加一个用户名字段，用户名将是唯一的，然后用来表示 @replies。

私信

Twitter 支持在微博的前面加上字母“d”发送私信。请在示例程序中加入这个功能。实现的过程中可能要创建 Message 模型，还要使用正则表达式匹配微博的内容。

被关注提醒

请实现当用户有新粉丝时向被关注用户发送提醒邮件的功能，并把这一功能设为可选的，这样如果用户不想接收提醒就可以不选择这个功能。实现这个功能需要学习如何在 Rails 中发送邮件，我建议观看 RailsCasts 中的《Action Mailer in Rails 3》一集来学习。

密码提醒 √

现在，如果程序的用户忘记密码了，就没办法获取了。因为我们在第 6 章使用了单向密码加密，程序没办法把密码通过 Email 发送给用户，但是我们可以发送一个重设密码表单的链接。按照 RailsCasts 中的《Remember Me & Reset Password》一集来修正这个问题。

注册确认 √

除了匹配 Email 地址的正则表达式之外，示例程序现在没有其他方法可以验证用户的 Email 地址是否合法。请在注册步骤中添加确认用户注册这一步。这个功能应该在注册时把用户设为未激活状态，发送一封包含激活链接的邮件，当链接被点击后再把用户设为已激活状态。你可能要先阅读 Rails state machine 相关的文章，学习如何在未激活和激活状态之间转换。

RSS Feed

请为每一个用户的微博更新创建一个 RSS，然后再为用户的状态列表实现一个 RSS，如果可以，你还可以使用身份验证机制限制对动态列表 RSS 的访问。RailsCasts 中的《Generating RSS Feeds》一集可以给你一些帮助。

REST API

很多网站都提供了“应用编程接口（Application Programmer Interface，API）”，允许第三方程序获取（get），创建（post），更新（put）和删除（delete）程序的资源。请为示例程序实现这种 REST API。实现的过程中可能要为程序的多数控制器动作添加 respond_to 代码块（参见 11.2.5 节），响应 XML 类型的请求。请注意安全问题，API 应该只对授权的用户开放。

搜索

现在，除了浏览用户索引页面，或者查看其他用户的动态列表之外，没有办法找到另外的用户。请实现搜索功能来弥补这个缺陷。然后再添加搜索微博的功能。RailsCasts 中的《Simple Search Form》一集可以给你一些帮助。如果你的程序部署在共享主机或专用服务器，我建议你使用 Thinking Sphinx（参考 RailsCasts 中的《Thinking Sphinx》一集）。如果你的程序部署在 Heroku 上，你应该参照《Full Text Search Options on Heroku》一文中的说明。




 message sender_id=>sender_name
 for sending message find user name

 1.sending message change from form submit to ajax so it can show flash