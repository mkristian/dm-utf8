# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/dm-utf8.rb'
require './lib/version.rb'

Hoe.new('dm-utf8', DmUtf8::VERSION) do |p|
  # p.rubyforge_name = 'dm-utf8' # if different than lowercase project name
  p.summary = 'datamapper extension which removes invalid utf8 sequences from Strings' 
  #p.url = 'http://dm-utf8.rubyforge.com/'
  p.developer('mkristian', 'm.kristian@web.de')
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.remote_rdoc_dir = '' # Release to root
end

desc 'Install the package as a gem.'
task :install => [:clean, :package] dopkg
  gem = Dir['pkg/*.gem'].first
  sh "gem install --local #{gem} --no-ri --no-rdoc"
end

# vim: syntax=Ruby
