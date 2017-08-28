require "test_helper"

class SendOrderMailJobTest < ActiveJob::TestCase
  
  before :each do
    @user = build(:user)
  end
  
  test 'perform' do
    SendOrderMailJob.perform_later(@user.id)
    assert_enqueued_jobs 1
  end
end
