$(document).on("turbolinks:load", function() {
  if (user_signed_in === "true") {
    if ("serviceWorker" in navigator) {
      if (Notification.permission !== "granted") {
        navigator.serviceWorker
          .register("/serviceworker.js", { scope: "./" })
          .then(function(registration) {
            registration.pushManager
              .subscribe({ userVisibleOnly: true })
              .then(function(subscription) {
                $.post("/subscribe", { subscription: subscription.toJSON() });
              });
          });
      }
    }
  }
});
