
require 'yaml'

configuration = YAML::load(File.open(File.join(PADRINO_ROOT,"config", '.mongo.yml')))


#if ENV['HEROKU']
  #PADRINO_ENV = "heroku"
#end

MongoMapper.setup(configuration, Padrino.env, :logger => logger, :slave_ok => true)
MongoMapper.connect(Padrino.env)