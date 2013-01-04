actions :enable, :disable, :delete, :create
default_action :enable

attribute :source,     kind_of: String, required: true
attribute :cookbook,   kind_of: String
attribute :variables,  kind_of: Hash,   default: {}
