class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = (pattern.is_a?(Regexp)) ? pattern : pattern.to_s
    @http_method = http_method
    @controller_class, @action_name = controller_class, action_name
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)
    request_method = req.request_method.downcase.to_sym
    pattern.match(req.path) && @http_method == request_method
  end

  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res)
    route_params = {}
    route_match = pattern.match(req.path)
    route_match.names.each { |key| route_params[key] = route_match[key]}
    instance = @controller_class.new(req, res, route_params)
    instance.invoke_action(@action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
    self.instance_eval(&proc)
  end

  # make each of these methods that
  # when called add route
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # should return the route that matches this request
  def match(req)
    @routes.each do |route| 
      return route if route.matches?(req)
    end
    nil
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
    route = match(req)
    if route == nil
      res.status = 404
    else
      route.run(req,res)
    end
  end
end
