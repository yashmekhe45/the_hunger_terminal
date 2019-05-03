$(document).on("turbolinks:load", function() {
  if (userSignedIn === "true") {
    if ("serviceWorker" in navigator) {
      if (Notification.permission !== "granted") {
        navigator.serviceWorker
          .register("/serviceworker.js", { scope: "./" })
          .then(function(registration) {
            registration.pushManager
              .subscribe({
                userVisibleOnly: true,
                applicationServerKey: vapidPublicKey
              })
              .then(function(subscription) {
                $.post("/subscribe", { subscription: subscription.toJSON() });
              })
              .catch(function(error) {
                console.log(error.message);
              });
          });
      }
    }
  }
});
