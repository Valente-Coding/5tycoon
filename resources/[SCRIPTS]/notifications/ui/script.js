window.onload = (e) => {
    var _centerNotification = document.getElementsByClassName("center-notification")[0] 
    var _sideNotification = document.getElementsByClassName("side-notification")[0] 

    window.addEventListener('message', (event) => {
        var message = JSON.parse(event.data);
       
        if (!message) return;

        if (message.type == "side") {
            _sideNotification.innerHTML = message.data.text
            _sideNotification.classList.remove("centerclosed")
            setTimeout(() => {
                _sideNotification.classList.add("centerclosed")
            }, message.data.time);
        }

        if (message.type == "center") {
            _centerNotification.innerHTML = message.data.text
            _centerNotification.classList.remove("centerclosed")
            setTimeout(() => {
                _centerNotification.classList.add("centerclosed")
            }, message.data.time);
        }
    })
}