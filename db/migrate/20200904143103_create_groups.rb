# frozen_string_literal: true

# Migration class for creating the table for the Groups model.
class CreateGroups < ActiveRecord::Migration[5.2]
  # Applies the changes to the database.
  def change
    create_table :eor_groups do |t|
      t.string :name
      t.belongs_to :user, index: true, null: true, foreign_key: true

      t.belongs_to :owner, index: true, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :eor_groups,
              [:name],
              unique: true,
              name: 'eor_groups_index'
  end
end
