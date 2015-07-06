desc 'Generates a secret key for the application.'

  #path = File.join('..','config', 'app_secret_key.rb')
  

desc 'Generates a secret token for the application.'
task :generate_secret_key do
  path = File.expand_path("../../config/app_secret_key.rb", __FILE__)
  secret = SecureRandom.hex(40)
  File.open(path, 'w') do |f|
    f.write <<-EOF
module App 
  SECRET_KEY = "#{secret}"
end
    EOF
  end
end
