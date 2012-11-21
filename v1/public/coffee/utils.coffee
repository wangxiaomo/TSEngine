define 'utils', ['jquery'], ($)->
  get_dom_width = (word)->
    p = document.createElement('p')
    p.innerHTML = '<span id="width-sample" style="text-align:justify;text-align-last:justify;text-justify:auto;">'+word+'</span>'
    $('body').append(p)
    r = $('#width-sample').width()
    $('#width-sample').remove()
    return r
  
  return {
    get_dom_width: get_dom_width
  }
