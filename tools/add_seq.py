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

new_datas = {}

def update_data_from_db(needUpdate, values):
    print len(needUpdate)
    print len(values)
    for i in range(len(needUpdate)):
        sql = "update qt_hotel_log_analyse_result set hotel_seq = '%s' where id = %d;" % (values[i], needUpdate[i])
        pg_cursor = hsdb_conn.cursor()
        try:
            pg_cursor.execute(sql)
        except:
            pg_cursor.close()
            hsdb_conn.rollback()
            print "update error : ", needUpdate
            return
        if i % 1000 == 0:
            pg_cursor.close()
            hsdb_conn.commit()
    pg_cursor.close()
    hsdb_conn.commit()
    print 'done'

def get_old_datas_from_db():
    sql = "select id, city_code, query from qt_hotel_log_analyse_result where type = 8 and city_code is not null and query is not null and city_code != '' and query != '' and (hotel_seq is null or hotel_seq = '')"
    cur = hsdb_conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute(sql)
    needUpdate = []
    values = []
    cnt = 0
    for r in cur.fetchall():
        cnt += 1
        key = r['city_code'].strip() + '|' + r['query'].strip()
        if new_datas.has_key(key):
            needUpdate.append(r['id'])
            values.append(new_datas[key])
    if len(needUpdate) > 0:
        update_data_from_db(needUpdate, values)
    return cnt


def get_old_datas(limit):
    offset = 0
    while True:
        get = get_old_datas_from_db(offset, limit)
        if get != limit: break
        offset += get

def get_new_datas_from_db():
    sql = "select city_code, query, hotel_seq from qt_hotel_log_analyse_result_tmp where type = 8 and city_code is not null and query is not null and city_code != '' and query != ''"
    cur = hsdb_conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute(sql)
    cnt = 0
    for r in cur.fetchall():
        cnt += 1
        key = r['city_code'].strip() + '|' + r['query'].strip()
        if r.has_key('hotel_seq') and r['hotel_seq'] is not None:
            new_datas[key] = r['hotel_seq'].strip()
    return cnt

if __name__ == '__main__':
    get_new_datas_from_db()
    get_old_datas_from_db()

