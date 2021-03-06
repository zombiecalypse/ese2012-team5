class ResetPassword < Sinatra::Application

  before do
    @database = Marketplace::Database.instance
  end


  get '/forgot_password' do
    message = session[:message]
    session[:message] = nil
    haml :forgot_password, :locals => { :info => message }
  end


  post '/forgot_password' do
    email = params[:email]

    if (!@database.email_exists?(email))
      session[:message] = "~error~email '#{email}' don't exists in database!"
      redirect '/forgot_password'
    end

    user = @database.user_by_email(email)
    # Send email
    Helper::Mailer.send_pw_reset_mail(user)

    session[:message] = "~note~email sent.</br>please check your mails for reset-link."
    redirect '/login'
  end


  get '/reset_password/:hash' do
    message = session[:message]
    session[:message] = nil

    # Delete entries older than 24h from reset password hashmap
    @database.clean_pw_reset_older_as(24)

    #check if hash exists
    if !(@database.pw_reset_has?(params[:hash]))
      session[:message] = "~error~unknown/timed out link please request a new one!"
      redirect '/login'
    end

    haml :user_reset_password, :locals => { :info => message,
                                           :hash => params[:hash]}
  end


  post '/reset_password/:hash' do
    password = params[:password]
    password_conf = params[:password_conf]
    hash = params[:hash]

    session[:message] = Helper::Validator.validate_password(password, password_conf, 4)
    if session[:message] != ""
      redirect "/reset_password/#{hash}"
    end

    #check for which user has that hash
    user = @database.pw_reset_user_by_hash(hash)
    user.change_password(password)
    @database.delete_pw_reset(hash)

    session[:message] = "~note~password changed, now log in."
    redirect '/login'
  end

end
