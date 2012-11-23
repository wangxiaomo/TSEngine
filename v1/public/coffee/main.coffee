requirejs.config {
  baseUrl: "public/js"
}

requirejs(['jquery', 'parser', 'utils', 'data'], ($, Parser, utils, data)->
  ret = Parser.parse(data.text)
  if ret.status == 0
    $('body').html(utils.render(ret.sentences))
  else
    alert(ret.text)
)
