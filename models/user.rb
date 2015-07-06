class AccountBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection(YAML::load(File.open('config/database.yml')))
  logger = Logger.new(File.open('log/database.log', 'w'))
end

class User < AccountBase
  self.table_name = 'users'
  #SECRET_KEY = "3b5ada303cf85efaf9e6dc70277468d8b9c24fda9180ad9f82e5d7250b35d82084d64257649b0ec7"

  before_create :generate_salt_hash_password

    
  def self.authenticate(email, password)
    user = find_by_email(email)
    (return nil) if user.nil?
    salt = user.salt
    check_password = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), App::SECRET_KEY, "#{password}#{salt}")
    user.password == check_password ? (return user) : (return nil)
  end
  private
    def generate_salt_hash_password
      begin
        self.salt = SecureRandom.hex(40)
      end while self.class.exists?(salt: salt)
    
      self.password = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), App::SECRET_KEY, "#{self.password}#{self.salt}")
    end  
end
