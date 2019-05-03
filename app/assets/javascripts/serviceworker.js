function onPush(event) {
  var title = event.data && event.data.text();

  event.waitUntil(
    self.registration.showNotification(title, {
      body:
        "Hey Hungry head! You can't work with empty stomoch, order your food.",
      icon: "/images/enjoy_food.png",
      tag: "push-simple-demo-notification-tag"
    })
  );
}

self.addEventListener("push", onPush);

self.addEventListener("notificationclick", function(event) {
  event.notification.close();
  event.waitUntil(
    clients.openWindow("https://hunger-terminal.herokuapp.com/order/vendors")
  );
});
