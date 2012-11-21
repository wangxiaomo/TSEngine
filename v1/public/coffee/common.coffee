define 'common', ['jquery', 'utils'], ($, utils)->
  zhchar_width = 16
  enchar_width = Array()
  enchar_str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`1234567890-=~!@#$%^&*(~)_+[]\\;',./{}|:\"<>? “”‘"
  $.map(enchar_str, (i)->
    enchar_width.push(utils.get_dom_width(i))
  )

  return {
    zhchar_width: zhchar_width
    enchar_width: enchar_width
  }
