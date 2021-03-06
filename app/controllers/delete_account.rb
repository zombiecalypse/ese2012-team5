class DeleteAccount < Sinatra::Application

  before do
    @database = Marketplace::Database.instance
  end


  post '/delete_account' do

    if params[:confirm] != "true"
      session[:message] = "~error~you must confirm that you want to delete your account!"
      redirect '/settings'
    end


    password = params[:password]
    current_user = @database.user_by_name(session[:name])

    if Helper::Checker.check_password?(current_user, password)
      current_user.delete
      session[:message] = "~note~account deleted.</br>see you around!"
      session[:name] = nil
      redirect '/'
    else
      session[:message] = "~error~the password isn't correct!"
      redirect '/settings'
    end

  end

end