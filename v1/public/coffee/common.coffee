define 'common', ['jquery', 'utils'], ($, utils)->
  zhchar_width = 16
  enchar_width = Array()
  enchar_str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`1234567890-=~!@#$%^&*(~)_+[]\\;',./{}|:\"<>? “”‘"
  $.map(enchar_str, (i)->
    enchar_width.push(utils.get_dom_width(i))
  )

  em_to_width = (n)->
    return n*16

  get_word_width = (w)->
    pos = enchar_str.indexOf(w)
    if pos == -1
      return zhchar_width
    else
      return enchar_width[pos]

  get_mathjax_width = (mathjax_text)->
    #TODO: 得到 mathjax 的宽度
    return 0

  return {
    zhchar_width: zhchar_width
    enchar_width: enchar_width
    em_to_width: em_to_width
    get_word_width: get_word_width
    get_mathjax_width: get_mathjax_width
  }
