#coding:utf-8

import urllib

HOST='localhost'
PORT='8080'
LOC='typeahead'

f = open('query.txt', 'r')
lines = f.readlines()
f.close()
for line in lines:
    p = line.split('|')
    if len(p) == 2:
        city_code = p[0].strip()
        query = p[1].strip()
        print "http://%s:%s/%s?city_code=%s&query=%s" % (HOST, PORT, LOC, city_code, urllib.quote(query))
