require 'jwt'
require "json"

SECRET_KEY = "lasjdflajsdlfkjasldkfjalksdjflk"

def api_authenticate!
	@api = true
	bearer = request.env["HTTP_AUTHORIZATION"]

	if bearer
		encoded_token = bearer.slice(7..-1)
		begin
		decoded_token = JWT.decode encoded_token, SECRET_KEY, true, { algorithm: 'HS256' }
		user_id = decoded_token[0]["user_id"]
		@api_user = User.get(user_id)
		rescue JWT::DecodeError
		 	halt 401, 'A valid token must be passed.'
	    rescue JWT::ExpiredSignature
	     	halt 401, 'The token has expired.'
	    rescue JWT::InvalidIssuerError
	    	halt 401, 'The token does not have a valid issuer.'
	    rescue JWT::InvalidIatError
	    	halt 401, 'The token does not have a valid "issued at" time.'
		end
	else
		halt 401, 'A valid token must be passed.'
	end

end

def token user_id
  payload = { user_id: user_id }
  JWT.encode payload, SECRET_KEY, 'HS256'
end

def current_user
	if @api
		return @api_user
	else
		if(session[:user_id])
			@u ||= User.first(id: session[:user_id])
			return @u
		else
			return nil
		end
	end
end

get "/api/login" do
	username = params["username"]
	password = params["password"]
	if username && password
		user = User.first(email: username.downcase)

		if(user && user.login(password))
			content_type :json
			return {token: token(user.id)}.to_json
		else
			message = "Invalid credentials #{username}"
	    	halt 401, {"message": message}.to_json
		end
	else
		message = "Missing username or password"
	    halt 401, {"message": message}.to_json
	end
end

post "/api/register" do
	username = params["username"]
	password = params["password"]
	if username && password
		user = User.first(email: username.downcase)

		if(user)
				halt 422, {"message": "Username already in use"}.to_json
		else
				u = User.new
				u.email = username.downcase
				u.password = password
				u.save
				halt 201, {"message": "Account successfully registered"}.to_json
		end
	else
		message = "Missing username or password"
	  halt 400, {"message": message}.to_json
	end
end

get "/api/token_check" do
	api_authenticate!
	return {"message": "Valid Token"}.to_json
end