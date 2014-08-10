class IpBlacklist < ActiveRecord::Base
  attr_accessible :ip_address, :user_name, :status
end
