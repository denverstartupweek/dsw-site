# frozen_string_literal: true

ActiveAdmin.register AttendeeGoal do
  menu parent: "Site Content", label: "Attendee Goals"

  permit_params :name,
    :description,
    :is_active

  index do
    selectable_column
    column :name
    column :description
    column :is_active
    actions
  end
end
