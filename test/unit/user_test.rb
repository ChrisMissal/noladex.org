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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:gob)
  end

  test "with no missions is invalid" do
    @user.missions = []

    assert !@user.valid?
  end

  test "url1 removes the @" do
    @user.url1 = '@gob'
    @user.save!

    assert @user.url1 == 'gob'
  end

  test "url1 removes the twitter url" do
    @user.url1 = 'https://twitter.com/#!/franklin'
    @user.save

    assert @user.url1 == 'franklin'
  end

  test "urls should have http:// unless specified" do
    @user.url2 = 'example.com'
    @user.url3 = 'http://somethingelse.com'
    @user.save

    assert @user.url2 == 'http://example.com'
    assert @user.url3 == 'http://somethingelse.com'
  end

  test "urls should not add http:// or mailto: if it's already specified" do
    @user.url2 = 'mailto:gob@example.com'
    @user.url3 = 'http://whatever.com'
    @user.save

    assert @user.url2 == 'mailto:gob@example.com'
    assert @user.url3 == 'http://whatever.com'
  end

  test "if a url is blank, do not add http://" do
    @user.url2 = ''
    @user.save

    assert @user.url2.blank?
    assert @user.url3.blank?
  end
end
