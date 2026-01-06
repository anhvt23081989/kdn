# frozen_string_literal: true

class AddDeviseToAdminUsers < ActiveRecord::Migration[8.1]
  def self.up
    ## Database authenticatable
    add_column :admin_users, :email, :string, null: false, default: "" unless column_exists?(:admin_users, :email)
    add_column :admin_users, :encrypted_password, :string, null: false, default: "" unless column_exists?(:admin_users, :encrypted_password)

    ## Recoverable
    add_column :admin_users, :reset_password_token, :string unless column_exists?(:admin_users, :reset_password_token)
    add_column :admin_users, :reset_password_sent_at, :datetime unless column_exists?(:admin_users, :reset_password_sent_at)

    ## Rememberable
    add_column :admin_users, :remember_created_at, :datetime unless column_exists?(:admin_users, :remember_created_at)

    ## Trackable
    # add_column :admin_users, :sign_in_count, :integer, default: 0, null: false
    # add_column :admin_users, :current_sign_in_at, :datetime
    # add_column :admin_users, :last_sign_in_at, :datetime
    # add_column :admin_users, :current_sign_in_ip, :string
    # add_column :admin_users, :last_sign_in_ip, :string

    ## Confirmable
    # add_column :admin_users, :confirmation_token, :string
    # add_column :admin_users, :confirmed_at, :datetime
    # add_column :admin_users, :confirmation_sent_at, :datetime
    # add_column :admin_users, :unconfirmed_email, :string # Only if using reconfirmable

    ## Lockable
    # add_column :admin_users, :failed_attempts, :integer, default: 0, null: false # Only if lock strategy is :failed_attempts
    # add_column :admin_users, :unlock_token, :string # Only if unlock strategy is :email or :both
    # add_column :admin_users, :locked_at, :datetime

    add_index :admin_users, :email,                unique: true unless index_exists?(:admin_users, :email)
    add_index :admin_users, :reset_password_token, unique: true unless index_exists?(:admin_users, :reset_password_token)
    # add_index :admin_users, :confirmation_token,   unique: true
    # add_index :admin_users, :unlock_token,         unique: true
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
