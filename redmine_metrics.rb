# myapp.rb
require './boot'

class RedmineMetrics < Sinatra::Base
  #use Rack::Session::Pool, :expire_after => 2592000
  #set :session_secret, 'super secret'

   get '/' do
     unless env['warden'].authenticated?
       flash[:error] = "Incorrect Username or Password!"
       status 401
       redirect "/login"
       return
     end
     #ActionControllerLoggers.all
     #SELECT * FROM tbl LIMIT 5,10;  # Retrieve rows 6-15
     @select_all = RedmineMetricsDb.connection.execute("SELECT * FROM action_controller_#{200}_loggers LIMIT #{0}, #{10}")
     @user_current = env['warden'].user
	   haml :'charts/index', layout: :application
   end

   get '/chart_bar' do
     unless env['warden'].authenticated?
       flash[:error] = "Incorrect Username or Password!"
       status 401
       redirect "/login"
       return
     end
     #if request.xhr?
     #end
     response = RedmineMetricsDb.connection.execute("SELECT (SELECT COUNT(*) FROM action_controller_100_loggers) as table100,
                                                            (SELECT COUNT(*) FROM action_controller_200_loggers) as table200,
                                                            (SELECT COUNT(*) FROM action_controller_300_loggers) as table300,
                                                            (SELECT COUNT(*) FROM action_controller_400_loggers) as table400,
                                                            (SELECT COUNT(*) FROM action_controller_500_loggers) as table500
                                                    ")
    response_code = response.map{|r| r}.flatten
     { '100' => response_code[0],
       '200' => response_code[1],
       '300' => response_code[2],
       '400' => response_code[3],
       '500' => response_code[4]
     }.to_json
   end

   
   # This is the route that unauthorized requests gets redirected to.
    post '/unauthenticated/?' do
     flash[:error] = "Incorrect Username or Password!"
     status 401
     redirect "/login" 
   end 
   

    get '/login/?' do
      haml :'user/login', layout: :application
    end

    post '/login/?' do
      env['warden'].authenticate!
      redirect "/"
    end
    
    get '/logout/?' do
      env['warden'].logout
      redirect "/login"
    end 


   ###  Warden  ###

   Warden::Manager.serialize_into_session{|user| user.id }
   Warden::Manager.serialize_from_session{|id| User.find_by_id(id) }
   
   Warden::Manager.before_failure do |env,opts|
     # Sinatra is very sensitive to the request method
     # since authentication could fail on any type of method, we need
     # to set it for the failure app so it is routed to the correct block
     env['REQUEST_METHOD'] = "POST"
   end
   
   Warden::Strategies.add(:password) do
	 def valid?
	   params["email"] || params["password"]
	 end
	 def authenticate!
	   u = User.authenticate(params["email"], params["password"])

	   u.nil? ? fail!("Could not log in") : success!(u)
	 end
   end 
   use Rack::Session::Cookie, :secret => "something here"
   use Warden::Manager do |manager|
     manager.default_strategies :password
      # Route to redirect to when warden.authenticate! returns a false answer.
     #action: '/unauthenticated'
     manager.failure_app = self
   end 

   use Rack::Flash

end