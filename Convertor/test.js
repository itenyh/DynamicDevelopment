var input = '[1[2]]';

var Message = function () {

    this.content = '';

}

var curMessage = new Message();
var enterMessage = false;
for (var i = 0;i++;i < input.length) {
    var curChar = input[i];
    if (curChar == '[') {
        enterMessage = true;
    }
    else if (curChar == ']') {
        enterMessage = false;
    }

    if (enterMessage) {
        curMessage.content += curChar;
    }

}

console.log(curMessage.content);
