class RootController < ApplicationController
  caches_action :index
  def index;end
end