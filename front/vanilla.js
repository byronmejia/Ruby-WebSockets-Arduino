// -------------------- Constants --------------------
const CMD_TGL = 'toggle';
const CMD_ON = 'H';
const CMD_OFF = 'L';

const MSG_CMD = 'command';
const MSG_CHAT = 'message';

const PRT_LED = 'led';
// -------------------- Functions --------------------

function CommandMessage( option ) {
    this.messageType = option.messageType || MSG_CMD;
    this.command = option.command || CMD_TGL;
    this.part = option.part || PRT_LED;
}

function ChatMessage( option ) {
    this.messageType = option.messageType || MSG_CHAT;
    this.text = option.text || 'Hello World';
}

function MessageFactory() {
    MessageFactory.prototype.createMsg  = function createMessage( options ) {
        var parentClass = null;

        switch(options.messageType){
            case MSG_CMD:
                parentClass = CommandMessage;
                break;
            case MSG_CHAT:
                parentClass = ChatMessage;
                break;
            default:
                break;
        }

        if(parentClass === null) return false;

        return new parentClass(options);

    }
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

function toggleLED() {
    var ledMessage = msgFactory.createMsg({
        messageType : MSG_CMD,
        command : CMD_TGL,
        part : PRT_LED
    } );
    console.log(ledMessage)
    exampleSocket.send(JSON.stringify(ledMessage))
}

function ledON() {
    var ledMessage = msgFactory.createMsg({
        messageType : MSG_CMD,
        command : CMD_ON,
        part : PRT_LED
    } );
    console.log(ledMessage)
    exampleSocket.send(JSON.stringify(ledMessage))
}

function ledOFF() {
    var ledMessage = msgFactory.createMsg({
        messageType : MSG_CMD,
        command : CMD_OFF,
        part : PRT_LED
    } );
    console.log(ledMessage);
    exampleSocket.send(JSON.stringify(ledMessage))
}

function sendChat(text) {
    var chat = msgFactory.createMsg({
        messageType : MSG_CHAT,
        text : text
    } );
    console.log(chat);
    exampleSocket.send(JSON.stringify(chat))
}
