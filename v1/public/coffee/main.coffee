requirejs.config {
  baseUrl: "public/js"
}

requirejs(['jquery', 'parser', 'data'], ($, Parser, data)->
  ret = Parser.parse(data.text)
  if ret.status == 0
    $('body').html(ret.text)
  else
    alert(ret.text)
)
