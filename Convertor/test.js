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

class Fuck {
    constructor() {

    }
    say () {
        console.log('hello')
    }
}

String.prototype.hashCode = function(){
    var hash = 0;
    for (var i = 0; i < this.length; i++) {
        var character = this.charCodeAt(i);
        hash = ((hash<<5)-hash)+character;
        hash = hash & hash; // Convert to 32bit integer
    }
    return hash;
}

// (function() {
//     var id = 0;
//
//     /*global MyObject */
//     MyObject = function() {
//         this.objectId = '<#MyObject:' + (id++) + '>';
//         this.toString= function() {
//             return this.objectId;
//         };
//     };
// })();
//
// var f = {};
// var p = new Polygon()
// var s = new Square()
// var s1 = new Square()
// var k = new Fuck()
// console.log(MyObject)
// f[JSON.stringify(s)] = k
// console.log(JSON.stringify(s))
// // f[p] = p
// // for (var k in f) {
// //     console.log(Object.parese)
// // }
// console.log(f[JSON.stringify(k)])
// s.fuck();
// console.log(p.constructor.name, s.constructor.name);