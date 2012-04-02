# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  email               :string(255)
#  url_photo           :string(255)
#  admin               :boolean
#  created_at          :datetime
#  updated_at          :datetime
#  url1                :string(255)
#  url2                :string(255)
#  url3                :string(255)
#  openid_url          :string(255)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  persistence_token   :string(255)
#  single_access_token :string(255)
#  perishable_token    :string(255)
#  login_count         :integer
#  failed_login_count  :integer
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  avatar_meta         :text
#  major               :string(255)
#

class User < ActiveRecord::Base

  acts_as_authentic do |c|
    c.login_field :email 
    c.require_password_confirmation = false
  end
  
  
  has_many :missions
  has_attached_file :avatar, {
    :styles => { :medium => "250x250#" },
    :storage => Rails.env.production? ? :s3 : :filesystem,
    :bucket => 'weareumd', 
    :s3_credentials => "#{Rails.root}/config/amazon_s3.yml"
  }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
            :length   => { :maximum => 50 }

  validates :email, :presence => true,
            :format   => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }
    
  validates :password,  :presence   => true,
              :confirmation   => true,
              :length     => { :within => 3..20 }
  
  
  validates :avatar_file_name, :presence => true
  

  validates :missions, :length => { :minimum => Constants::MinimumMissions, :message => "You must have at least one mission to be listed."}

  validates_attachment_size :avatar, :less_than=>700.kilobytes, 
                    :if => Proc.new { |imports| !imports.avatar_file_name.blank? }

  before_save :format_urls

  accepts_nested_attributes_for :missions, :reject_if => proc {|attributes| attributes['statement'].blank? }

	def self.find_by_category(category_id)
    includes(:missions => :category).where(["categories.id = ?", category_id])
  end

  private

  def avatar_size
    temp_file = avatar.queued_for_write[:original] #get the file that is being uploaded
    if (temp_file) 
      dimensions = Paperclip::Geometry.from_file(temp_file)
      if (dimensions.width < Constants::ImageWidth) || (dimensions.height < Constants::ImageHeight)
        errors.add("photo_size", "must be image size #{Constants::ImageWidth}x#{Constants::ImageHeight}.")
      end
    end
  end

  def format_urls
    self.url1 = url1.gsub(%r{(^https?://twitter.com/(#!/)?|@)}, '') unless url1.blank?
    self.url2 = "http://#{url2}" if !url2.blank? && !url2.match(%r{^(https?://|mailto:)})
    self.url3 = "http://#{url3}" if !url3.blank? && !url3.match(%r{^(https?://|mailto:)})
  end
end
