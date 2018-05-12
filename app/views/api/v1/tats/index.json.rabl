object false

child :@tats => :tats do
  collection :@tats
  attributes :id, :user_id
  child(:target) { attributes :id, :start, :duration, :type, :identifier }
  child(:contents) { attributes :id, :content, :content_type, :properties }
end

child :@user do
  attributes :id
end
