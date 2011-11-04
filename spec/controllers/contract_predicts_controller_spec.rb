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

describe ContractPredictsController do

  # This should return the minimal set of attributes required to create a valid
  # ContractPredict. As you add validations to ContractPredict, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all contract_predicts as @contract_predicts" do
      contract_predict = ContractPredict.create! valid_attributes
      get :index
      assigns(:contract_predicts).should eq([contract_predict])
    end
  end

  describe "GET show" do
    it "assigns the requested contract_predict as @contract_predict" do
      contract_predict = ContractPredict.create! valid_attributes
      get :show, :id => contract_predict.id
      assigns(:contract_predict).should eq(contract_predict)
    end
  end

  describe "GET new" do
    it "assigns a new contract_predict as @contract_predict" do
      get :new
      assigns(:contract_predict).should be_a_new(ContractPredict)
    end
  end

  describe "GET edit" do
    it "assigns the requested contract_predict as @contract_predict" do
      contract_predict = ContractPredict.create! valid_attributes
      get :edit, :id => contract_predict.id
      assigns(:contract_predict).should eq(contract_predict)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ContractPredict" do
        expect {
          post :create, :contract_predict => valid_attributes
        }.to change(ContractPredict, :count).by(1)
      end

      it "assigns a newly created contract_predict as @contract_predict" do
        post :create, :contract_predict => valid_attributes
        assigns(:contract_predict).should be_a(ContractPredict)
        assigns(:contract_predict).should be_persisted
      end

      it "redirects to the created contract_predict" do
        post :create, :contract_predict => valid_attributes
        response.should redirect_to(ContractPredict.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved contract_predict as @contract_predict" do
        # Trigger the behavior that occurs when invalid params are submitted
        ContractPredict.any_instance.stub(:save).and_return(false)
        post :create, :contract_predict => {}
        assigns(:contract_predict).should be_a_new(ContractPredict)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ContractPredict.any_instance.stub(:save).and_return(false)
        post :create, :contract_predict => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested contract_predict" do
        contract_predict = ContractPredict.create! valid_attributes
        # Assuming there are no other contract_predicts in the database, this
        # specifies that the ContractPredict created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ContractPredict.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => contract_predict.id, :contract_predict => {'these' => 'params'}
      end

      it "assigns the requested contract_predict as @contract_predict" do
        contract_predict = ContractPredict.create! valid_attributes
        put :update, :id => contract_predict.id, :contract_predict => valid_attributes
        assigns(:contract_predict).should eq(contract_predict)
      end

      it "redirects to the contract_predict" do
        contract_predict = ContractPredict.create! valid_attributes
        put :update, :id => contract_predict.id, :contract_predict => valid_attributes
        response.should redirect_to(contract_predict)
      end
    end

    describe "with invalid params" do
      it "assigns the contract_predict as @contract_predict" do
        contract_predict = ContractPredict.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ContractPredict.any_instance.stub(:save).and_return(false)
        put :update, :id => contract_predict.id, :contract_predict => {}
        assigns(:contract_predict).should eq(contract_predict)
      end

      it "re-renders the 'edit' template" do
        contract_predict = ContractPredict.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ContractPredict.any_instance.stub(:save).and_return(false)
        put :update, :id => contract_predict.id, :contract_predict => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested contract_predict" do
      contract_predict = ContractPredict.create! valid_attributes
      expect {
        delete :destroy, :id => contract_predict.id
      }.to change(ContractPredict, :count).by(-1)
    end

    it "redirects to the contract_predicts list" do
      contract_predict = ContractPredict.create! valid_attributes
      delete :destroy, :id => contract_predict.id
      response.should redirect_to(contract_predicts_url)
    end
  end

end