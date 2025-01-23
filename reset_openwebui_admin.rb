#!/usr/bin/env ruby
# ------------------------------------------------------
# FILE: reset_openwebui_admin.rb
# USAGE: ./reset_openwebui_admin.rb [EMAIL] [HOST] [PORT]
# ------------------------------------------------------

require 'io/console'
require 'net/http'
require 'uri'
require 'json'

# Grab command-line args or set defaults
email = ARGV[0] || 'admin@example.com'
host  = ARGV[1] || 'localhost'
port  = ARGV[2] || '8080'
password = 'ollama'

if password.nil? || password.empty?
  # Prompt for a password without echoing
  print 'Enter new admin password (hidden): '
  password = $stdin.noecho(&:gets).chomp
  puts
end

# Build the POST request
uri = URI("http://#{host}:#{port}/api/v1/auths/signup")
req = Net::HTTP::Post.new(uri)
req['Content-Type'] = 'application/json'
req.body = {
  email: email,
  password: password,
  name: 'Admin'
}.to_json

puts "Creating/resetting user: #{email} at #{host}:#{port}"
response = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end

puts "Response Code: #{response.code}"
puts "Response Body: #{response.body}"
