class Path
  include Mongoid::Document
  #include Mongoid::Attributes::Dynamic
  field :structure, type: Hash
end
