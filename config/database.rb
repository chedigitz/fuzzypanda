case Padrino.env
  when :development then MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)
  when :production then MongoMapper.connection = Mongo::Connection.new('mongodb://purplepanda:welcome11@ds033047.mongolab.com:33047/pf_test',  :logger => logger)

end
case Padrino.env
  when :development then MongoMapper.database = 'jp2_development'
  when :production  then MongoMapper.database = 'pf_test'
  when :test        then MongoMapper.database = 'jp2_test'
end
