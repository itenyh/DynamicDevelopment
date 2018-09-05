function parser (input) {

    var startIndex = 0;
    var defineComponent, keyComponent, valueComponet;
    var result = getComponent(input, startIndex, false);
    defineComponent = result[0];
    startIndex = result[1];
    result = getComponent(input, startIndex, false);
    keyComponent = result[0];
    startIndex = result[1];
    result = getComponent(input, startIndex, true);
    valueComponet = result[0];
    startIndex = result[1];

    console.log(defineComponent, keyComponent, valueComponet);

}

function getComponent(content, startIndex, isValueComponent) {

    var result = '';
    var index = startIndex;
    for (var i = startIndex;i < content.length;i++) {
        index++;
        var curChar = content[i];
        if (curChar == ' ') break;
        result += curChar;
    }

    return [result, index];

}

parser('#define S 12');