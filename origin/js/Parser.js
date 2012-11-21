var Parser;

Parser = (function() {

  function Parser(dom_area) {
    var i, k, _len, _ref;
    this.hyphenator = new Hyphen();
    this.dom_area = dom_area;
    this.zhchar_width = this.get_dom_length('测');
    this.enchar_width = Array();
    this.str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`1234567890-=~!@#$%^&*(~)_+[]\\;',./{}|:\"<>? “”‘";
    _ref = this.str;
    for (i = 0, _len = _ref.length; i < _len; i++) {
      k = _ref[i];
      this.enchar_width[i] = this.get_dom_length(k);
    }
    this.enchar_width[this.str.indexOf(' ')] = this.enchar_width[this.str.indexOf("'")];
    this.enchar_width[this.str.indexOf('“')] = this.zhchar_width;
    this.enchar_width[this.str.indexOf('”')] = this.zhchar_width;
  }

  Parser.prototype.get_dom_length = function(text) {
    var p, r;
    p = document.createElement("p");
    p.innerHTML = ("<span style=\"text-align:justify;text-align-last:justify;text-justify:auto;\">" + text +"</span>");
    $(this.dom_area)[0].appendChild(p);
    r = $("span").width();
    $(this.dom_area)[0].innerHTML = "";
    return r;
  };

  Parser.prototype.get_dom_length_with_spec_font = function(text, font_name) {
    p.innerHTML = ("<span style=\"text-align:justify;text-align-last:justify;text-justify:auto;font-family:"+font_name+"\">" + text +"</span>");
    var r;
    $(this.dom_area)[0].appendChild(p);
    r = $("span").width();
    $(this.dom_area)[0].innerHTML = "";
    return r;
  };

  Parser.prototype.get_math_jax_width = function(text) {
    var p, r;
    p = document.createElement("p");
    p.innerHTML = ("<span style=\"text-align:justify;text-align-last:justify;text-justify:auto;\">" + text +"</span>");
    $(this.dom_area)[0].appendChild(p);
    MathJax.Hub.Typeset();
    r = $("span").width();
    $(this.dom_area)[0].innerHTML = "";
    return r;
  };

  Parser.prototype.get_letter_length = function(letter) {
    if (this.str.indexOf(letter) === -1) {
      return this.zhchar_width;
    } else {
      return this.enchar_width[this.str.indexOf(letter)];
    }
  };

  Parser.prototype.resize_paragraph = function(data, width) {
    var add_delim, begin, cnt_width, enchar_index, end, i, is_enchar_token, last_enchar_token, letter, line, math_jax_info, math_jax_width, points, points_len, ret, size, wrap_index;
    data = this.replace_inline_markup(data);
    ret = Array();
    cnt_width = 0;
    begin = 0;
    end = 0;
    is_enchar_token = false;
    enchar_index = 0;
    last_enchar_token = '';
    i = 0;
    while (i < data.length) {
      letter = data[i];
      size = this.ignore_html_markup(data, i);
      if (size > 0) {
        i = i + size + 1;
        continue;
      }
      math_jax_info = this.get_math_jax_info(data, i);
      if (math_jax_info.length) {
        math_jax_width = this.get_math_jax_width(math_jax_info.data);
        if (cnt_width + math_jax_width > width) {
          end = i;
          line = data.substring(begin, end);
          if (add_delim) line += '-';
          add_delim = false;
          ret.push(line);
          begin = end;
          cnt_width = 0;
          continue;
        } else {
          i += math_jax_info.length;
          cnt_width += math_jax_width;
        }
      } else {
        size = this.get_letter_length(letter);
        cnt_width += size;
      }
      if (this.is_alpha(letter)) {
        if (is_enchar_token !== true) {
          last_enchar_token = this.preview_word(data, i);
        }
        is_enchar_token = true;
      } else {
        is_enchar_token = false;
        enchar_index = 0;
        last_enchar_token = '';
      }
      if (is_enchar_token === true) enchar_index++;
      if (cnt_width > width) {
        end = i;
        if (this.is_punctuation(data, i)) {
          end = i + 1;
        } else {
          if (is_enchar_token === true) {
            points = this.hyphenator.hyphenate(last_enchar_token);
            points_len = points.length;
            if (!this.is_empty(points)) {
              end = i - enchar_index;
            } else {
              wrap_index = this.get_wrap_index(points, enchar_index);
              end = i + wrap_index + 1;
              if (wrap_index + enchar_index > 0) add_delim = true;
            }
          }
        }
        line = data.substring(begin, end);
        if (add_delim) line += '-';
        add_delim = false;
        ret.push(line);
        begin = end;
        cnt_width = size;
      }
      i += 1;
    }
    ret.push(data.substring(begin));
    return {
      size: ret.length,
      content: ret.join("<br />")
    };
  };

  Parser.prototype.resize_post = function(data, width) {
    var p, params, ret, _i, _len;
    ret = Array();
    params = data.split("\n");
    for (_i = 0, _len = params.length; _i < _len; _i++) {
      p = params[_i];
      if (p) ret.push(this.resize_paragraph(p, width));
    }
    return {
      size: ret.length,
      content: ret.join("<br />")
    };
  };

  Parser.prototype.replace_inline_markup = function(content) {
    content = content.replace(/<注释开始>/g, '<span class="comment">');
    content = content.replace(/<着重开始>/g, '<span class="bold">');
    content = content.replace(/<\/(注释|着重)结束>/g, '</span>');
    return content;
  };

  Parser.prototype.ignore_html_markup = function(str, i) {
    var result;
    if (str[i] !== '<') return 0;
    result = /<(\S*?)[^>]*>/.exec(str.substring(i));
    return result[0].length;
  };

  Parser.prototype.get_math_jax_string = function(str) {
    var common_mathjax_pat, inline_mathjax_pat, ret;
    common_mathjax_pat = /^\$\$.*?\$\$/;
    inline_mathjax_pat = /^\\\(.*?\\\)/;
    ret = common_mathjax_pat.exec(str) || inline_mathjax_pat.exec(str);
    if (ret) console.log("MathJax String: " + ret[0]);
    if (ret) return ret[0];
    return ret;
  };

  Parser.prototype.get_math_jax_info = function(str, i) {
    var data, math_jax_length, ret;
    data = str.substring(i);
    ret = this.get_math_jax_string(data);
    math_jax_length = 0;
    if (ret) math_jax_length = ret.length;
    return {
      length: math_jax_length,
      data: ret
    };
  };

  Parser.prototype.is_punctuation = function(str, i) {
    var punctuation;
    punctuation = ',.，。:：!！>》、?？”';
    if (punctuation.indexOf(str[i]) !== -1) {
      return true;
    } else {
      return false;
    }
  };

  Parser.prototype.is_alpha = function(letter) {
    if (('a' <= letter && letter <= 'z') || ('A' <= letter && letter <= 'Z')) {
      return true;
    } else {
      return false;
    }
  };

  Parser.prototype.preview_word = function(str, i) {
    var word;
    word = '';
    while (this.is_alpha(str[i])) {
      word += str[i];
      i++;
    }
    return word;
  };

  Parser.prototype.get_wrap_index = function(points, index) {
    var left, right;
    left = right = index;
    while (left >= 0) {
      if (points[1 + left] % 2) break;
      left--;
    }
    while (right < points.length) {
      if (points[1 + right] % 2) break;
      right++;
    }
    if (Math.abs(left - index) < Math.abs(right - index)) {
      return left - index;
    } else {
      return right - index;
    }
  };

  Parser.prototype.is_empty = function(list) {
    var flag, i, n, _i, _len;
    n = list.length;
    if (n === 0) return 0;
    flag = 0;
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      i = list[_i];
      if (i % 2) {
        flag = 1;
        break;
      }
    }
    return flag;
  };

  return Parser;

})();
