class SessionsController < ApplicationController
	def new
	end

	def login
		token_url = 'https://api.twitter.com/oauth/request_token'
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

		redirect_to about_path
	end

	def create
		token_url = 'https://api.twitter.com/oauth/request_token'
		consumer_key = 'hO1bdfU2Mah15C8RggwQ'

	end

	def destroy
	end


	def get_token
		token_url = 'https://api.twitter.com/oauth/request_token'
		consumer_key = 'hO1bdfU2Mah15C8RggwQ'

		#Create a random alpha numeric nonce
		nonce = ('a'..'z').to_a.concat( ('A'..'Z').to_a ).concat( (0..9).to_a ).shuffle[0..30].join

		# construct parameter map for signature
		params = { oauth_signature_method: 'HMAC-SHA1', oauth_version: 1.0, oauth_timestamp: Time.now.to_i, oauth_nonce: nonce, oauth_consumer_key: consumer_key }
		params.merge!( oauth_callback: URI.escape("https://127.0.0.1:3000/signin"))

		#sign and add signature parameter
		signature = sign('POST', token_url, params)
		params.merge!( oauth_signature: signature)

		# send request
		uri = URI(token_url)
		req = Net::HTTP::Post.new(uri.path)
		req['Authorization'] = "OAuth " + params.sort.map{ |k,v| "#{k.to_s}=\"#{URI.escape(v)}\"" }.join(',')
		res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
			http.request(req)
		end

		if res.code != Net::HTTPSuccess
			flash.now[:error] = 'Failed to contact Twitter'
			render 'new'
		end

		res_params = {}
		resp_param_list = res.body.split('&')
		resp_param_list.each do |param|
			kv = param.split('=')
			res_params[kv[0]] = kv[1]
		end

		oauth_token = res_params['oauth_token']
		oauth_token_secret = res_params['oaut_token_secret']
		oauth_callback_confirmed = res_params['oauth_callback_confirmed']
	end

	def sign(method, baseurl,  params = {})
		consumer_secret = 'HPu1cR8HesktB0n0pUAGLvuLeki9N6PE1LajFkpqaA'

		# key=value joined with &
		param_string = params.sort.map { |k,v| "#{k.to_s}=#{URI.escape(v)}"}.join('&')

		# upcase method, baseurl and param string joined with &. NOTE only 2 &s. All the &s in the param string are url encoded
		sig_base = "#{method.upcase}&#{URI.escape(baseurl)}&#{URI.escape(param_string)}"
		
		# the signing key is the consumer secret and the token secret joined with &. If token secret isn't know, then the key ends with a trailing &
		key = "#{URI.escape(consumer_secret)}&" 
		hmac = HMAC::SHA1.new(key)
		hmac.update(sig_base)

		Base64.urlsafe_encode64(hnac.digest)
	end

end
