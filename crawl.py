#!/usr/bin/env python3

from urllib import request
import json


def search(lang, page_num):
    url = 'https://api.github.com'
    api = '/search/repositories'
    query_lang = 'language:'
    query_suffix = '&stars:>10&per_page=100'
    token = '53886cf699fad92bf1f9f156c79efd9b2ee57c15'
    query = url + api + '?q=' + query_lang + lang + query_suffix
    for i in range(1,page_num+1):
        actual_query = query + '&page=' + str(i);
        # actual_query += token
        # print("requesting " + actual_query + ' ..')
        req = request.Request(actual_query)
        req.add_header("Authorization", "token " + token)
        response = request.urlopen(req)
        s = response.read().decode('utf8')
        # TODO use username--reponame as name
        filename = lang + '-' + str(i) + '.json'
        with open(filename, 'w') as f:
            f.write(s)
            print('writen to ' + filename)


if __name__ == '__main__':
    # TODO multi-thread
    # for lang in ['c', 'java', 'javascript', 'python', 'ruby', 'php', 'c++', 'c#', 'objective-c', 'shell']:
    for lang in ['shell']:
        search(lang, 10);
    # print(query)
    # j = json.loads(s)
    # print(j)
