class BuyOrderCreate < Sinatra::Application

  before do
    @database = Marketplace::Database.instance
  end


  get '/createBuyOrder' do

    current_user = @database.user_by_name(session[:name])

    if current_user
      message = session[:message]
      session[:message] = nil
      haml :buy_order_create, :locals => {:info => message }
    else
      session[:message] = "~error~Log in to create buy orders!"
      redirect '/login'
    end

  end


  post '/createBuyOrder' do

    item_name = params[:item_name]
    max_price = params[:max_price]
    current_user = @database.user_by_name(session[:name])


    session[:message] = ""
    session[:message] += Helper::Validator.validate_string(item_name, "name")
    session[:message] += Helper::Validator.validate_integer(max_price, "max price", 1, nil)
    if session[:message] != ""
      redirect '/createBuyOrder'
    end

    # Check if buy_order is already satisfiable
    # If yes, go back home and tell user to find it himself
    possible_items = Marketplace::Database.instance.item_by_name(item_name)
    count = possible_items.count{ |item| item.name == item_name and
                                  item.price < max_price.to_i and
                                  item.owner != current_user and
                                  item.active == true }
    if count > 0
      session[:message] = "~note~the item your willing to buy is already available.</br>use the search to find it."
      redirect "/"
    else
      Marketplace::BuyOrder.create(item_name, max_price.to_i, current_user)
      session[:message] = "~note~you have created a new buy order."
      redirect "/user/#{current_user.name}"
    end

  end

end