class ItemEdit < Sinatra::Application

  # Displays the view to edit items with given id
  get "/item/:id/edit" do

    id = params[:id].to_i
    current_item = Marketplace::Item.by_id(id)


    if current_item.active
      session[:message] = "You can't edit a active item"
      redirect "/item/#{id}"
    end

    message = session[:message]
    session[:message] = nil
    haml :item_edit, :locals => { :item => current_item,
                                  :info => message}
  end

  # Will edit item with given id according to given params
  # If name or price is not valid, edit will fail
  # If edit succeeds, it will redirect to profile of edited item
  post "/item/:id/edit" do

    id = params[:id].to_i
    new_name = params[:name]
    new_price = params[:price]
    current_item = Marketplace::Item.by_id(id)


    if(new_name == nil or new_name == "" or new_name.strip! == "")
      session[:message] = "empty name!"
      redirect "/item/#{id}/edit"
    end


    begin
      !(Integer(new_price))

      rescue ArgumentError
        session[:message] = "price was not a number!"
        redirect "/item/#{id}/edit"
    end

    current_item.name = new_name
    current_item.price = new_price.to_i

    redirect "/item/#{id}"
  end

end