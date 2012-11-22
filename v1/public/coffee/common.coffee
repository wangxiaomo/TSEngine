define 'common', ['jquery', 'utils', 'hyphen'], ($, utils, Hyphen)->
  hyphen = new Hyphen()
  zhchar_width = 16
  enchar_width = Array()
  enchar_str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`1234567890-=~!@#$%^&*(~)_+[]\\;',./{}|:\"<>? “”‘"
  $.map(enchar_str, (i)->
    enchar_width.push(utils.get_dom_width(i))
  )

  get_word_width = (w)->
    pos = enchar_str.indexOf(w)
    if pos == -1
      return zhchar_width
    else
      return enchar_width[pos]

  handle_hyphen = (text, start, residual_width)->
    #
    # TODO: 确认并整理思路
    #
    #
    AVERAGE_WIDTH = 8
    word = utils.preview_enchar_word(text, start)
    if word.length>0
      possible_width = word.length*AVERAGE_WIDTH
      if possible_width>residual_width
        points = hyphen.hyphenate(word)
        end = Math.floor(residual_width/AVERAGE_WIDTH)
        while end>0
          if points[end]%2 == 1
            break
          end = end-1
        return {
          status: 0
          wrap_index: end
        }

    return {
      status: -1
    }

  return {
    zhchar_width: zhchar_width
    enchar_width: enchar_width
    get_word_width: get_word_width
    handle_hyphen: handle_hyphen
  }
