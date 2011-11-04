require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe BillStagesController do

  # This should return the minimal set of attributes required to create a valid
  # BillStage. As you add validations to BillStage, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all bill_stages as @bill_stages" do
      bill_stage = BillStage.create! valid_attributes
      get :index
      assigns(:bill_stages).should eq([bill_stage])
    end
  end

  describe "GET show" do
    it "assigns the requested bill_stage as @bill_stage" do
      bill_stage = BillStage.create! valid_attributes
      get :show, :id => bill_stage.id
      assigns(:bill_stage).should eq(bill_stage)
    end
  end

  describe "GET new" do
    it "assigns a new bill_stage as @bill_stage" do
      get :new
      assigns(:bill_stage).should be_a_new(BillStage)
    end
  end

  describe "GET edit" do
    it "assigns the requested bill_stage as @bill_stage" do
      bill_stage = BillStage.create! valid_attributes
      get :edit, :id => bill_stage.id
      assigns(:bill_stage).should eq(bill_stage)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BillStage" do
        expect {
          post :create, :bill_stage => valid_attributes
        }.to change(BillStage, :count).by(1)
      end

      it "assigns a newly created bill_stage as @bill_stage" do
        post :create, :bill_stage => valid_attributes
        assigns(:bill_stage).should be_a(BillStage)
        assigns(:bill_stage).should be_persisted
      end

      it "redirects to the created bill_stage" do
        post :create, :bill_stage => valid_attributes
        response.should redirect_to(BillStage.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bill_stage as @bill_stage" do
        # Trigger the behavior that occurs when invalid params are submitted
        BillStage.any_instance.stub(:save).and_return(false)
        post :create, :bill_stage => {}
        assigns(:bill_stage).should be_a_new(BillStage)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        BillStage.any_instance.stub(:save).and_return(false)
        post :create, :bill_stage => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested bill_stage" do
        bill_stage = BillStage.create! valid_attributes
        # Assuming there are no other bill_stages in the database, this
        # specifies that the BillStage created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        BillStage.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => bill_stage.id, :bill_stage => {'these' => 'params'}
      end

      it "assigns the requested bill_stage as @bill_stage" do
        bill_stage = BillStage.create! valid_attributes
        put :update, :id => bill_stage.id, :bill_stage => valid_attributes
        assigns(:bill_stage).should eq(bill_stage)
      end

      it "redirects to the bill_stage" do
        bill_stage = BillStage.create! valid_attributes
        put :update, :id => bill_stage.id, :bill_stage => valid_attributes
        response.should redirect_to(bill_stage)
      end
    end

    describe "with invalid params" do
      it "assigns the bill_stage as @bill_stage" do
        bill_stage = BillStage.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BillStage.any_instance.stub(:save).and_return(false)
        put :update, :id => bill_stage.id, :bill_stage => {}
        assigns(:bill_stage).should eq(bill_stage)
      end

      it "re-renders the 'edit' template" do
        bill_stage = BillStage.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BillStage.any_instance.stub(:save).and_return(false)
        put :update, :id => bill_stage.id, :bill_stage => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested bill_stage" do
      bill_stage = BillStage.create! valid_attributes
      expect {
        delete :destroy, :id => bill_stage.id
      }.to change(BillStage, :count).by(-1)
    end

    it "redirects to the bill_stages list" do
      bill_stage = BillStage.create! valid_attributes
      delete :destroy, :id => bill_stage.id
      response.should redirect_to(bill_stages_url)
    end
  end

end