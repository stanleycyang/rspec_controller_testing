#Yogurt Controller Specs

###Objectives

- Understand how to create RSpec Controller Tests
- Initialize RSpec for controller
- Utilize RSpec Methods

Methods to learn

	render_template(:view_filename)
	be_success
	include([array, of, things])
	eq()
	be_a(Class)
	be_persisted
	redirect_to(path or path_helper)
	change(Class, :count).by(num)
	
###Setup

Initialize our Yogurt app

	$ rails new yogurt_app -T

Put in the rspec-rails gem

	gem 'rspec-rails'

Bundle

	bundle install

Initialize rspec

	$ rails g rspec:install

Create a controller

	$ rails g controller yogurts

Create a model
	
	$ rails g model yogurt name calories:integer

`For now, let's delete the spec/helpers for now`

###Writing our first controller test for index

Let's write a test to check the http status when we go to a page

	require 'rails_helper'
	
	RSpec.describe YogurtsController, type: :controller do
	
	  describe "GET #index" do
	    it "returns http success" do
	      get :index
	      expect(response).to have_http_status(:success)
	    end
	  end
	  
	  it "renders the index template" do
	      get :index
	      expect(response).to render_template("index")
	    end
	
	end	

Let's go to `routes.rb` and add `resources :yogurts`

Then, add in the views/yogurts/ and add `index.html.erb`

Finally, add the method into our `yogurts_controller.rb`

	def index
		@yogurts = Yogurt.all
	end

In your terminal, run

	$ rspec spec/controllers/yogurts_controller_spec.rb

Your test should pass now

##NOW...

	It sucks to write get :index every time. So lets do this:
	
	before(:each){
      get :index
    }

Now our code looks cleaner

	  describe "GET index" do
	
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
	  end

###Before we finish index...

Let's test and see if our action works. Add these lines to the index tests

	let!(:yogurt1){Yogurt.create!(name: "Stanley's Chocolate Cake", calories: 350)}
    let!(:yogurt2){Yogurt.create!(name: "Rob's Glassy Mix", calories: 380)}
    
    ...
    
    it "assigns all the yogurts to yogurts" do
      expect(assigns(:yogurts)).to include(yogurt1, yogurt2)
    end

Now we thoroughly tested your controller action!

###Activity

	Write the http status check for the new action 

###Writing new together

Let's write a test to check the http status of `new`

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
	  end
	 
	

Then, add in the views/yogurts/ and add `new.html.erb`

Finally, add the method into our `yogurts_controller.rb`

	def new
		@yogurt = Yogurt.new
	end


Then, we want to check if there is a Yogurt instance variable with `Yogurt.new`

	it "assigns a new yogurt to a variable yogurt" do
      expect(assigns(:yogurt)).to be_a(Yogurt)
    end

To check if the new page doesn't create any new records, run this test

    it "doesn't save any new records" do
      expect{get :new}.to change(Yogurt, :count).by(0)
    end

In your terminal, run

	$ rspec spec/controllers/yogurts_controller_spec.rb

Your tests should all pass now!

###Creating show page tests

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

Now, pass them by creating a `show.html.erb` in `views/yogurts`. Then in yogurts_controller.rb add

	def show
	    @yogurt = Yogurt.find(params[:id])
	end

In your terminal, run

	$ rspec spec/controllers/yogurts_controller_spec.rb

Your tests should all pass now!

###Activity

	Now knowing what we know with `show`, spend 5 minutes and try and create tests and pass edit!
	
#Writing edit together

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

To pass it, create `edit.html.erb` inside the views/yogurts folder and add in the `yogurts_controller.rb`

	 def edit
	    @yogurt = Yogurt.find(params[:id])
	  end

In your terminal, run

	$ rspec spec/controllers/yogurts_controller_spec.rb

Your tests should all pass now!	  

###Testing POST action

Add these tests

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
	      let!(:bad_attributes) do
	        {name: nil, calories: nil}
	      end
	
	      it "does not add a yogurt record" do
	        expect{post :create, yogurt: bad_attributes}.to change(Yogurt, :count).by(0)
	      end
	
	      it "renders the new view file" do
		      post :create, yogurt: bad_attributes
	        expect(response).to render_template(:new)
	      end
	    end
	  end

###Now, try and pass it

Create your `create` action

	def create
	    @yogurt = Yogurt.new(params.require(:yogurt).permit(:name, :calories))
	
	    if @yogurt.save
	      redirect_to yogurts_path
	    else
	      render :new
	    end
	  end

You now have to validate your model

	class Yogurt < ActiveRecord::Base
	  validates_presence_of :name, :calories
	  validates_numericality_of :calories
	end