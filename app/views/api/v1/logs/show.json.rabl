object :@log
attributes :id, :loggable_id, :start, :finish, :description

child :loggable do
  attributes :id, :text_color, :background_color, :name
end
