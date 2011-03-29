class SuppliersController < ApplicationController
  # GET /suppliers
  # GET /suppliers.xml
  def index
    @resources=Supplier.all
    @model_s_name="supplier"
    @model_p_name="suppliers"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  # GET /suppliers/1
  # GET /suppliers/1.xml
  def show
    @supplier = Supplier.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @supplier }
    end
  end

  # GET /suppliers/new
  # GET /suppliers/new.xml
  def new
    @supplier = Supplier.new
  end

  # GET /suppliers/1/edit
  def edit
    @supplier = Supplier.find(params[:id])
  end

  # POST /suppliers
  # POST /suppliers.xml
  def create
    @supplier = Supplier.new(params[:supplier])
    if !@supplier.save
      render "new"
    end
    @suppliers=Supplier.all
  end

  # PUT /suppliers/1
  # PUT /suppliers/1.xml
  def update
    @supplier = Supplier.find(params[:id])
    if !@supplier.update_attributes(params[:supplier])
      render "edit"
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.xml
  def destroy
    @supplier = Supplier.find(params[:id])
    @delete_id=@supplier.id
    @supplier.destroy
  end
end
