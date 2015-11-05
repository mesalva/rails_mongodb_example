class Path
  include Mongoid::Document
  #include Mongoid::Attributes::Dynamic
  field :structure, type: Hash

  before_create :clear

  def clear
  	Path.delete_all
  end
end
