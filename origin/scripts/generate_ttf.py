#-*- coding: utf-8 -*-

from TTFRender import get_token_list
from TTFRender import generate

data = open("data.js").read()
data = eval(data)

title = data['title']
posts = data['posts'][0]
contents = posts['contents']

A = []
B = []

for content in contents:
    if content['type'] == 'headline':
        A = A+get_token_list(content['data']['text'])
    elif content['type'] == 'paragraph':
        B = B+get_token_list(content['data']['text'])
    else:
        continue

A = list(set(A))
B = list(set(B))

generate(A, 'A', 'A.ttf')
generate(B, 'B', 'B.ttf')
