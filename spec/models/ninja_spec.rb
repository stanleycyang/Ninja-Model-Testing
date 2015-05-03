require 'rails_helper'

RSpec.describe Ninja, type: :model do
  it 'responds to a name' do
    # Does the name exists?
    expect(subject).to respond_to(:name)
  end

  it 'is invalid without a name' do
    # Ninja be created without a name
    expect(subject).to be_invalid
  end

  it 'raises an error without a name' do
    expect{subject.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'responds to a secret name' do
    expect(subject).to respond_to(:secret_name)
  end

  it 'is invalid without a secret name' do
    expect(subject).to be_invalid
  end

  it 'raises an error without a secret name' do
    expect{subject.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  # Describe classs method attack
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

  context 'when a Ninja is initialized with a name of Ashley' do
    subject(:ninja){Ninja.new(name: "Ashley")}

    it "should start with two weapons" do
      expect(subject.weapons).to be_an_instance_of(Array)
      expect(subject.weapons.count).to equal(2)
    end

    it 'changes the number of Ninja' do
      expect{subject.save}.to change{Ninja.count}.by(1)
    end
  end

end
