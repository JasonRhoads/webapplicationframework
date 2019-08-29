class Routes
  def self.get_routes(directory)
    routes = {}
    routes_file = File.open("#{directory}/../controllers/routes.txt")
    routes_file.each do |line|
      http_method_and_path, callback = line.scan(/(\w+\s+(?:\/\s|\/\w+)+)\s*(\w+#\w+)/)
        .flatten
      routes[http_method_and_path] = callback
    end
    routes
  end
end