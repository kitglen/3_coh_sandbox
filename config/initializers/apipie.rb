Apipie.configure do |config|
  config.app_name = "Coh"
  config.copyright = "&copy; 2012 Ap"
  config.doc_base_url = "/admin/docs"
  config.api_base_url = "/api"
  config.validate = false
  config.markup = Apipie::Markup::Markdown.new
  config.layout = 'documentation.html.haml'
  config.reload_controllers = true
  config.api_controllers_matcher = File.join(Rails.root, "app", "controllers", "api", "**","*.rb")
  config.app_info = <<-DOC
    COH
  DOC
end