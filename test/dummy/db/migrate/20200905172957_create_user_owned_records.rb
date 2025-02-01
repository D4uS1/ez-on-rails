# frozen_string_literal: true

# Migration class for creating the database table for a  model.
class CreateUserOwnedRecords < ActiveRecord::Migration[6.0]

  # Applies the changes to the database.
  def change
    create_table :user_owned_records do |t|
      t.string :test

      t.belongs_to :owner, index: true, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end