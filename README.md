#RSPEC: Model

What is RSPEC?

	RSpec is a behavior-driven development (BDD) framework for the Ruby programming language, inspired by JBehave. It just describes the behavior of your application!


This framework is considered a domain-specific language (DSL). DSL is a computer language specialized to a particular domain, in RSPEC's case: **Testing for the Ruby Programming language**

RSpec has well-formatted output to see what went wrong with your code

Start by install rspec gem

	gem install rspec

To start rspec in your directory, do

	rspec --init

- Rspec is Behaviour-Driven Development gem for Ruby programmers: [Official Docs for RSpec](https://relishapp.com/rspec)


##Demo

Create a postgresql app

	$ rails new ninja_model_test -Td postgresql

**Flags:**

	-T	=> no test framework
	-d postgresql => add postgres as our DB

Now create the database

	$ rake db:create

*Side note: If you need to drop a database in postgres, you can use*

	$ dropdb 'your_app_db'
	
Modify your Gemfile to include Rspec

	group :development, :test do
	  gem 'rspec-rails'
	end

Bundle the gem

	$ bundle install

We can now set up rspec ready to go

	$ rails g rspec:install
		  create  .rspec
	      create  spec
	      create  spec/spec_helper.rb
	      create  spec/rails_helper.rb

Now your spec directory is set up with spec_helper and rails_helper!


Create a ninja model

	$ rails g model Ninja name:string secret_name:string
	
Then to create the schema

	$ rake db:migrate

You should get something like:

	$ ninja_model_test  rake db:migrate
	== 20150119022551 CreateNinjas: migrating =====================================
	-- create_table(:ninjas)
	   -> 0.0241s
	== 20150119022551 CreateNinjas: migrated (0.0243s) ============================

Let's get started with RSpec

	In RSpec, you have specifications and examples. Your specifications are stated in the spec folder and the examples are the tests you run

Let's write some examples in (ninja_spec.rb)

	require 'rails_helper'

	RSpec.describe Ninja, :type => :model do
	  
	  it "responds to a name" do
	  
	    # Does the name exist?
	    
	    expect(subject).to respond_to(:name)
	  end
	
	  it "is invalid without a name" do
	  
	    # Can ninja be created without a name?
	    
	    expect(subject).to be_invalid
	  end
	
	  it "raises an error without a name" do
	  
	    # Will it raise an error without a name?
	    
	    expect{subject.save!}.to raise_error(ActiveRecord::RecordInvalid)
	  end
	
	end

Note: 'subject' refers to Ninja.new in this context. We will go into it further in a bit


Then run: 

	$ rspec spec/models/ninja_spec.rb

You should get 2 errors. To resolve them, write in your ninja.rb

	class Ninja < ActiveRecord::Base
	  validates :name, presence: true
	end

Then run: 

	$ rspec spec/models/ninja_spec.rb

Your tests should now pass!

###Activity 1:
	
	 Write tests for secret_name to make sure it 1) exists, 2) a Ninja is invalid without a secret name, and 3) raises an error without a secret name
<br />

Now, lets describe some examples for class and instance methods

	# Describe class method attack
	  describe ".attack" do 
	    it 'responds to attack' do
	      expect(Ninja).to respond_to(:attack)
	    end
	  end
	
	  # Describe instance method hide
	  describe '#hide' do
	    it 'responds to hide' do
	      expect(subject).to respond_to(:hide)
	    end
	  end

Run rspec. You should get something like:

	Failed examples:

	rspec ./spec/models/ninja_spec.rb:22 # Ninja.attack responds to attack
	rspec ./spec/models/ninja_spec.rb:29 # Ninja#hide responds to hide
	
To resolve it, go into ninja.rb and

	# Create class method of attack
	  def self.attack
	    puts "Ninja strikes!"
	  end
	
	  # Create instance method of hide
	  def hide
	    puts "I am hiding"
	  end

Run rspec and your tests should all pass now!

###Activity 2:
	
	 Write tests for an instance method hide and make sure it exists



Let's add a column weapons to ninja by running a migration 
	
	rails g migration  add_column_weapons_to_ninja weapons
	
Go inside your add_column_weapons_to_ninja.rb and change it to

	class AddColumnWeaponsToNinja < ActiveRecord::Migration
	  def change
	    add_column :ninjas, :weapons, :string, :default=> ['Knife', 'Sword']
	  end
	end

Then rake your db

	rake db:migrate

Let's test and see if the ninja has the default number of weapons at two. In your ninja_spec.rb:

	context 'when a Ninja is initialized with a name of Ashley' do
	
	    subject(:ninja){Ninja.new(name: "Ashley")}
	
	    # Ninjas should start with 2 weapons
	    it 'should start with two weapons' do
	
	      expect(subject.weapons).to be_an_instance_of(Array)
	      expect(subject.weapons.count).to equal(2)
	    end
	
	  end

**Using context organizes your code and allow you to change your subject**

Run your rspec

You should have 1 error: 

	Failed examples:

	rspec ./spec/models/ninja_spec.rb:39 # Ninja when a Ninja is initialized with a new of Ashley should start with two weapons

To fix it, go into ninja.rb and add

	serialize :weapons, Array
	
Now your tests should pass!

Lastly, let's make sure your Ninjas are being initialized correctly inside the context:

	# Check if the Ninjas are correctly being initialized
	
	    it 'changes the number of Ninja' do
	      expect{subject.save}.to change{Ninja.count}.by(1)
	    end

Run your rspec. This should pass!


Congratulations! You have just successfully tested your model using rspec! Your ninja is now rocking.


When calling rspec, you can use 

	rspec --color #colors
	rspec --color --format documentation #verbose 
	
