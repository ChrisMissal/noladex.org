# == Schema Information
#
# Table name: missions
#
#  id          :integer         not null, primary key
#  statement   :string(255)
#  user_id     :integer
#  category_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class MissionTest < ActiveSupport::TestCase
  should validate_presence_of :statement
end
