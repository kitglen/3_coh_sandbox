class Admins::SessionsController < Devise::SessionsController
  def after_sign_out_path_for(admin)
    admin_root_path
  end
end