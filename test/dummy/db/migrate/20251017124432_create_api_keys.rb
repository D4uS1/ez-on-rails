class CreateApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :eor_api_keys do |t|
      t.string :api_key, null: false
      t.datetime :expires_at

      t.belongs_to :owner, index: true, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :eor_api_keys,
              [:api_key],
              unique: true,
              name: 'eor_api_keys_index'
  end
end
