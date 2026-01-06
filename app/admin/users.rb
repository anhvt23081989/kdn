ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role, :confirmed_at

  index do
    selectable_column
    id_column
    column :email
    column :role do |user|
      status_tag user.role, class: user.admin? ? 'yes' : 'no'
    end
    column :confirmed_at do |user|
      user.confirmed? ? status_tag("Yes", :ok) : status_tag("No", :warning)
    end
    column :created_at
    column :last_sign_in_at
    actions
  end

  filter :email
  filter :role, as: :select, collection: User.roles
  filter :confirmed_at
  filter :created_at

  show do
    attributes_table do
      row :id
      row :email
      row :role do |user|
        status_tag user.role, class: user.admin? ? 'yes' : 'no'
      end
      row :confirmed_at
      row :confirmation_sent_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password, input_html: { autocomplete: "new-password" }
      f.input :password_confirmation, input_html: { autocomplete: "new-password" }
      f.input :role, as: :select, collection: User.roles.keys.map { |r| [r.humanize, r] }, include_blank: false
      f.input :confirmed_at, as: :date_time_picker if f.object.persisted?
    end
    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      super
    end
  end
end

