ActiveAdmin.register User do
  menu priority: 1, parent: 'Users'

  filter :id
  filter :ecampus_id
  filter :last_activity
  filter :updated_at
  filter :created_at
  filter :ics_key

  index do
    selectable_column
    column :id
    column :ecampus_id
    column :last_activity
    column :updated_at
    column :created_at

    actions
  end

  form do |f|
    f.inputs do
      f.input :ecampus_id
      f.input :password
      f.input :ics_key
      f.input :token
    end
    f.actions
  end
end
