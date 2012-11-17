# Extend your controllers with custom code here. This module will be included at the end of the generated controller.
# The same module is included in all controller versions, but you can check for versions by inspecting the controller's class.
# Otherwise, if you have version-specific needs, you can edit the specific version controller directly; it won't be overwritten.
#
# ActiveSupport::Concern may make extending the controller easier. Read more here: http://api.rubyonrails.org/classes/ActiveSupport/Concern.html
module Api::V4::Custom::DoctorsController
  extend ActiveSupport::Concern

  included do
# before_filter :custom_filter
end

# def custom_filter
# end

# def show
#   super
#   log_analytics
# end

end