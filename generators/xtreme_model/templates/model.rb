class <%= class_name %> < ActiveRecord::Base
  <%= "belongs_to :#{parent_singular_name}" if parent? %>
end
