require "test_helper"

class SendEmployeeCancelMailJobTest < ActiveJob::TestCase

  include ActiveJob::TestHelper
  
  before :each do
    @user = create(:user)
    @user.confirm
  end

  test 'perform' do
    terminal = [create(:terminal, company: @company)]
    assert_performed_jobs 0
    perform_enqueued_jobs do
      SendEmployeeCancelMailJob.perform_now(@user.id,terminal)
    end
    assert_performed_jobs 1
  end
end
