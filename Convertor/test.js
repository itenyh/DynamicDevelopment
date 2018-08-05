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


class Polygon {
    constructor(height, width) {
        this.height = height;
        this.width = width;
    }
}

class Square extends Polygon {
    constructor(sideLength) {
        super(sideLength, sideLength);
    }
    get area() {
        return this.height * this.width;
    }
    set sideLength(newLength) {
        this.height = newLength;
        this.width = newLength;
    }
    fuck () {
        console.log(123);
    }
}

var p = new Polygon()
var s = new Square()
s.fuck();
console.log(p.constructor.name, s.constructor.name);