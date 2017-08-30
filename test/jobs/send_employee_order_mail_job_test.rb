require "test_helper"

class SendEmployeeOrderMailJobTest < ActiveJob::TestCase

  include ActiveJob::TestHelper
  
  before :each do
    @user = create(:user)
    @user.confirm
  end
  
  test 'perform' do
    assert_performed_jobs 0
    perform_enqueued_jobs do
      SendEmployeeOrderMailJob.perform_later(@user.id)
    end
    assert_performed_jobs 1
  end
end
