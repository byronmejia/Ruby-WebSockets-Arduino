// -------------------- Functions --------------------

function CommandMessage( option ) {
    this.command = option.command
}

function MessageFactory() {
    MessageFactory.prototype.createPart  = function createMessage( options ) {
        var parentClass = null;

        switch(options.messageType){
            case 'command':
                parentClass = CommandMessage
                break;
            default:
                break;
        }

        if(parentClass === null) return false;

        return new parentClass(options);

    }
}

function getRandomColor() {
    var letters = '0123456789ABCDEF'.split('');
    var color = '#';
    for (var i = 0; i < 6; i++ ) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}

// -------------------- Variables --------------------

var exampleSocket = new WebSocket("ws://localhost:9292");
var msgFactory = new MessageFactory();


// -------------------- Events --------------------
exampleSocket.onmessage = function (event) {
    var element = document.createElement("div");
    element.className = "msg";

    var text = event.data;

    if(text.length){
        element.appendChild(document.createTextNode(text));
        document.getElementById("chatbox").appendChild(element);
        console.log(event.data);
        switch(text){
            case '1':
                document.body.style.background = getRandomColor();
        }
    }
};