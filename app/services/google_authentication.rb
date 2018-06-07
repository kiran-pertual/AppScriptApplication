require 'oauth2'
require 'httparty'
require 'uri'
require 'pry'

class GoogleAuthentication
  attr_reader :client_id, :client_secret, :scope, :redirect_uri, :access_token_obj, :access_token, :refresh_token
  def initialize
    @client_id = CLIENT_ID
    @client_secret = CLIENT_SECRET
    @scope = SCOPES
    @redirect_uri = REDIRECT_URI
    @access_token_obj = nil
    @access_token = nil
    @refresh_token = nil
    authenticate
    print_tokens
  end

  def authenticate
    tokens = YAML.load_file("tokens.yml") if File.exist?("tokens.yml")
    unless File.exist?("tokens.yml")
      File.new("tokens.yml", "w+") unless File.exist?("tokens.yml")
      tokens = YAML.load_file("tokens.yml")
    end

    unless tokens && tokens["refresh_token"]
      auth_client_obj = OAuth2::Client.new(client_id, client_secret, {:site => 'https://accounts.google.com', :authorize_url => "/o/oauth2/auth", :token_url => "/o/oauth2/token"})

      puts "1) Paste this URL into your browser where you are logged in to the relevant Google account\n\n"
      puts auth_client_obj.auth_code.authorize_url(:scope => scope, :access_type => "offline", :redirect_uri => redirect_uri, :approval_prompt => 'force')

      puts "\n\n\n2) Accept the authorization request from Google in your browser:"

      puts "\n\n\n3) Google will redirect you to localhost, but just copy the code parameter out of the URL they redirect you to, paste it here and hit enter:\n"
      code = STDIN.gets.chomp.strip
      @access_token_obj = auth_client_obj.auth_code.get_token(code, { :redirect_uri => redirect_uri, :token_method => :post })

      values = {}
      @access_token = values["access_token"] = @access_token_obj.token
      @refresh_token = values["refresh_token"] = @access_token_obj.refresh_token

      File.open("tokens.yml","w") do |file|
        YAML.dump(values, file)
      end
    else
      @access_token = tokens["access_token"]
      @refresh_token = tokens["refresh_token"]
    end
  end

  def print_tokens
    puts "Access Token is: #{access_token}"
    puts "Refresh token is: #{refresh_token}"
  end

  def get_access_token_using_refresh_token(service)
    begin
      path = "https://www.googleapis.com/oauth2/v4/token"
      payload = {
          client_id: CLIENT_ID,
          client_secret: CLIENT_SECRET,
          refresh_token: @refresh_token,
          grant_type: 'refresh_token'
      }
      tokens = service.post_to_endpoint(path, payload)
      puts tokens
      values = {}
      unless tokens["error"]
        @access_token = values["access_token"] = tokens["access_token"]
        @refresh_token = values["refresh_token"] = refresh_token
        File.open("tokens.yml","w") do |file|
          YAML.dump(values, file)
        end
      end
    rescue Exception => e
      puts "Exception => #{e}"
    end
  end
end