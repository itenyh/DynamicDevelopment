var flatten = require('flattree').flatten;
var c = require('./JPContext')
var JPCommonContext = c.JPCommonContext,
    JPMsgContext = c.JPMsgContext,
    JPParamContext = c.JPParamContext,
    JPBlockContext = c.JPBlockContext,
    JPBlockContentContext = c.JPBlockContentContext,
    JPAssignContext = c.JPAssignContext,
    JPAssignLeftContext = c.JPAssignLeftContext,
    JPAssignRightContext = c.JPAssignRightContext,
    JPDeclarationContext = c.JPDeclarationContext,
    JPClassContext = c.JPClassContext,
    JPMethodContext = c.JPMethodContext,
    JPPostfixContext = c.JPPostfixContext,
    JPPostfixContentContext = c.JPPostfixContentContext,
    JPForInContext = c.JPForInContext,
    JPForInContentContext = c.JPForInContentContext,
    JPBridgeContext = c.JPBridgeContext,
    JPForInVariableSetContext = c.JPForInVariableSetContext



function viewTree(tree) {
    var nodes = flatten(tree, {
        openNodes: [],
        openAllNodes: true, // Defaults to false
        throwOnEerror: false // Defaults to false
    });

    nodes.forEach((node, index) => {
        // console.log(node)
        const { state, label = '', children = [] } = node;
        const { depth, open, prefixMask } = state;

        if (depth === 0) {
            console.log('%s', label);
            return;
        }

        const prefix = prefixMask.substr(1).split('')
            .map(s => (Number(s) === 0) ? '  ' : '| ').join('');

        console.log('%s%s─%s %s', prefix, (node.isLastChild() ? '└' : '├'), (node.hasChildren() && open ? '┬' : '─'), label);
    });
}

function view(rootContext) {
    var tree = createStructure(rootContext)
    viewTree(tree);
}

function createStructure(context) {

    if (context == null) {
        return {
            id: 'EOT',
            label: 'EOT',
        }
    }

    var id = context.constructor.name;
    var label = id;
    if (context instanceof JPMethodContext) {
        label += ': "' + context.parsedMethodName + '"';
    }
    else if (context instanceof JPCommonContext) {
        var str = context.str.replace(/[\n\s]+/gm, ' ');
        label += ': "' + str + '"';
    }
    var children = getAllChildren(context);
    var tree = { // tree can either be object or array
        id: id,
        label: label,
        children: children
    };
    return tree;
}

function getAllChildren(context) {
    var childrenTree = [];
    if (context instanceof JPClassContext) {
        for (var index in context.instanceMethods) {
            var method = context.instanceMethods[index];
            childrenTree.push(createStructure(method));
        }
    }
    else if (context instanceof JPForInContext) {
        var variableSetContext = context.variableSet;
        var contentContext = context.content;
        childrenTree.push(createStructure(variableSetContext));
        childrenTree.push(createStructure(contentContext));
    }
    else if (context instanceof JPAssignContext) {
        childrenTree.push(createStructure(context.left));
        childrenTree.push(createStructure(context.right));
    }
    else if (context instanceof JPMsgContext) {
        childrenTree.push(createStructure(context.receiver));
    }
    else if (context instanceof JPPostfixContext) {
        childrenTree.push(createStructure(context.content));
    }
    else {
        childrenTree.push(createStructure(context.next));
    }
    return childrenTree;
}

exports.view = view;