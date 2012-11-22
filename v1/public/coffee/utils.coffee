define 'utils', ['jquery'], ($)->
  get_dom_width = (word)->
    p = document.createElement('p')
    p.innerHTML = '<span id="width-sample" style="text-align:justify;text-align-last:justify;text-justify:auto;">'+word+'</span>'
    $('body').append(p)
    r = $('#width-sample').width()
    $('#width-sample').remove()
    return r
  
  is_enchar = (char)->
    if 'a'<=char<='z' or 'A'<=char<='Z'
      return true
    else
      return false

  preview_enchar_word = (text, start)->
    word = ''
    while is_enchar(text[start])
      word += text[start++]
    return word

  return {
    get_dom_width: get_dom_width
    is_enchar: is_enchar
    preview_enchar_word: preview_enchar_word
  }
