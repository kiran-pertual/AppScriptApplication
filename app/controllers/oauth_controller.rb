class OauthController < ApplicationController
  def auth
    puts params.inspect

    render json: {success: true}
  end
end
