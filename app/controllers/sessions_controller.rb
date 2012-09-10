class SessionsController < ApplicationController

	def login
		consumer_key = 'hO1bdfU2Mah15C8RggwQ'
		consumer_secret = 'HPu1cR8HesktB0n0pUAGLvuLeki9N6PE1LajFkpqaA'

		oauth = OAuth::Consumer.new(consumer_key, consumer_secret, site: "https://api.twitter.com", request_token_path: "/oauth/request_token")

		request_token = oauth.get_request_token(oauth_callback: "http://127.0.0.1:3000/callback")
		session[:token] = request_token.token
		session[:secret] = request_token.secret

		redirect_to request_token.authorize_url
	end

	def login_callback
		consumer_key = 'hO1bdfU2Mah15C8RggwQ'
		consumer_secret = 'HPu1cR8HesktB0n0pUAGLvuLeki9N6PE1LajFkpqaA'

		oauth = OAuth::Consumer.new(consumer_key, consumer_secret, site: "https://api.twitter.com", request_token_path: "/oauth/request_token", access_token_path: "/oauth/access_token", authorize_path: "/oauth/authorize")

		request_token = OAuth::RequestToken.new(oauth, session[:token], session[:secret])
		access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])

		session[:token] = access_token.token
		session[:secret] = access_token.secret
		#session[:access_token] = access_token

		response = oauth.request(:get, '/1.1/account/verify_credentials.json', access_token, { :scheme => :query_string })
		user_info = JSON.parse(response.body)

		user = User.find_by_name(user_info['screen_name'])
		if (user.nil?) 
			user = User.create(email: "#{user_info['screen_name']}@twitter.com", name: user_info['screen_name'], twitter_image: user_info['profile_image_url'] )
		end

		sign_in user
		redirect_to user
	end

	def destroy
		sign_out
    	redirect_to root_url
	end

end
