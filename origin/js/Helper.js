var get_html;

get_html = function(parser, width, content) {
  var classes, classes_str, result, style, value, _ref;
  classes = [];
  if (content.type !== 'headline' && content.type !== 'paragraph') return "";
  classes.push(content.type);
  _ref = content.data.format;
  for (style in _ref) {
    value = _ref[style];
    if (value === true) classes.push(style);
    if (style === 'p_align') classes.push(value);
  }
  classes_str = classes.join(' ');
  result = parser.resize_paragraph(content.data.text, width);
  return {
    size: result.size,
    content: "<p class=\"" + classes_str + "\">" + result.content + "</p>"
  };
};
