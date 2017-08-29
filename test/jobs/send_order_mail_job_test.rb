require "test_helper"

class SendOrderMailJobTest < ActiveJob::TestCase

  include ActiveJob::TestHelper
  
  before :each do
    @user = create(:user)
  end
  
  test 'perform' do
    assert_performed_jobs 0
    perform_enqueued_jobs do
      SendOrderMailJob.perform_later(@user.id)
    end
    assert_performed_jobs 1
  end
end
