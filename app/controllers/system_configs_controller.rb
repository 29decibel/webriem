class SystemConfigsController < ApplicationController
  # GET /system_configs
  # GET /system_configs.xml
  def index
    @resources=SystemConfig.all
    @model_s_name="system_config"
    @model_p_name="system_configs"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  # GET /system_configs/1
  # GET /system_configs/1.xml
  def show
    @system_config = SystemConfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @system_config }
    end
  end

  # GET /system_configs/new
  # GET /system_configs/new.xml
  def new
    @system_config = SystemConfig.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @system_config }
    end
  end

  # GET /system_configs/1/edit
  def edit
    @system_config = SystemConfig.find(params[:id])
  end

  # POST /system_configs
  # POST /system_configs.xml
  def create
    @system_config = SystemConfig.new(params[:system_config])

    respond_to do |format|
      if @system_config.save
        format.html { redirect_to(@system_config, :notice => 'System config was successfully created.') }
        format.xml  { render :xml => @system_config, :status => :created, :location => @system_config }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @system_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /system_configs/1
  # PUT /system_configs/1.xml
  def update
    @system_config = SystemConfig.find(params[:id])

    respond_to do |format|
      if @system_config.update_attributes(params[:system_config])
        format.html { redirect_to(@system_config, :notice => 'System config was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @system_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /system_configs/1
  # DELETE /system_configs/1.xml
  def destroy
    @system_config = SystemConfig.find(params[:id])
    @system_config.destroy

    respond_to do |format|
      format.html { redirect_to(system_configs_url) }
      format.xml  { head :ok }
    end
  end
end
