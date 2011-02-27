require "demo"

module TestedModelHelper
  def create_model(user = standard_user)
    model_factory.create(user)
  end
  
  def model_factory
    "Demo::#{model_name}".constantize
  end
  
  def model_name
    self.class.to_s.gsub(/(Controller)*Test$/, '').singularize
  end
  
  def model_sym
    model_name.underscore.to_sym
  end
end