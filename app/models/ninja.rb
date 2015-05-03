class Ninja < ActiveRecord::Base
  validates :name, presence: true
  serialize :weapons, Array

  def self.attack
    puts "Ninja strikes!"
  end

  def hide
    puts "I am hiding"
  end
end
