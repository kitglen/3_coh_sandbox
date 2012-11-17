class Admin::DoctorsController < ApplicationController
  before_filter :authenticate_admin!
  layout 'admin'

  # GET /doctors
  # GET /doctors.json
  def index
    @doctors = V4::Doctor.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @doctors }
    end
  end

  # GET /doctors/1
  # GET /doctors/1.json
  def show
    
    @doctor = V4::Doctor.get(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @doctor }
    end
  end

  # GET /doctors/new
  # GET /doctors/new.json
  def new
    @doctor = V4::Doctor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @doctor }
    end
  end

  # GET /doctors/1/edit
  def edit
    
    @doctor = V4::Doctor.get(params[:id])
    
  end

  # POST /doctors
  # POST /doctors.json
  def create
    @doctor = V4::Doctor.new(params[:doctor], as: :"System Admin")
    respond_to do |format|
      if @doctor.save
        format.html { redirect_to admin_doctor_url(@doctor), notice: 'doctor was successfully created.' }
        format.json { render json: @doctor, status: :created, location: admin_doctor_url(@doctor) }
      else
        format.html { render action: "new" }
        format.json { render json: @doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /doctors/1
  # PUT /doctors/1.json
  def update
    
    @doctor = V4::Doctor.get(params[:id])
    
    @doctor.update_attributes(params[:doctor], as: :"System Admin")
    respond_to do |format|
      if @doctor.save
        format.html { redirect_to admin_doctor_url(@doctor), notice: 'doctor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doctors/1
  # DELETE /doctors/1.json
  def destroy
    
    @doctor = V4::Doctor.get(params[:id])
    
    @doctor.destroy

    respond_to do |format|
      format.html { redirect_to admin_doctors_url }
      format.json { head :no_content }
    end
  end
end