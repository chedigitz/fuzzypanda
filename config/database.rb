

require 'yaml'

configuration = YAML::load(File.open(File.join(PADRINO_ROOT,"config", '.mongo.yml')))

#if ENV['HEROKU']
  #PADRINO_ENV = "heroku"
#end



case Padrino.env
  when :development then MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)
  when :production then
   #MongoMapper.connection = Mongo::Connection.from_uri('mongodb://chedigitz:welcome11@flame.mongohq.com:27103',  :logger => logger).db('pf_test')
   MongoMapper.setup(configuration, :production, :logger => logger)

 end
case Padrino.env
  when :development then MongoMapper.database = 'jp2_development'
  #when :production  then MongoMapper.database = 'pf_test'
  when :test        then MongoMapper.database = 'jp2_test'
end
