# README

User
  name
  email
  password

Task
 title
 content

 Label
 priority
 limit

Herokuへのデプロイ方法
1. **Herokuに新しいアプリケーションを作成する**
    1. `heroku create`
2. **GemfileにGemを追加する（Ruby３系を使用している場合）**
    1. 
        
        ```ruby
        gem 'net-smtp'
        gem 'net-imap'
        gem 'net-pop'
        ```
        
3. コミットする
    1. 
    
    ```ruby
    ~/workspace/heroku_test_app (master) $ git add .
    ~/workspace/heroku_test_app (master) $ git commit -m "init"
    ```
    
4. **Heroku buildpackを追加する**
    1. 
        
        ```
        $ heroku buildpacks:set heroku/ruby
        $ heroku buildpacks:add --index 1 heroku/nodejs
        ```
        
    2. HerokuにPostgreSQLのアドオンも追加します。
    3. `heroku addons:create heroku-postgresql`
5. **Herokuにデプロイをする**
    1. `git push heroku master`