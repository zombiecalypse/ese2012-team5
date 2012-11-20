require 'rubygems'
require 'sinatra'
require 'bcrypt'
require 'tilt/haml'
require 'webget_ruby_secure_random'
require 'tlsmail'
require 'require_relative'

require_relative 'models/marketplace/user.rb'
require_relative 'models/marketplace/item.rb'
require_relative 'models/marketplace/database.rb'
require_relative 'models/helper/mailer.rb'
require_relative 'models/helper/validator.rb'
require_relative 'models/helper/checker.rb'

require_relative 'controllers/main.rb'
require_relative 'controllers/login.rb'
require_relative 'controllers/reset_password'
require_relative 'controllers/register.rb'
require_relative 'controllers/settings.rb'
require_relative 'controllers/user.rb'
require_relative 'controllers/item.rb'
require_relative 'controllers/item_edit.rb'
require_relative 'controllers/item_activate.rb'
require_relative 'controllers/item_buy.rb'
require_relative 'controllers/item_create.rb'
require_relative 'controllers/item_merge.rb'
require_relative 'controllers/item_search.rb'
require_relative 'controllers/delete_account.rb'
require_relative 'controllers/buy.rb'
require_relative 'controllers/buy_confirm.rb'
require_relative 'controllers/verify'


class App < Sinatra::Base

  use Login
  use DeleteAccount
  use Register
  use Main
  use User
  use Item
  use ItemEdit
  use ItemActivate
  use ItemBuy
  use ItemCreate
  use Settings
  use ItemMerge
  use Buy
  use BuyConfirm
  use ResetPassword
  use Verify


  enable :sessions

  set :public_folder, 'app/public'
  set :show_exceptions, false
  set :root, File.dirname(__FILE__)
  set :public_folder, Proc.new { File.join(root, "public")}

  configure :development do
    database = Marketplace::Database.instance

    # Create some users
    daniel = Marketplace::User.create('Daniel','hallo','test@testmail1.com')
    joel = Marketplace::User.create('Joel','test','joel.guggisberg@students.unibe.ch')
    lukas = Marketplace::User.create('Lukas','lol','lukas.v.rotz@gmail.com')
    oliver = Marketplace::User.create('Oliver','aha','test@testmail3.com')
    rene = Marketplace::User.create('Rene','wtt','sudojudo@eml.cc')
    urs = Marketplace::User.create('Urs','123','UrsZysset@gmail.com')
    ese = Marketplace::User.create('ese','ese','ese@trash-mail.com')

    # Give them some money
    daniel.add_credits(2000)
    joel.add_credits(400)
    lukas.add_credits(400)
    oliver.add_credits(400)
    rene.add_credits(4000)
    urs.add_credits(1000)
    ese.add_credits(1000)

    # Verify users
    urs.verify
    daniel.verify
    joel.verify
    lukas.verify
    rene.verify
    ese.verify


    # Create some items
    item1 = Marketplace::Item.create('Table', 100, 20, daniel)
    item2 = Marketplace::Item.create('Inception, Dvd', 10, 30, joel)
    item3 = Marketplace::Item.create('Bed', 50, 2, lukas)
    item4 = Marketplace::Item.create('Tolkien, Lord of the Rings 1, Book', 20, 1, oliver)
    item5 = Marketplace::Item.create('Shoes', 80, 7, rene)
    item6 = Marketplace::Item.create('Trousers', 60, 99, urs)
    item7 = Marketplace::Item.create('Bed', 60, 4, joel)
    item8 = Marketplace::Item.create('Bed', 30, 5, oliver)
    item9 = Marketplace::Item.create('Shoes', 20, 4, oliver)
    item10 = Marketplace::Item.create('Fridge', 210, 2, oliver)
    item11 = Marketplace::Item.create('Fridge', 300, 5, lukas)
    item12 = Marketplace::Item.create('Fridge', 279, 10, rene)
    item13 = Marketplace::Item.create('Red Fridge', 400, 10, joel)
    item14 = Marketplace::Item.create('Spicy Chily', 35, 15, ese)
    item15 = Marketplace::Item.create('Apple', 3, 15, ese)
    item16 = Marketplace::Item.create('Apple', 3, 10, ese)
    item17 = Marketplace::Item.create('Can of Beans', 3, 8, ese)
    item18 = Marketplace::Item.create('SuperMan Costume', 3, 60, oliver)
    item19 = Marketplace::Item.create('Bravo  Hits 5, CD', 2, 1, ese)
    item20 = Marketplace::Item.create('The Matrix, DVD', 20, 3, joel)
    item21 = Marketplace::Item.create('Golden Rolex', 1000, 1, urs)
    item22 = Marketplace::Item.create('Vestax VCI 400 Dj Controller', 400, 1, lukas)
    item23 = Marketplace::Item.create('THE one and only Magic Ring', 30000, 1, rene)
    item24 = Marketplace::Item.create('Cool Runnings, DVD', 40, 4, ese)
    item25 = Marketplace::Item.create('Bag of Dubplates', 10, 7, rene)
    item26 = Marketplace::Item.create('AK 47', 1000, 3, ese)
    item27 = Marketplace::Item.create('Dreamcatcher', 10, 40, daniel)

    # Set the items state to active and add them to database
    database.set_all_active_and_add(item1,item2,item3,item4,item5,item6,item7,item8,item9,item10)
    database.set_all_active_and_add(item11,item12,item13,item14,item15,item16,item17,item18,item19,item20)
    database.set_all_active_and_add(item21,item22,item23,item24,item25,item26,item27)

    database.add_user(daniel)
    database.add_user(joel)
    database.add_user(lukas)
    database.add_user(oliver)
    database.add_user(rene)
    database.add_user(urs)
    database.add_user(ese)

  end

end

# Now, run it
App.run!