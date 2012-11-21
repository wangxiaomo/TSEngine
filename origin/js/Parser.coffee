
# Class of Parser
class Parser

    # CONSTRUCTOR: 初始化变量
    constructor: (dom_area) ->
        @hyphenator = new Hyphen()
        @dom_area = dom_area
        @zhchar_width = @get_dom_length('测')
        @enchar_width = Array()
        @str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`1234567890-=~!@#$%^&*(~)_+[]\\;',./{}|:\"<>? “”‘"

        # 初始化单字符
        for k,i in @str
            @enchar_width[i] = @get_dom_length(k)
        # 让空格宽度等于 ' 宽度
        @enchar_width[@str.indexOf(' ')] = @enchar_width[@str.indexOf("'")]
        @enchar_width[@str.indexOf('“')] = @zhchar_width # 不同字体 中文引号所占宽度不同
        @enchar_width[@str.indexOf('”')] = @zhchar_width #

    # 获取字页面宽度
    get_dom_length: (text) ->
        p = document.createElement("p")
        `p.innerHTML = ("<span style=\"text-align:justify;text-align-last:justify;text-justify:auto;\">" + text +"</span>")`
        $(@dom_area)[0].appendChild(p)
        r = $("span").width()
        $(@dom_area)[0].innerHTML = ""
        return r

    # 获取指定字体的字页面宽度
    get_dom_length_with_spec_font: (text, font_name) ->
        `p.innerHTML = ("<span style=\"text-align:justify;text-align-last:justify;text-justify:auto;font-family:"+font_name+"\">" + text +"</span>")`
        $(@dom_area)[0].appendChild(p)
        r = $("span").width()
        $(@dom_area)[0].innerHTML = ""
        return r
    
    # 获取 MathJax 宽度
    get_math_jax_width: (text) ->
        p = document.createElement("p")
        `p.innerHTML = ("<span style=\"text-align:justify;text-align-last:justify;text-justify:auto;\">" + text +"</span>")`
        $(@dom_area)[0].appendChild(p)
        MathJax.Hub.Typeset()
        r = $("span").width()
        $(@dom_area)[0].innerHTML = ""
        return r

    # 计算字符宽度
    get_letter_length: (letter) ->
        if @str.indexOf(letter) == -1
            return @zhchar_width
        else
            return @enchar_width[@str.indexOf(letter)]

    # 调整段落
    resize_paragraph: (data, width) ->
        data = @replace_inline_markup(data)
        ret = Array()
        cnt_width = 0
        begin = 0
        end = 0
        is_enchar_token = false
        enchar_index = 0
        last_enchar_token = ''

        i = 0
        while i<data.length
            letter = data[i]
            # 处理段内标记
            size = @ignore_html_markup(data, i)
            if size>0
                i = i+size+1
                continue
            # TODO: 处理 MathJax
            math_jax_info = @get_math_jax_info(data, i)
            if math_jax_info.length
                math_jax_width = @get_math_jax_width(math_jax_info.data)
                if cnt_width+math_jax_width>width
                    #TODO
                    end = i
                    line = data.substring(begin, end)
                    line += '-' if add_delim
                    add_delim = false
                    ret.push(line)
                    begin = end
                    cnt_width = 0
                    continue
                else
                    i += math_jax_info.length
                    cnt_width += math_jax_width
            else
                size = @get_letter_length(letter)
                cnt_width += size

            # 判断是否为英文单词
            if @is_alpha(letter)
                last_enchar_token = @preview_word(data, i) if is_enchar_token != true
                is_enchar_token = true
            else
                is_enchar_token = false
                enchar_index = 0
                last_enchar_token = ''
            if is_enchar_token == true
                enchar_index++

            if cnt_width>width
                end = i
                if @is_punctuation(data, i)
                    end = i+1
                else
                    if is_enchar_token == true
                        points = @hyphenator.hyphenate(last_enchar_token)
                        points_len = points.length
                        if not @is_empty(points)
                            end = i-enchar_index
                        else
                            wrap_index = @get_wrap_index(points, enchar_index)
                            end = i+wrap_index+1
                            add_delim = true if wrap_index+enchar_index>0
                line = data.substring(begin, end)
                line += '-' if add_delim
                add_delim = false
                ret.push(line)
                begin = end
                cnt_width = size
            i += 1
        ret.push(data.substring(begin))
        return { size: ret.length, content: ret.join("<br />") }

    # 调整文章
    resize_post: (data, width)->
        ret = Array()
        params = data.split("\n") # 段落换行标记
        for p in params
            ret.push(@resize_paragraph(p, width)) if p
        return { size: ret.length, content: ret.join("<br />") }

    #
    # Helper Function To Make the Reize More Beautiful.
    #

    replace_inline_markup: (content)->
        content = content.replace(/<注释开始>/g, '<span class="comment">')
        content = content.replace(/<着重开始>/g, '<span class="bold">')
        content = content.replace(/<\/(注释|着重)结束>/g, '</span>')
        return content

    ignore_html_markup: (str, i)->
        return 0 if str[i]!='<'
        result = /<(\S*?)[^>]*>/.exec(str.substring(i))
        return result[0].length

    # 返回 math_jax 字符串
    get_math_jax_string: (str)->
        common_mathjax_pat = /^\$\$.*?\$\$/
        inline_mathjax_pat = /^\\\(.*?\\\)/
        ret = common_mathjax_pat.exec(str) || inline_mathjax_pat.exec(str)
        console.log("MathJax String: " + ret[0]) if ret
        return ret[0] if ret
        return ret

    # 是 math_jax 的话返回 math_jax 长度。反之返回0
    get_math_jax_info: (str, i)->
        data = str.substring(i)
        ret = @get_math_jax_string(data)
        math_jax_length = 0
        math_jax_length = ret.length if ret
        return { length: math_jax_length, data: ret}

    # 检测是否为行首标点符号。
    is_punctuation: (str, i)->
        # 定义不能放置在行首的标点符号
        punctuation = ',.，。:：!！>》、?？”'
        if punctuation.indexOf(str[i]) != -1
            return true
        else
            return false

    # 检测是否为英文字母
    is_alpha: (letter)->
        if 'a'<=letter<='z' or 'A'<=letter<='Z'
            return true
        else
            return false

    preview_word: (str, i)->
        # from index i to preview english word
        word = ''
        while @is_alpha(str[i])
            word += str[i]
            i++
        return word

    get_wrap_index: (points, index)->
        # 如果没有找到就全部断开.或者根据效果选择不同逻辑.
        # TODO
        left = right = index
        while left>=0
            break if points[1+left]%2
            left--
        while right<points.length
            break if points[1+right]%2
            right++
        if Math.abs(left-index)<Math.abs(right-index)
            return left-index
        else
            return right-index

    is_empty: (list)->
        n = list.length
        return 0 if n==0
        flag = 0
        for i in list
            if i%2
                flag = 1
                break
        return flag
