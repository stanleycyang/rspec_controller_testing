require 'rails_helper'

RSpec.describe YogurtsController, type: :controller do

  describe "GET index" do

    let!(:yogurt1){Yogurt.create!(name: "Stanley's Chocolate Cake", calories: 350)}
    let!(:yogurt2){Yogurt.create!(name: "Rob's Glassy Mix", calories: 380)}

    # add get :index before all tests here
    before(:each){
      get :index
    }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      expect(response).to render_template("index")
    end

    it "assigns all the yogurts to yogurts" do
      expect(assigns(:yogurts)).to include(yogurt1, yogurt2)
    end

  end

  describe "GET show" do
    let!(:yogurt){Yogurt.create!(name: "Jackie Cake", calories: 450)}

    before(:each){
      get :show, id: yogurt.id
    }

    it "is successful" do
      expect(response).to be_success
    end

    it "renders the show view file" do
      expect(response).to render_template(:show)
    end

    it "assigns the requested yogurt to a variable yogurt" do
      expect(assigns(:yogurt)).to eq(yogurt)
    end
  end

  describe "GET new" do

    before(:each){
      get :new
    }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      expect(response).to render_template("new")
    end

    it "assigns a new yogurt to a variable yogurt" do
      expect(assigns(:yogurt)).to be_a(Yogurt)
    end

    it "doesn't save any new records" do
      expect{get :new}.to change(Yogurt, :count).by(0)
    end
  end

  describe "POST create" do
    context "when form is valid" do
      let!(:valid_attributes) do
        {name: "Honey Boo Boo", calories: 20000}
      end

      it "added a yogurt record" do
        expect{post :create, yogurt: valid_attributes}.to change(Yogurt, :count).by(1)
      end

      it "redirects to the index" do
        post :create, yogurt: valid_attributes
        expect(response).to redirect_to yogurts_path
      end
    end

    context "when form is invalid" do
      let!(:invalid_attributes) do
        {name: nil, calories: nil}
      end

      it "does not add a yogurt record" do
        expect{post :create, yogurt: invalid_attributes}.to change(Yogurt, :count).by(0)
      end

      it "renders the new view file" do
        post :create, yogurt: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET edit" do
    let!(:yogurt){Yogurt.create!(name: "Bang bang", calories: 450)}

    before(:each){
      get :edit, id: yogurt.id
    }

    it 'is successful' do
      expect(response).to be_success
    end

    it "renders the edit view file" do
      expect(response).to render_template(:edit)
    end

    it 'assigns the requested yogurt to a variable yogurt' do
      expect(assigns(:yogurt)).to eq(yogurt)
    end
  end

  describe 'PUT update' do
    let!(:yogurt){Yogurt.create!(name: "Sweet Bear", calories: 350)}

    context "update with valid attributes" do
      let!(:valid_attributes) do
        {
          name: "Mandy Moore",
          calories: 450
        }
      end

      it "updates the existing yogurt" do
        put :update, id: yogurt.id, yogurt: valid_attributes
        expect(yogurt.reload.name).to eq(valid_attributes[:name])
      end

      it "redirects to the index" do
        put :update, id: yogurt.id, yogurt: valid_attributes
        expect(response).to redirect_to yogurts_path
      end

    end

    context "update with bad attributes" do
      let(:invalid_attributes) do
        {
          name:nil,
          calories:nil
        }
      end

      it "does not update the existing yogurt" do
        put :update, id: yogurt.id, yogurt: invalid_attributes
        expect(yogurt.reload.name).to eq(yogurt.name)
      end

      it "renders the edit view file" do
        put :update, id: yogurt.id, yogurt: invalid_attributes
        expect(response).to render_template :edit
      end

    end

  end

  describe 'DELETE destroy' do
    let!(:yogurt){Yogurt.create!(name: 'Happy feet', calories: 500)}

    it "should assign the yogurt to a variable yogurt" do
      delete :destroy, id: yogurt.id
      expect(assigns(:yogurt)).to eq(yogurt)
    end

    it "should destroy a yogurt record" do
      expect{delete :destroy, id: yogurt.id}.to change(Yogurt, :count).by(-1)
    end
  end

end
