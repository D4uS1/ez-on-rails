# frozen_string_literal: true

# Migration class for creating the database table for a  model.
class CreatePropertiesTests < ActiveRecord::Migration[6.1]

  # Applies the changes to the database.
  def change
    create_table :properties_tests do |t|
      t.string :string_value
      t.integer :integer_value
      t.float :float_value
      t.date :date_value
      t.datetime :datetime_value
      t.boolean :boolean_value
      t.integer :enum_value
      t.belongs_to :assoc_test, null: false, foreign_key: true
      t.belongs_to :owner, index: true, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

  end
end