class Api::V2::DoctorsController < ApplicationController
  resource_description do
    name 'V2::Doctors'
    short 'V2::Doctors'
    path '/v1/doctors.json'
    version '2'
    formats ['json']
    param :id, Integer, :desc => "V2::Doctor ID", :required => false
    param :doctor, Hash, :desc => "V2::Doctor's parameters for all methods" do
    
      param :id, Integer, :required => false,
            :desc => "Id"
    
      param :business_phone, String, :required => false,
            :desc => "Business Phone"
    
      param :department, String, :required => false,
            :desc => "Department"
    
      param :diseases, String, :required => false,
            :desc => "Diseases"
    
      param :division, String, :required => false,
            :desc => "Division"
    
      param :email, String, :required => false,
            :desc => "Email"
    
      param :gender, String, :required => false,
            :desc => "Gender"
    
      param :high_level, String, :required => false,
            :desc => "High Level"
    
      param :languages, String, :required => false,
            :desc => "Languages"
    
      param :name, String, :required => false,
            :desc => "Name"
    
      param :photo, String, :required => false,
            :desc => "Photo"
    
      param :program, String, :required => false,
            :desc => "Program"
    
      param :specialty, String, :required => false,
            :desc => "Specialty"
    
      param :trackback_url, String, :required => false,
            :desc => "Trackback Url"
    
    end
    description <<-DOC
      V2::Doctors.
    DOC
  end
  respond_to :json
  
  protect_from_forgery :except => [:create, :update, :destroy]
  
  # GET /doctors.json
  api :GET, "/v2/doctors.json", "Show all doctors based on a query scope"
  def index
    scope = params[:scope] || 'all'
    reject_as_unauthorized and return unless authorized_for_scope?(scope)
    @doctors = scope_named(scope)
    respond_with @doctors
  end

  # GET /doctors/1.json
  api :GET, "/v2/doctors/:id.json", "Show doctor"
  def show
    reject_as_unauthorized and return unless can_read?
    
    @doctor = scope_for_read_finder.get(params[:id])
    
    respond_with @doctor
  end

  # GET /doctors/new.json
  api :GET, "/v2/doctors/new.json", "Instantiate a new doctor"
  def new
    @doctor = V2::Doctor.new
    respond_with @doctor
  end

  # POST /doctors.json
  api :POST, "/v2/doctors.json", "Create a new doctor"
  def create
    reject_as_unauthorized and return unless can_create?
    @doctor = scope_for_create_finder.new(params[:doctor], as: :"#{current_user_role} on create")
    @doctor.save
    respond_with @doctor
  end

  # PUT /doctors/1.json
  api :PUT, "/v2/doctors/:id.json", "Update an existing doctor"
  def update
    reject_as_unauthorized and return unless can_update?
    
    @doctor = scope_for_update_finder.get(params[:id])
    
    @doctor.update_attributes(params[:doctor], as: :"#{current_user_role} on update")
    respond_with @doctor
  end

  # DELETE /doctors/1.json
  api :DELETE, "/v2/doctors/:id.json", "Delete an existing doctor"
  def destroy
    reject_as_unauthorized and return unless can_delete?
    
    @doctor = scope_for_delete_finder.get(params[:id])
    
    @doctor.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
  
protected
  def scope_named(name)
    scope = 'all' unless ::V2::Doctor.respond_to?(name)
    if name == 'all'
      
      scope = ::V2::Doctor.all
      scope = scope.all(offset: params[:offset].to_i) if params[:offset]
      scope = scope.all(limit: params[:limit].to_i) if params[:limit]
      
    elsif name == 'count'
      scope = ::V2::Doctor.count
    else
      scope = ::V2::Doctor.send(name, (params[:query] || {}), {}, params[:offset], params[:limit])
    end
    scope
  end

  # Overriding respond_with to perform field level authorization for reading fields.
  def respond_with(*resources, &block)
    replacement = nil
    resources.each do |resource|
      if resource.respond_to?(:each)
        replacement = []
        resource.each do |instance| 
          replacement << scrubbed_instance(instance)
        end
      elsif resource.respond_to?(:attributes)
        replacement = scrubbed_instance(resource)
      else
        replacement = resource
      end
    end

    super(replacement, :location => nil)
  end

  def scrubbed_instance(instance)
    instance.attributes.select{|attribute| ['id', 'business_phone', 'department', 'diseases', 'division', 'email', 'gender', 'high_level', 'languages', 'name', 'photo', 'program', 'specialty', 'trackback_url'].include?(attribute) }.each do |attribute, value|
      instance.send("#{attribute}=", nil) unless authorized_to_read_field?(attribute)
    end
    instance
  end

  
    def can_read?
      
        true
      
    end

    def scope_for_read_finder
      
        ::V2::Doctor
      
    end
  
    def can_create?
      
        true
      
    end

    def scope_for_create_finder
      
        ::V2::Doctor
      
    end
  
    def can_update?
      
        true
      
    end

    def scope_for_update_finder
      
        ::V2::Doctor
      
    end
  
    def can_delete?
      
        true
      
    end

    def scope_for_delete_finder
      
        ::V2::Doctor
      
    end
  

  def authorized_for_scope?(scope_name)
    
      true
    
  end

  def authorized_to_read_field?(field_name)
    
      true
    
  end

  include Api::V2::Custom::DoctorsController
end
