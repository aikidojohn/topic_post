module UsersHelper
	def avatar_for(user, options = { size: 50 })
		url = user.twitter_image
		image_tag(url, alt: user.name, class: "gravatar")
	end

end
