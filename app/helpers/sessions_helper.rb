module SessionsHelper

	def sign_in(user)
		self.current_user = user
		session[:current_user] = self.current_user
	end

	def sign_out
		self.current_user = nil
		ssession[:current_user] = nil
	end

	def signed_in?
		ssession[:current_user].nil?
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user
	end

end
