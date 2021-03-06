ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  private
  # ログイン状態にする
  def login_as(name, admin = false)
    session[:member_id] = FactoryGirl.create(:member, name: name,
      administrator: admin)
  end
  # Add more helper methods to be used by all tests here...
end
