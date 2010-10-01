class FeedBacksController < ApplicationController
  # GET /feed_backs
  # GET /feed_backs.xml
  def index
    @feed_backs = FeedBack.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @feed_backs }
    end
  end

  # GET /feed_backs/1
  # GET /feed_backs/1.xml
  def show
    @feed_back = FeedBack.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feed_back }
    end
  end

  # GET /feed_backs/new
  # GET /feed_backs/new.xml
  def new
    @feed_back = FeedBack.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feed_back }
    end
  end

  # GET /feed_backs/1/edit
  def edit
    @feed_back = FeedBack.find(params[:id])
  end

  # POST /feed_backs
  # POST /feed_backs.xml
  def create
    @feed_back = FeedBack.new(params[:feed_back])

    respond_to do |format|
      if @feed_back.save
        format.html { redirect_to(@feed_back, :notice => 'Feed back was successfully created.') }
        format.xml  { render :xml => @feed_back, :status => :created, :location => @feed_back }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feed_back.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feed_backs/1
  # PUT /feed_backs/1.xml
  def update
    @feed_back = FeedBack.find(params[:id])

    respond_to do |format|
      if @feed_back.update_attributes(params[:feed_back])
        format.html { redirect_to(@feed_back, :notice => 'Feed back was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feed_back.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feed_backs/1
  # DELETE /feed_backs/1.xml
  def destroy
    @feed_back = FeedBack.find(params[:id])
    @feed_back.destroy

    respond_to do |format|
      format.html { redirect_to(feed_backs_url) }
      format.xml  { head :ok }
    end
  end
end
