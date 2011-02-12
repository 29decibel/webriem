class FeeCodeMatchesController < ApplicationController
  # GET /fee_code_matches
  # GET /fee_code_matches.xml
  def index
    @fee_code_matches = FeeCodeMatch.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fee_code_matches }
    end
  end

  # GET /fee_code_matches/1
  # GET /fee_code_matches/1.xml
  def show
    @fee_code_match = FeeCodeMatch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fee_code_match }
    end
  end

  # GET /fee_code_matches/new
  # GET /fee_code_matches/new.xml
  def new
    @fee_code_match = FeeCodeMatch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fee_code_match }
    end
  end

  # GET /fee_code_matches/1/edit
  def edit
    @fee_code_match = FeeCodeMatch.find(params[:id])
  end

  # POST /fee_code_matches
  # POST /fee_code_matches.xml
  def create
    @fee_code_match = FeeCodeMatch.new(params[:fee_code_match])

    respond_to do |format|
      if @fee_code_match.save
        format.html { redirect_to(@fee_code_match, :notice => 'Fee code match was successfully created.') }
        format.xml  { render :xml => @fee_code_match, :status => :created, :location => @fee_code_match }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fee_code_match.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /fee_code_matches/1
  # PUT /fee_code_matches/1.xml
  def update
    @fee_code_match = FeeCodeMatch.find(params[:id])

    respond_to do |format|
      if @fee_code_match.update_attributes(params[:fee_code_match])
        format.html { redirect_to(@fee_code_match, :notice => 'Fee code match was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fee_code_match.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /fee_code_matches/1
  # DELETE /fee_code_matches/1.xml
  def destroy
    @fee_code_match = FeeCodeMatch.find(params[:id])
    @fee_code_match.destroy

    respond_to do |format|
      format.html { redirect_to(fee_code_matches_url) }
      format.xml  { head :ok }
    end
  end
end
