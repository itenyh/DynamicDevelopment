
module.exports = {
  entry: './JPConvertor.js',
  output: {
    path: __dirname + '/product',
    filename: 'convertor_hr.js',
    library: 'MyLibrary',         // 全局变量名
    libraryTarget: 'umd',         // 通用模块定义
    globalObject: 'this',         // 兼容 node 和浏览器
  },
  mode: 'production',
  resolve: {
    fallback: {
      "fs": false,
      "path": false,
      "crypto": false
      // 添加其他你遇到的 Node.js 核心模块
    }
  }
};

//使用以下命令进行代码打包
//npm install webpack webpack-cli --save-dev          
//npx webpack 