#!/usr/bin/env ruby
# ------------------------------------------------------
# FILE: reset_openwebui_admin.rb
# USAGE:
#   1) ./reset_openwebui_admin.rb [EMAIL] [PASSWORD]
#   2) If you omit PASSWORD, you'll be prompted to type it.
#
# EXAMPLE:
#   ./reset_openwebui_admin.rb jonathan@domain.com "myNewPassword"
# ------------------------------------------------------

require 'io/console'
begin
  require 'bcrypt'
rescue LoadError
  puts "bcrypt gem is not installed. Please install it with:\n  gem install bcrypt"
  exit 1
end

class AdminPasswordUpdater
  attr_reader :email, :password

  def initialize(email, password)
    @email = email
    @password = password
  end

  # Generates the SQL statement to update the user password in the "auth" table
  def generate_update_sql
    hashed = BCrypt::Password.create(password)
    "UPDATE auth SET password='#{hashed}' WHERE email='#{email}';"
  end
end

# CLI entrypoint
if __FILE__ == $PROGRAM_NAME
  email = ARGV[0] || 'admin@example.com'
  password = ARGV[1]

  if password.nil? || password.empty?
    print "Enter new admin password for '#{email}' (hidden): "
    password = $stdin.noecho(&:gets).chomp
    puts
  end

  updater = AdminPasswordUpdater.new(email, password)
  sql_update_stmt = updater.generate_update_sql

  puts "\nConnect to openweb container (./connect_to_open_web.sh). Install sqlite3 (apt-get update && apt-get install sqlite3) if it's not already installed. Connect to the db (sqlite3 data/webui.db). Use this SQL to update the password in webui.db:\n\n#{sql_update_stmt}\n\n"
  puts "After running that SQL (via sqlite3), restart OpenWebUI and log in with the new credentials."
end
