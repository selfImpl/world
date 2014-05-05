#coding:utf-8
import re, json
import urllib, urllib2
import math
import socket
import base64
import sys, os, time
import psycopg2
import psycopg2.extras
from psycopg2.extensions import adapt

hsdb_conn=psycopg2.connect(database = 'hs', user = 'postgres', password = 'pOn9o$0cGDOU_h5N%0jaEOKSKm2LynkP', host = 'l-hsdb2.h.cn6.qunar.com', port = 5435)

old_dbname = ''
old_datas = {}

URL="http://l-hs.qunar.com/iapi/hs/hotelsearch?city=wqa&citytag=%s&p=%s&crawl_poi=0&tuijian=true"

def delete_data_from_db(notExists):
    sql = "update qt_hotel_log_analyse_result set status = 1, last_mod = now() where id in ("
    for i in range(len(notExists)):
        sql += str(notExists[i])
        if i != len(notExists) - 1:
            sql += ','
    sql += ')'
    pg_cursor = hsdb_conn.cursor()
    try:
        pg_cursor.execute(sql)
    except:
        pg_cursor.close()
        hsdb_conn.rollback()
        print "delete error : ", notExists
        return
    pg_cursor.close()
    hsdb_conn.commit()

def get_old_datas_from_db(offset, cnt):
    sql = "select id, city_code, query from qt_hotel_log_analyse_result where status = 0 order by id offset %s limit %s"
    cur = hsdb_conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute(sql, (offset, cnt, ))
    notExists = []
    cnt = 0
    for r in cur.fetchall():
        cnt += 1
        city_code = r['city_code'].strip()
        query = r['query'].strip()
        #print r['id'], r['city_code'], r['query']
        u = URL % (urllib2.quote(city_code), urllib2.quote(query))
        #print u
        try:
            res = urllib2.urlopen(u)
            res_json = res.read()
            content = json.loads(res_json)
        except:
            print "request error, url:", u
            continue
        ok = False
        if content.has_key('search_result') and content['search_result'].has_key('hotels'):
            if len(content['search_result']['hotels']) > 0:
                ok = True
        if len(unicode(query, 'utf-8')) < 2:
            ok = False
        if not ok:
            notExists.append(int(r['id']))
        #time.sleep(0.0001)
    print "delete : ", notExists
    if len(notExists) > 0:
        delete_data_from_db(notExists)
    return cnt


def get_old_datas(limit):
    offset = 0
    while True:
        print "checking offset : %d, limit : %d." % (offset, limit)
        get = get_old_datas_from_db(offset, limit)
        if get != limit: break
        offset += get

if __name__ == '__main__':
    get_old_datas(1000)

