window.onload = (e) => {
    var _menu = document.getElementsByClassName("menu-container")[0] 
    var _menuinput = document.getElementsByClassName("menu-input-container")[0] 
    var _inputtitle = document.getElementsByClassName("menu-input-title")[0] 
    var _input = document.getElementsByClassName("menu-input")[0] 

    var _currentOptions = []
    var _currentSelected = 0

    function SelectUp() {
        if (_currentSelected == 0)
            _currentSelected = _currentOptions.length - 1
        else
            _currentSelected--

        document.getElementsByClassName("selected")[0].classList.remove("selected")
        _currentOptions[_currentSelected].classList.add("selected")
        if (_currentSelected >= 4) {
            var topPos =  _currentOptions[_currentSelected - 4].offsetTop;
            _menu.scrollTop = topPos;
        } else {
            var topPos =  _currentOptions[0].offsetTop;
            _menu.scrollTop = topPos;
        }

        SelectOption()
    }

    function SelectDown() {
        if (_currentSelected == _currentOptions.length - 1)
            _currentSelected = 0
        else
            _currentSelected++

        document.getElementsByClassName("selected")[0].classList.remove("selected")
        _currentOptions[_currentSelected].classList.add("selected")

        if (_currentSelected >= 4) {
            var topPos =  _currentOptions[_currentSelected - 4].offsetTop;
            _menu.scrollTop = topPos;
        } else {
            var topPos =  _currentOptions[0].offsetTop;
            _menu.scrollTop = topPos;
        }

        SelectOption()
    }

    function RunSelected() {
        fetch(`https://${GetParentResourceName()}/runoption`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                id: _currentOptions[_currentSelected].id
            })
        })//.then(resp => resp.json()).then(resp => console.log(resp));
    }

    function SelectOption() {
        fetch(`https://${GetParentResourceName()}/selectoption`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                id: _currentOptions[_currentSelected].id
            })
        })//.then(resp => resp.json()).then(resp => console.log(resp));
    }


    function DisplayOptions(options) {
        var innerHTML = ""
        for (var i = 0; i < options.length; i++) {
            if (options[i].quantity)
                innerHTML += 
                    `<div class="menu-option-container" id="${options[i].id}">
                        <div class="menu-option-label">${options[i].label.toUpperCase()}</div>
                        <div class="menu-option-quantity">${options[i].quantity.toString()}</div>
                    </div>`
            else
                innerHTML += 
                    `<div class="menu-option-container" id="${options[i].id}">
                        <div class="menu-option-label">${options[i].label.toUpperCase()}</div>
                    </div>`

        }

        _menu.innerHTML = innerHTML

        _currentOptions = _menu.getElementsByClassName("menu-option-container")
        if (_currentOptions.length - 1 >= _currentSelected){
            _currentOptions[_currentSelected].classList.add("selected")
        }
        else {
            _currentSelected = 0
            _currentOptions[_currentSelected].classList.add("selected")
        }

        ShowMenu()
    }

    function HideMenu() {
        _menu.classList.add("closed");
    }

    function ShowMenu() {
        _menu.classList.remove("closed");
    }

    function Showinput(data) {
        _inputtitle.innerHTML = data.title
        _input.placeholder = data.placeholder ? data.placeholder : "Write something here..."
        _menuinput.classList.remove("inputclosed");
        setTimeout(() => {
            _input.focus()
        }, 1);
    }

    function SubmitInput() {
        fetch(`https://${GetParentResourceName()}/inputresult`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                result: _input.value 
            })
        }) 

        _input.value = ""
        _menuinput.classList.add("inputclosed")
    }

    window.addEventListener('message', (event) => {
        var message = JSON.parse(event.data);
       
        if (!message) return;

        if (message.type == "display-options") {
            if (message.options.length == 0)
                HideMenu()
            else
                DisplayOptions(message.options)
        }

        if (message.type == "selectup")
            SelectUp()

        if (message.type == "selectdown")
            SelectDown()

        if (message.type == "select")
            RunSelected()

        if (message.type == "openinput")
            Showinput(message.inputData)
    })

    _input.addEventListener("keyup", (ev) => {if (ev.which == 13 && !ev.shiftKey) {ev.preventDefault(); SubmitInput()}})
}