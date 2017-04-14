#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	db = get_db
	db.execute 'create table if not exists 
					"Users"
					 ("id" integer primary key autoincrement, 
					"username" text, "phone" text, "datestamp" text, 
					"barber" text, "color" text)'
	
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = 'something wrong!'
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	# хеш
	hh = { :username => 'Введите имя', 
		   :phone => 'Введите номер телефона', 
		   :datetime => 'Введите дату и время' }

	#if is_parameters_empty
	#	return erb :visit
	#end

	# для каждой пары ключ-значение
	hh.each do |key, value|
		# если параметр пуст
		if params[key] == ''
			# переменной error присвоить value  из хеша hh
			# (а value из хеша hh это сообщение об ошибке)
			# т.е. переменной error присвоить сообщение об ошибке
			@error = hh[key]

			# вернуть представление visit
			return erb :visit
		end
	end

#	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")
#	if @error != ''
#		return erb :visit
#	end

db = get_db
db.execute 'insert into 
				Users (username, phone, datestamp, barber, color)
				values( ?,?,?,?,?)',
				 [@username,@phone,@datetime,@barber,@color]

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, 
	#{@barber}, #{@color}"

end

#def is_parameters_empty? hh

#end
def get_db
	return SQLite3::Database.new 'barbershop.db'
end