class AddColumnWeaponsToNinja < ActiveRecord::Migration
  def change
    add_column :ninjas, :weapons, :string, :default=> ['Knife', 'Sword']
  end
end
