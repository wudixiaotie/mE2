class AddTokensToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sign_in_token, :string
    add_index :users, :sign_in_token

    add_column :users, :verify_email_token, :string
    add_index :users, :verify_email_token

    add_column :users, :password_reset_token, :string
    add_index :users, :password_reset_token

    add_column :users, :password_reset_sent_at, :datetime
  end
end
