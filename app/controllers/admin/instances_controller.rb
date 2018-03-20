class Admin::InstancesController < Admin::BaseController
  def index
    @instances = Instance.all
  end
end
