class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|

      t.string :content
      t.string :sender_name
      t.string :receiver_name
      t.timestamps
    end

    add_index :messages, :sender_name
    add_index :messages, :receiver_name
  end
end
