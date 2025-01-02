require 'sinatra'
require 'mongo'


db_client = Mongo::Client.new('mongodb://127.0.0.1:27017/todo_app')
db = db_client.database
todos_collection = db[:todos]



get '/' do
  @todos = todos_collection.find().to_a
  erb:index
end


post '/add' do
  task = params[:task].strip
  unless task.empty?
    todos_collection.insert_one({ task: task })
  end
  redirect '/'
end

post '/delete' do
  index = params[:index]
  unless index.nil?
    todos_collection.delete_one({ _id: BSON::ObjectId.from_string(index) })
  end
  redirect '/'
end