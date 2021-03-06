// Generated by CoffeeScript 1.3.3
(function() {

  define('parser', ['common', 'hyphen'], function(Common, Hyphen) {
    var parse;
    parse = function(text, width) {
      var cnt_width, end, r, sentences, start, w, w_index, word_width, wrap_index, _ref, _ref1, _ref2, _ref3;
      if (width == null) {
        width = 320;
      }
      if (text.length > 10086) {
        return {
          status: -1,
          text: "大哥.太长了吧!~有木有搞错~~~(/= _ =)/~┴┴"
        };
      }
      sentences = Array();
      _ref = [0, 0, 0, 0], start = _ref[0], end = _ref[1], cnt_width = _ref[2], w_index = _ref[3];
      while (w_index < text.length) {
        r = Common.handle_hyphen(text, w_index, width - cnt_width);
        if (r.status === 0) {
          wrap_index = (_ref1 = r.wrap_index) != null ? _ref1 : 0;
          sentences.push(text.slice(start, end = end + wrap_index + 1));
          _ref2 = [end, 0], start = _ref2[0], cnt_width = _ref2[1];
          w_index = end + 1;
          continue;
        }
        w = text[end = w_index];
        word_width = Common.get_word_width(w);
        if (cnt_width + word_width > width) {
          end = Common.handle_punctuation(text, end);
          sentences.push(text.slice(start, end));
          if (w === '“') {
            w_index -= 2;
            continue;
          }
          _ref3 = [0, end, end], cnt_width = _ref3[0], start = _ref3[1], w_index = _ref3[2];
        } else {
          cnt_width = cnt_width + word_width;
          w_index += 1;
        }
      }
      sentences.push(text.slice(start));
      return {
        status: 0,
        text: sentences.join('<br />')
      };
    };
    return {
      parse: parse
    };
  });

}).call(this);
