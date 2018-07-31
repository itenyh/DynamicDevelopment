var input = '[1 [2]]';

var Message = function () {

    this.startIndex = -1;
    this.endIndex = -1;

}

var curDeep = 0;
var oldMessage = null;
var curMessage = null;
var messages = [];

for (var i = 0;i<input.length;i++) {
    var curChar = input[i];
    var deepIn = false;
    var deepOut = false;

    if (curChar == '[') {
        curDeep++;
        deepIn = true;
    }
    else if (curChar == ']') {
        curDeep--;
        deepOut = true;
    }

    if (deepIn) {
        var message = new Message();
        message.startIndex = i;
        messages.push(message);

        oldMessage = curMessage;
        curMessage = message;
    }

    if (deepOut) {
        curMessage.endIndex = i;
        curMessage = oldMessage;
    }
}

