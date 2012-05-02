
case Padrino.env
  when :development then MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)
  when :production then 
  	MongoMapper.config = { 
  		:production => { 'uri' => 'mongodb://chedigitz:welcome11@flame.mongohq.com:27103/pf_test'},
  	    :test => { 'uri' => 'mongodb://localhost/jp2_test'},
  	    :development => {uri => 'mongodb://localhost/jp2_development'}
  	}
    MongoMapper.connect(Padrino.env)
end
case Padrino.env
  when :development then MongoMapper.database = 'jp2_development'
  when :production  then MongoMapper.database = 'pf_test'
  when :test        then MongoMapper.database = 'jp2_test'
end
