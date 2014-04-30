require 'active_support/core_ext'
require 'json'
require 'webrick'
require_relative '../lib/rails_lite'
require_relative '../controllers/user_controller.rb'



server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

router = Router.new
router.draw do
  get Regexp.new("^/users$"), UserController, :index
  get Regexp.new("^/users/new$"), UserController, :new
  post Regexp.new("^/users$"), UserController, :create
  get Regexp.new("^/users/(?<id>\\d+)$"), UserController, :show
  
  # get Regexp.new("^/statuses$"), StatusController, :index
  # get Regexp.new("^/users$"), UserController, :index
  # 
  # # uncomment this when you get to route params
  # get Regexp.new("^/statuses/(?<id>\\d+)$"), StatusController, :show
  # get Regexp.new("^/statuses/(?<id>\\d+)$/edit"), StatusController, :edit
  # get Regexp.new("^/statuses/new$"), StatusController, :new
end

server.mount_proc '/' do |req, res|
  route = router.run(req, res)
end

server.start