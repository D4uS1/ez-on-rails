# frozen_string_literal: true

# Migration class for creating the database table for a  model.
class CreateNestedFormTests < ActiveRecord::Migration[6.1]

  # Applies the changes to the database.
  def change
    create_table :nested_form_tests do |t|
      t.string :test_string
      t.integer :test_int
      t.boolean :test_bool
      t.belongs_to :parent_form_test, null: true, foreign_key: true
      t.belongs_to :owner, index: true, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

  end
end