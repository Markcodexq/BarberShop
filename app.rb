#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = "something wrong!"
	erb :about
end

get '/contacts' do
	erb :contacts
end

get '/visit' do
	erb :visit
	
end

post '/visit' do
	@user = params[:user_name]
	@phone = params[:user_phone]
	@date = params[:date_time]
	@choise = params[:choise]
	@color = params[:color]

	# if @user == ""
	# 	@error = "Write a user name"
	# elsif @phone == ""
	# 	@error = "Write a phone number"
	# elsif @date == ""
	# 	@error = "Write the data"
	# end

	# if @error != ""
	# 	return erb :visit
	# end

	# Hash
	hh = {
		:user_name => 'Enter the name', 
		:user_phone => 'Enter the phone', 
		:date_time => 'Enter the date'
	}

	# # Для каждой пары ключ, значение
	# hh.each do |key, value|
	# 	# Если параметр пуст
	# 	if params[key] == ""
	# 		# Переменной error присваиваем value из хеша
	# 		# (А value из хеша это сообщение об ошибке)
	# 		# т.е переменной error присваиваем сообщение об ошибке
	# 		@error = hh[key]
	# 		# вернуть представление visit
	# 		return erb :visit
	# 	end
	# end
	
	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ""
		return erb :visit
	end
	
	@message = "Dear #{@user}, you will add to our system, phone is - #{@phone}, date - #{@date}, master - #{@choise}, color - #{@color}"

	f = File.open './public/users.txt', 'a'
	f.write "User: #{@user}, Phone: #{@phone}, Date: #{@date}, Master: #{@choise}, Color: #{@color}\n"
	f.close
	erb :visit
end


post '/contacts' do
	@ename = params[:e_name]
	@email = params[:email]
	@etext = params[:e_text]
	
	@send = "Name is #{@ename}, mail - #{@email}, text - #{@etext}"
	Pony.options = {
		:subject => "Some Subject",
		:body => "This is the body.",
		:via => :smtp,
		:via_options => {
		  :address              => 'smtp.gmail.com',
		  :port                 => '587',
		  :enable_starttls_auto => true,
		  :user_name            => 'noreply@cdubs-awesome-domain.com',
		  :password             => ENV["SMTP_PASSWORD"],
		  :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
		  :domain               => "localhost.localdomain"
		}
	  }
	erb :contacts
end
