class V2::Doctor
  include DataMapper::Resource
  include ActiveModel::MassAssignmentSecurity

  # Include modules for extensions.
  

  storage_names[:'8'] = 'mobile/doctors'
  def self.default_repository_name
    :'8'
  end

  

  # Property definitions
  
    property :id, Integer, field: "Id", key: true, required: false, lazy: false
  
    property :business_phone, Text, field: "BusinessPhone", key: false, required: false, lazy: false
  
    property :department, Text, field: "Department", key: false, required: false, lazy: false
  
    property :diseases, Text, field: "Diseases", key: false, required: false, lazy: false
  
    property :division, Text, field: "Division", key: false, required: false, lazy: false
  
    property :email, Text, field: "Email", key: false, required: false, lazy: false
  
    property :gender, Text, field: "Gender", key: false, required: false, lazy: false
  
    property :high_level, Text, field: "HighLevel", key: false, required: false, lazy: false
  
    property :languages, Text, field: "Languages", key: false, required: false, lazy: false
  
    property :name, Text, field: "Name", key: false, required: false, lazy: false
  
    property :photo, Text, field: "Photo", key: false, required: false, lazy: false
  
    property :program, Text, field: "Program", key: false, required: false, lazy: false
  
    property :specialty, Text, field: "Specialty", key: false, required: false, lazy: false
  
    property :trackback_url, Text, field: "TrackbackUrl", key: false, required: false, lazy: false
  

  # Relationship definitions
  
  
  

  # Simple validations
   

    # Default scopes for System Admin
  attr_accessible :id, :business_phone, :department, :diseases, :division, :email, :gender, :high_level, :languages, :name, :photo, :program, :specialty, :trackback_url, as: :"System Admin"
  # Default accessible scopes when nothing is defined
  attr_accessible :id, :business_phone, :department, :diseases, :division, :email, :gender, :high_level, :languages, :name, :photo, :program, :specialty, :trackback_url, as: :"Unauthenticated Default on create"
  attr_accessible :id, :business_phone, :department, :diseases, :division, :email, :gender, :high_level, :languages, :name, :photo, :program, :specialty, :trackback_url, as: :"Unauthenticated Default on update"


  def initialize(attrs = {}, options = {})
    super({})
    self.assign_attributes(attrs, as: options[:as] )
  end

  def update_attributes(attrs = {}, options = {})
    self.assign_attributes(attrs, as: options[:as] )
    self.save
  end

  def serializable_hash(options={})
    self.to_json(options.merge(to_json: false))
  end

    # Scopes for data access
  class << self
    def all(attributes={}, user_attributes={}, offset = nil, limit = nil)
                      scope = scope.all(:order => [:name.asc])

                     scope = scope.all(offset: offset.to_i) if offset
                     scope = scope.all(limit: limit.to_i) if limit

 scope
end
  end


  

  # Add lifecycle hook methods to model lifecycle
# model type: datamapper

# Define lifecycle hook methods





  def assign_attributes(values, options = {})
    sanitize_for_mass_assignment(values, options[:as]).each do |k, v|
      send("#{k}=", v)
    end
  end

  

  include V2::Custom::Doctor
end