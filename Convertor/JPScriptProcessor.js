var beautify = require('./lib/beautify').js_beautify

var JPScriptProcessor = function(script) {
    this.script = script;
    this.stringPair = {};
}

JPScriptProcessor.prototype = {
    replaceString: function() {
        var regex = /"(?:\\"|[^"])*"/g;
        var index = 0;
        this.stringPair = {};
        var self = this;
        this.script = this.script.replace(regex, function (result) {
            var replacement = 'replaceString_###' + index.toString() + 'replaceString_#####';
            self.stringPair[replacement] = result;
            index++;
            return replacement;
        })
        return this;
    },
    restoreString: function() {
        for (var replacement in this.stringPair) {
            this.script = this.script.replace(replacement, this.stringPair[replacement]);
        }
        return this;
    },
    stripSymbolAt: function() {
    	this.script = this.script.replace(/%@/g, "stripSymbolAt_%###@#####");
        this.script = this.script.replace(/\@(\[)|\@(\")|\@(\{)|\@(\()|\@([0-9]+)/g, "$1$2$3$4$5"); //["{(0-9
        this.script = this.script.replace(/stripSymbolAt_%###@#####/g, "%@");
        return this;
    },
    beautify: function() {
        this.script = beautify(this.script);
        return this;
    },
    processPropertyGetter: function() {
        this.script = this.script.replace(/(\.[a-zA-z_]{1}[a-zA-z_1-9]*)/g, "$1()");
        return this;
    },
    uglyDynamicPropertyGetter: function() {
        this.script = this.script.replace(/\((!{0,1})_{1}([a-zA-z_1-9]*)\)/g, "($1self.getProp('$2'))");
        this.script = this.script.replace(/return\s+_{1}([a-zA-z_1-9]*)/g, "return self.getProp('$1')");
        return this;
    },
    replaceNil: function() {
        this.script = this.script.replace(/\bnil\b/g, "null");
        return this;
    },
    restoreDot: function() {
        this.script = this.script.replace(/\|__dot__\|/g, '.');
        return this;
    },
    replaceSuper: function() {
        this.script = this.script.replace(/(super\.)/g, 'self.super().');
        return this;
    },
    requireClasses: function() {
        function getMatches(string, regex, index) {
            index || (index = 1); // default to the first capturing group
            var matches = [];
            var match;
            while (match = regex.exec(string)) {
                matches.push(match[index]);
            }
            return matches;
        }
        var requires = '';
        var regex = /([\w|\d]*?)\./gm;
        var matches = getMatches(this.script, regex, 1);
        matches = matches.filter(function (match, index, self) {
            return match[0] <= 'Z' && match[0] >= 'A';
        })
        matches = matches.filter(function (match, index, self) {
            return index == self.indexOf(match);
        })
        if (matches.length > 0) requires = "require('" + matches.join(',') + "');\n";
        this.script = requires + this.script;
        return this;
    },
    rectFormat: function() {
        this.script = this.script.replace(/(frame|bounds).(size|origin)/gm, "$1");
        return this;
    },
    replace_with__: function() {
        var regex = /(\.{1}[a-zA-z_]{1}[a-zA-z_1-9]*)/g;
        var index = 0;
        var _stringPair = {};
        this.script = this.script.replace(regex, function (result) {
            var replacement = 'replace_with__###' + index.toString() + 'replace_with__#####';
            _stringPair[replacement] = result;
            index++;
            return replacement;
        });
        for (var replacement in _stringPair) {
            _stringPair[replacement] = _stringPair[replacement].replace("_", "__");
            this.script = this.script.replace(replacement, _stringPair[replacement]);
        }
        return this;
    },
    finalScript: function() {
        this.stripSymbolAt().replaceString().rectFormat().processPropertyGetter().uglyDynamicPropertyGetter().restoreDot().replace_with__().requireClasses().replaceNil().replaceSuper().restoreString().beautify();
        return this.script;
    }
}


exports.JPScriptProcessor = JPScriptProcessor;