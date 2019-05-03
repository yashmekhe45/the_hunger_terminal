class SubscriptionsController < ApplicationController

  def create
    current_user.subscriptions.create!(
      endpoint:   params['subscription']['endpoint'],
      auth_key:   params['subscription']['keys']['auth'],
      p256dh_key: params['subscription']['keys']['p256dh']
    )

    head :ok
  end
end
