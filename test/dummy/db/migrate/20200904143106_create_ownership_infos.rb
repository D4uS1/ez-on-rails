# frozen_string_literal: true

# Migration class for creating the table for the OwnedResources model.
class CreateOwnershipInfos < ActiveRecord::Migration[5.2]
  # Performs the changing actions on the database.
  def change
    create_table :eor_ownership_infos do |t|
      t.string :resource
      t.boolean :ownerships, default: false
      t.boolean :sharable, default: false
      t.integer :on_owner_destroy, :integer, default: 0
      t.boolean :resource_groups, default: false

      t.belongs_to :owner, index: true, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :eor_ownership_infos,
              [:resource],
              unique: true,
              name: 'eor_ownership_infos_index'
  end
end
