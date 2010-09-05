class FeeStandardsController < ApplicationController
  # GET /fee_standards
  # GET /fee_standards.xml
  def index
    @fee_standards = FeeStandard.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fee_standards }
    end
  end

  # GET /fee_standards/1
  # GET /fee_standards/1.xml
  def show
    @fee_standard = FeeStandard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fee_standard }
    end
  end

  # GET /fee_standards/new
  # GET /fee_standards/new.xml
  def new
    @fee_standard = FeeStandard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fee_standard }
    end
  end

  # GET /fee_standards/1/edit
  def edit
    @fee_standard = FeeStandard.find(params[:id])
  end

  # POST /fee_standards
  # POST /fee_standards.xml
  def create
    @fee_standard = FeeStandard.new(params[:fee_standard])

    respond_to do |format|
      if @fee_standard.save
        format.html { redirect_to(@fee_standard, :notice => 'Fee standard was successfully created.') }
        format.xml  { render :xml => @fee_standard, :status => :created, :location => @fee_standard }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fee_standard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /fee_standards/1
  # PUT /fee_standards/1.xml
  def update
    @fee_standard = FeeStandard.find(params[:id])

    respond_to do |format|
      if @fee_standard.update_attributes(params[:fee_standard])
        format.html { redirect_to(@fee_standard, :notice => 'Fee standard was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fee_standard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /fee_standards/1
  # DELETE /fee_standards/1.xml
  def destroy
    @fee_standard = FeeStandard.find(params[:id])
    @fee_standard.destroy

    respond_to do |format|
      format.html { redirect_to(fee_standards_url) }
      format.xml  { head :ok }
    end
  end
end
