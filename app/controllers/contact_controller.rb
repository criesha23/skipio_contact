class ContactController < ApplicationController
	require 'uri'
	require 'net/http'
	
	def index
		url = URI("https://stage.skipio.com/api/v2/contacts?token={{token}}&page=1&per=10")
	 	http = Net::HTTP.new(url.host, url.port)
	 	http.use_ssl = true
		request = Net::HTTP::Get.new(url)
		request["content-type"] = 'application/json'
		response = http.request(request)

		response = JSON.parse(response.read_body)
		@response_body = response['data']
		respond_to do |format|
		    format.js   {}	
		    format.html {}
		end
	end

	def send_sms
		if params[:commit] == 'Send'
			url = URI("https://stage.skipio.com/api/v2/messages?token={{token}}")

			http = Net::HTTP.new(url.host, url.port)
			http.use_ssl = true
			request = Net::HTTP::Post.new(url)
			request["content-type"] = 'application/json'
			request.body = "{\n  \"recipients\": [\n    \"contact-#{params[:id]}\"\n  ],\n  \"message\": {\n    \"body\": \"#{params[:message]}\"\n  }\n}"

			response = http.request(request)
			puts response.read_body
		end
		respond_to do |format|
		    format.js   {}	
		    format.html {}
		end
	end
end
