# frozen_string_literal: true

# Migration class for creating the database table for a  model.
class CreateAssocTests < ActiveRecord::Migration[6.1]

  # Applies the changes to the database.
  def change
    create_table :assoc_tests do |t|
      t.belongs_to :bearer_token_access_test, null: false, foreign_key: true
      t.belongs_to :parent_form_test, null: false, foreign_key: true
      t.belongs_to :owner, index: true, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

  end
end