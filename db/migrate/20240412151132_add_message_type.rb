class AddMessageType < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :sent, :boolean, default: true, null: false
  end
end
