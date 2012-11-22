define 'parser', ['common', 'hyphen'], (Common, Hyphen)->
  parse = (paragraph, width=320)->
    if paragraph.length > 10086
      return {
        status: -1
        text: "大哥.太长了吧!~有木有搞错~~~(/= _ =)/~┴┴"
      }

    sentences = Array()
    [start, end, cnt_width] = [0, 0, 0]

    for w_index of paragraph
      w = paragraph[end = w_index]
      word_width = Common.get_word_width(w)
      if cnt_width+word_width>width
        sentences.push(paragraph.slice(start, end))
        [start, cnt_width] = [end, 0]
      else
        cnt_width = cnt_width+word_width

    return {
      status: 0
      text: sentences.join('<br />')
    }

  return {
    parse: parse
  }
