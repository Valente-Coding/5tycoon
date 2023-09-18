window.onload = (e) => {
    var colors = {"red": "#C93D4B", "blue": "#3882ee", "green": "#54CB7B", "yellow": "#F6C21E"}
    var _centerNotifications = document.getElementsByClassName("center-notification-list")[0] 
    var _sideNotifications = document.getElementsByClassName("side-notification-list")[0] 

    window.addEventListener('message', (event) => {
        var message = JSON.parse(event.data);
       
        if (!message) return;

        if (message.type == "notification") {
            var newNotification = document.createElement("div")

            if (_sideNotifications.children[0]) {
                _sideNotifications.insertBefore(newNotification, _sideNotifications.children[0])
            } else {
                _sideNotifications.append(newNotification)
            }

            var notificationTest = document.createElement("span")
            notificationTest.innerHTML = message.data.text
            newNotification.append(notificationTest)

            newNotification.style.borderLeft = `${colors[message.data.color]} solid 0.25vw;`
            newNotification.classList.add("side-notification")

            setTimeout(() => {
                newNotification.classList.add("centerclosed")
            }, message.data.time);
        }
    })
}