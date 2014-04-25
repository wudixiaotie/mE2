class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|

      t.string :content
      t.string :sender_id
      t.string :receiver_id
      t.timestamps
    end

    add_index :messages, :sender_id
    add_index :messages, :receiver_id
  end
end
