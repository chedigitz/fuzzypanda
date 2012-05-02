MongoMapper.config = { :production => 
  		{
  		'uri' => 'mongodb://flame.mongohq.com:27103/',
  		'username' => 'chedigitz',
  		'password' => 'welcome11',
  		'database' => 'pf_test',
  		'port' => 27103
  	    },
  	    :test => { 'uri' => 'mongodb://localhost/jp2_test'},
  	    :development => { 'uri' => 'mongodb://localhost/jp2_development'}
  	}
MongoMapper.connect(Padrino.env)


