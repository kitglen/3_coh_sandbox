# Extend your models with custom code here. This module will be included at the end of the generated model.
# The same module is included in all model versions, but you can check for versions by inspecting the model's class.
# Otherwise, if you have version-specific needs, you can edit the specific version model directly; it won't be overwritten.
#
# ActiveSupport::Concern may make extending the model easier. Read more here: http://api.rubyonrails.org/classes/ActiveSupport/Concern.html
module V3::Custom::Doctor
  extend ActiveSupport::Concern

  included do
# validate :custom_validation_method
# after_create :custom_hook
end

# def custom_validation_method
# end

# def custom_hook
# end

module ClassMethods
# def custom_finder
# end
end

end