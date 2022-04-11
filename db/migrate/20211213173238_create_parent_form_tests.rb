# frozen_string_literal: true

# Migration class for creating the database table for a  model.
class CreateParentFormTests < ActiveRecord::Migration[6.1]

  # Applies the changes to the database.
  def change
    create_table :parent_form_tests do |t|
      t.string :test
      t.boolean :test_bool
      t.belongs_to :owner, index: true, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

  end
end