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

  # GET /suppliers/1/edit
  def edit
    @supplier = Supplier.find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@supplier}}
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
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @supplier}
      format.js { render "basic_setting/new",:locals=>{:resource=>@supplier }}
    end
  end


  # POST /suppliers
  # POST /suppliers.xml
  def create
    @supplier = Supplier.new(params[:supplier])
    if !@supplier.save
      render "basic_setting/new",:locals=>{:resource=>@supplier}
    else
      redirect_to index
    end
  end

  # PUT /suppliers/1
  # PUT /suppliers/1.xml
  def update
    @supplier = Supplier.find(params[:id])
    if !@supplier.update_attributes(params[:supplier])
      render "basic_setting/edit",:locals=>{:resource=>@supplier}
    else
      render "basic_setting/update",:locals=>{:resource=>@supplier}
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.xml
  def destroy
    @supplier = Supplier.find(params[:id])
    respond_to do |format|
      format.html { redirect_to(suppliers_url) }
      format.xml  { head :ok }
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@supplier} }
    end
  end
end
