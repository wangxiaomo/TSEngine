

# Helper Function.

get_html = (parser, width, content) ->
  # parse the content and get the html back
  classes = []

  return "" if content.type != 'headline' and content.type != 'paragraph'
  classes.push(content.type)
  for style, value of content.data.format
    classes.push(style) if value == true
    # put the align to the classes_str
    classes.push(value) if style == 'p_align'
  classes_str = classes.join(' ')
  result = parser.resize_paragraph(content.data.text, width)
  return {size: result.size, content: "<p class=\"" + classes_str + "\">" + result.content + "</p>"}
