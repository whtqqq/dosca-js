class Application
  ROOT_CONTROLLER = :top
  DEFAULT_ACTION = :index

  class << self
    def get_controller_and_action_name
      url_split = ENV['REQUEST_URI'].split('/').delete_if{|element| element.empty? || element.match(/\?/) != nil}
      controller = url_split[1] || ROOT_CONTROLLER
      action = url_split[2] || DEFAULT_ACTION
      {:controller => controller, :action => action}
    end
  end
end
