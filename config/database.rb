case Padrino.env
  when :development then MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)
  when :production then MongoMapper.connection = Mongo::Connection.from_uri('mongodb://chedigitz:welcome11@flame.mongohq.com', 27103,  :logger => logger).db('pf_test')

end
case Padrino.env
  when :development then MongoMapper.database = 'jp2_development'
  when :test        then MongoMapper.database = 'jp2_test'
end
