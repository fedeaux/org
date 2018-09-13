attributes :id, :text_color, :background_color, :name, :ancestry, :path_ids

# This is the shittiest piece of code ever written :(
child :children do
  attributes :id, :text_color, :background_color, :name, :ancestry, :path_ids
  child :children do
    attributes :id, :text_color, :background_color, :name, :ancestry, :path_ids
    child :children do
      attributes :id, :text_color, :background_color, :name, :ancestry, :path_ids
    end
  end
end
