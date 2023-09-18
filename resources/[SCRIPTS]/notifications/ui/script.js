window.onload = (e) => {
    var _centerNotifications = document.getElementsByClassName("center-notification-list")[0] 
    var _sideNotifications = document.getElementsByClassName("side-notification-list")[0] 

    window.addEventListener('message', (event) => {
        var message = JSON.parse(event.data);
       
        if (!message) return;

        if (message.type == "side") {
            var newNotification = _sideNotifications.createElement("div")
            if (_sideNotifications.children[0]) {
                _sideNotifications.insertBefore(newNotification, _sideNotifications.children[0])
            } else {
                _sideNotifications.append(newNotification)
            }
            newNotification.innerHTML = message.data.text
            newNotification.classList.add("side-notification")

            setTimeout(() => {
                newNotification.classList.add("centerclosed")
            }, message.data.time);
        }

        if (message.type == "center") {
            var newNotification = _centerNotifications.createElement("div")
            if (_centerNotifications.children[0]) {
                _centerNotifications.insertBefore(newNotification, _centerNotifications.children[0])
            } else {
                _centerNotifications.append(newNotification)
            }
            newNotification.innerHTML = message.data.text
            newNotification.classList.add("center-notification")

            setTimeout(() => {
                newNotification.classList.add("centerclosed")
            }, message.data.time);
        }
    })
}