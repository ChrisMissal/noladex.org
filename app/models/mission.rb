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

class Mission < ActiveRecord::Base
	belongs_to :user 
	belongs_to :category

  validates :statement, :presence => true,
                        :length   => { :maximum => 50 }
end
