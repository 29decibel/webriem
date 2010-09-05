class LodgingsController < ApplicationController
  # GET /lodgings
  # GET /lodgings.xml
  def index
    @lodgings = Lodging.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lodgings }
    end
  end

  # GET /lodgings/1
  # GET /lodgings/1.xml
  def show
    @lodging = Lodging.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lodging }
    end
  end

  # GET /lodgings/new
  # GET /lodgings/new.xml
  def new
    @lodging = Lodging.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lodging }
    end
  end

  # GET /lodgings/1/edit
  def edit
    @lodging = Lodging.find(params[:id])
  end

  # POST /lodgings
  # POST /lodgings.xml
  def create
    @lodging = Lodging.new(params[:lodging])

    respond_to do |format|
      if @lodging.save
        format.html { redirect_to(@lodging, :notice => 'Lodging was successfully created.') }
        format.xml  { render :xml => @lodging, :status => :created, :location => @lodging }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lodging.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lodgings/1
  # PUT /lodgings/1.xml
  def update
    @lodging = Lodging.find(params[:id])

    respond_to do |format|
      if @lodging.update_attributes(params[:lodging])
        format.html { redirect_to(@lodging, :notice => 'Lodging was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lodging.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lodgings/1
  # DELETE /lodgings/1.xml
  def destroy
    @lodging = Lodging.find(params[:id])
    @lodging.destroy

    respond_to do |format|
      format.html { redirect_to(lodgings_url) }
      format.xml  { head :ok }
    end
  end
end
