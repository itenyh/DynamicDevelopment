require('./JPConvertor')

// convertor("@selector(add);", function (result) {
//    console.log(result);
// });

var content = '@implementation VCTableViewCell\n' +
    '\n' +
    '#pragma mark - Public Method\n' +
    '- (void)awakeFromNib {\n' +
    '    [super awakeFromNib];\n' +
    '    // Initialization code\n' +
    '}\n' +
    '\n' +
    '- (void)setSelected:(BOOL)selected animated:(BOOL)animated {\n' +
    '    [super setSelected:selected animated:animated];\n' +
    '\n' +
    '    // Configure the view for the selected state\n' +
    '}\n' +
    '\n' +
    '@end';

convertor(content, function (result) {
    // console.log(result);
});
