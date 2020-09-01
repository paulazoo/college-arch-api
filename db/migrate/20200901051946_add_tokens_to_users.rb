class AddTokensToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column(:accounts, :refresh_token_id, :string)
  end
end
