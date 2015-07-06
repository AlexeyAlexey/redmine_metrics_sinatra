namespace :create do
  desc "Create User"
  
  task :user => :environment do
    user = User.new
    user.email    = ENV["USER_EMAIL"]
    user.password = ENV["PASSWORD"]
    user.username = ENV["USER_NAME"]
    user.save!
  end

  task :environment do
	ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml')))
	ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))
  end 
end