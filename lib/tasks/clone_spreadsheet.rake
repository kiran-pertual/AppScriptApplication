namespace :clone_spreadsheet do
  task :run => :environment do
    # sample payload
    payload = {
        "function" => "copySheet",
        "parameters" => [
            {
                "id" => FOLDER_ID,
                "name" => "BOS - 103 ARCH STREET- AUG2018 - LEASE QUALITY SCORE",
                "mature_revenue" => 61631,
                "mature_rent" => 31604,
                "mature_margin" => 14149,
                "rent_month_five" => 2509
            }.to_json
        ]
    }
    service = Utilities::HttpService.new
    path = "https://script.googleapis.com/v1/scripts/#{SCRIPT_ID}:run"
    header = { "Content-Type" => "application/json" }
    attempt = 1

    begin
      result = service.post_to_endpoint(path, payload, header)
      if result["error"] && result["error"]["code"].to_i == 401
        service.authenticate.get_access_token_using_refresh_token(service)
        raise "InvalidTokenError"
      end
    rescue Exception => e
      puts "in retry with error : #{e}"
      attempt -= 1
      sleep 5
      retry if attempt >= 0
    end
  end
end
