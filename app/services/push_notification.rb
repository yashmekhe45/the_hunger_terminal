class PushNotification
  def self.send_to(users)
    expired_subscription_ids = []

    Subscription.where(user_id: users).each do |subscription|
      webpush_params = {
        message:  WEB_NOTIFICATION_MSG,
        endpoint: subscription.endpoint,
        p256dh:   subscription.p256dh_key,
        auth:     subscription.auth_key,
        api_key:  ENV.fetch('PUSH_NOTIFICATION_API_KEY')
      }

      begin
        Webpush.payload_send webpush_params
      rescue Webpush::ExpiredSubscription
        expired_subscription_ids << subscription.id
      end
    end

    # Destroy expired subscriptions
    Subscription.where(id: expired_subscription_ids).destroy_all
  end
end
