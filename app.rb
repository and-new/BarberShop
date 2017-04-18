#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers

	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values(?)', [barber]
		end

	end
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'create table if not exists 
					"Users"
					 (	"id" integer primary key autoincrement, 
						"username" text,
						"phone" text,
						"datestamp" text, 
						"barber" text, 
						"color" text)'

db.execute 'create table if not exists 
					"Barbers"
					 (	"id" integer primary key autoincrement, 
						"name" text)'

	seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehr']
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
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

db.execute 'insert into 
				Users 
				(username, 
				 phone, 
				 datestamp, 
				 barber, 
				 color)
				 values( ?, ?, ?, ?, ?)',
				 [@username, @phone, @datetime, @barber, @color]

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, 
	#{@barber}, #{@color}"

end

#def is_parameters_empty? hh

#end
get '/showusers' do
 	db = get_db

 	@results = db.execute 'select * from Users order by id desc'

 	erb :showusers
end

