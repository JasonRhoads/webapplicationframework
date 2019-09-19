class Routes
  def initialize(app_root)
    @routes = {}
    routes_file = File.open("#{app_root}/../controllers/routes.txt")
    routes_file.each do |line|
      http_method_and_path, callback = line.scan(/(\w+\s+(?:\/\s|\/\w+)+)\s*(\w+#\w+)/)
        .flatten
      @routes[http_method_and_path] = callback
    end
  end

  def has_key?(key)
    @routes.has_key?(key)
  end

  def [](key)
    @routes[key]
  end
end