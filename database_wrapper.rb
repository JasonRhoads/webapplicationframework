require "sqlite3"
require "sequel"

class DatabaseWrapper
  def self.dbConnect()
    Sequel.connect('sqlite://database.db')
  end
end
