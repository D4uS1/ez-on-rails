# frozen_string_literal: true

# Migration class for creating the table for the UserGroupAssignments model.
class CreateUserGroupAssignments < ActiveRecord::Migration[5.2]
  # Applies the changes to the database.
  def change
    create_table :eor_user_group_assignments do |t|
      t.belongs_to :user, index: true, null: false, foreign_key: true
      t.belongs_to :group, index: true, null: false, foreign_key: { to_table: :eor_groups }
      t.belongs_to :resource, index: true, null: true, polymorphic: true

      t.belongs_to :owner, index: true, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :eor_user_group_assignments,
              %i[user_id group_id],
              unique: true,
              name: 'eor_user_group_assignments_index'
  end
end
