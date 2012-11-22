define 'parser', ['common', 'hyphen'], (Common, Hyphen)->
  parse = (text, width=320)->
    if text.length > 10086
      return {
        status: -1
        text: "大哥.太长了吧!~有木有搞错~~~(/= _ =)/~┴┴"
      }

    sentences = Array()
    [start, end, cnt_width, w_index] = [0, 0, 0, 0]

    while w_index<text.length
      # handle with all cases
      r = Common.handle_hyphen(text, w_index, width-cnt_width)
      if r.status == 0
        wrap_index = r.wrap_index ? 0
        sentences.push(text.slice(start, end = end+wrap_index+1))
        [start, cnt_width] = [end, 0]
        w_index = end+1
        continue

      w = text[end = w_index]
      word_width = Common.get_word_width(w)
      if cnt_width+word_width>width
        sentences.push(text.slice(start, end))
        [start, cnt_width] = [end, 0]
      else
        cnt_width = cnt_width+word_width

      w_index += 1
    sentences.push(text.slice(start))
    return {
      status: 0
      text: sentences.join('<br />')
    }

  return {
    parse: parse
  }
