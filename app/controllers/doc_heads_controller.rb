class DocHeadsController < ApplicationController
  # GET /doc_heads
  # GET /doc_heads.xml
  def index
    @doc_heads = DocHead.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @doc_heads }
    end
  end

  # GET /doc_heads/1
  # GET /doc_heads/1.xml
  def show
    @doc_head = DocHead.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @doc_head }
    end
  end

  # GET /doc_heads/new
  # GET /doc_heads/new.xml
  def new
    @doc_head = DocHead.new
    3.times { @doc_head.recivers.build }
    3.times { @doc_head.cp_doc_details.build }
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @doc_head }
    end
  end

  # GET /doc_heads/1/edit
  def edit
    @doc_head = DocHead.find(params[:id])
  end

  # POST /doc_heads
  # POST /doc_heads.xml
  def create
    @doc_head = DocHead.new(params[:doc_head])

    respond_to do |format|
      if @doc_head.save
        format.html { redirect_to(@doc_head, :notice => 'Doc head was successfully created.') }
        format.xml  { render :xml => @doc_head, :status => :created, :location => @doc_head }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @doc_head.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /doc_heads/1
  # PUT /doc_heads/1.xml
  def update
    @doc_head = DocHead.find(params[:id])

    respond_to do |format|
      if @doc_head.update_attributes(params[:doc_head])
        format.html { redirect_to(@doc_head, :notice => 'Doc head was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @doc_head.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_heads/1
  # DELETE /doc_heads/1.xml
  def destroy
    @doc_head = DocHead.find(params[:id])
    @doc_head.destroy

    respond_to do |format|
      format.html { redirect_to(doc_heads_url) }
      format.xml  { head :ok }
    end
  end
end
