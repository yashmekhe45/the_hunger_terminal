$(document).on("turbolinks:load", function() {
  if (userSignedIn === "true") {
    console.log("aaa");
    if ("serviceWorker" in navigator) {
      if (Notification.permission !== "granted") {
        navigator.serviceWorker
          .register("/serviceworker.js", { scope: "./" })
          .then(function(registration) {
            var serviceWorker;
            if (registration.installing) {
              serviceWorker = registration.installing;
            } else if (registration.waiting) {
              serviceWorker = registration.waiting;
            } else if (registration.active) {
              serviceWorker = registration.active;
            }
            console.log(serviceWorker.state);
            if (serviceWorker) {
              if (serviceWorker.state == "activated") {
                subscribeForPushNotification(registration);
              } else {
                serviceWorker.addEventListener("statechange", function(e) {
                  if (e.target.state == "activated") {
                    subscribeForPushNotification(registration);
                  }
                });
              }
            }
          });
      }
    }
  }
});

function subscribeForPushNotification(registration) {
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
}
