require "sqlite3"
require "sequel"

class Database
  def self.db_connect()
    Sequel.connect('sqlite://database.db')
  end
end
