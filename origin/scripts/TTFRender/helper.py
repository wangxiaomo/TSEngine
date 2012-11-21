#-*- coding: utf-8 -*-

"""
Some Helper Function of Module TTFRender
"""

import os
import re

def get_ttf_file(font_name):
    """ TODO: Make a Adapter to Get the TTF FILE of Specified Font """
    FONT_DIRECTORY = os.path.abspath(os.path.dirname(__file__))+"/fonts/"
    if font_name == 'A':
        return _unicode(FONT_DIRECTORY+"钟齐吴嘉睿手写字.ttf")
    else:
        return _unicode(FONT_DIRECTORY+"kai.ttf")

def _unicode(w):
    """ Get the Unicode of Specified Word """
    if isinstance(w, unicode):
        return w
    else:
        return w.decode("utf-8")

def get_token_list(line):
    """ Get The Token List of a Sentence """
    line = _unicode(line)
    return list(set(re.findall(r'\w|\W', line)))
