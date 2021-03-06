#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "blog.db"}

class Post < ActiveRecord::Base
	validates :content, presence: true
end

class Coment < ActiveRecord::Base
	validates :content, presence: true
end

before do
	@posts = Post.order('created_at DESC')
	#@coments = Coment.order('created_at DESC')
end


get '/' do
	erb :index			
end

get '/new' do
	@n = Post.new
  erb :new
end

post '/new' do
	@n = Post.new params[:post]
	if @n.save
		redirect to '/'
	else
		@error = @n.errors.to_h.first.join(': ')
  		erb :new
  	end	
end

get '/details/:id' do
	
	@post = Post.find(params[:id])
  	@coments = Coment.where post_id: params[:id]
  	erb :details
end

post '/details/:id' do
	@c = Coment.new params[:aaa]
	@c.post_id = params[:id]
	if @c.save
	 	 redirect to ('/details/' + params[:id] )
	else 
		@error = @c.errors.to_h.first.join(': ')
		@post = Post.find(params[:id])
		@coments = Coment.where post_id: params[:id]
		 return erb :details
	end 	 
end