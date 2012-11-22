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
    #: 设定字符平均宽度为8.然后得到单词大概长度,并和剩余宽度进行比较
    #: 如果大于剩余宽度，说明中间涉及到断行！
    #      如果单词小于最短 Hyphen 长度,则全部置于下一行
    #      如果单词大于最短 Hyphen 长度,则查找何处 Hyphen. 假设可容忍的最大宽度为剩余宽度除以
    #      8.然后从该处开始回溯，找到第一个断点进行段行，如果没有找到的话也全部置于下一行.
    #: 如果小于剩余宽度，则不涉及到断行.
    AVERAGE_WIDTH = 10
    residual_width = residual_width+AVERAGE_WIDTH
    word = utils.preview_enchar_word(text, start)
    if word.length>0
      possible_width = word.length*AVERAGE_WIDTH
      if possible_width>residual_width
        if word.length>hyphen.min_word
          points = hyphen.hyphenate(word)
          end = Math.floor(residual_width/AVERAGE_WIDTH)
          while end>0
            if points[end]%2 == 1
              break
            end = end-1
        return {
          status: 0
          wrap_index: end
          word: word
        }
    return {
      status: -1
    }

  handle_punctuation = (text, start)->
    PUNCTUATION = ',.，。:：!！>》、?？”'
    while PUNCTUATION.indexOf(text[start]) != -1
      start = start-1
    return start

  return {
    zhchar_width: zhchar_width
    enchar_width: enchar_width
    get_word_width: get_word_width
    handle_hyphen: handle_hyphen
    handle_punctuation: handle_punctuation
  }
