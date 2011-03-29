class MenuCategoriesController < ApplicationController
  # GET /menu_categories
  # GET /menu_categories.xml
  def index
    @resources=MenuCategory.all
    @model_s_name="menu_category"
    @model_p_name="menu_categories"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  # GET /menu_categories/1
  # GET /menu_categories/1.xml
  def show
    @menu_category = MenuCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @menu_category }
    end
  end

  # GET /menu_categories/new
  # GET /menu_categories/new.xml
  def new
    @menu_category = MenuCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @menu_category }
    end
  end

  # GET /menu_categories/1/edit
  def edit
    @menu_category = MenuCategory.find(params[:id])
  end

  # POST /menu_categories
  # POST /menu_categories.xml
  def create
    @menu_category = MenuCategory.new(params[:menu_category])

    respond_to do |format|
      if @menu_category.save
        format.html { redirect_to(@menu_category, :notice => 'Menu category was successfully created.') }
        format.xml  { render :xml => @menu_category, :status => :created, :location => @menu_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @menu_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /menu_categories/1
  # PUT /menu_categories/1.xml
  def update
    @menu_category = MenuCategory.find(params[:id])

    respond_to do |format|
      if @menu_category.update_attributes(params[:menu_category])
        format.html { redirect_to(@menu_category, :notice => 'Menu category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @menu_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /menu_categories/1
  # DELETE /menu_categories/1.xml
  def destroy
    @menu_category = MenuCategory.find(params[:id])
    @menu_category.destroy

    respond_to do |format|
      format.html { redirect_to(menu_categories_url) }
      format.xml  { head :ok }
    end
  end
end
