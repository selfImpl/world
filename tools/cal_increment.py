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

old_datas = {}

new_datas = {}

def get_old_datas_from_db():
    sql = "select * from qt_hotel_log_analyse_result;"
    cur = hsdb_conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute(sql)
    cnt = 0
    for r in cur.fetchall():
        cnt += 1
        hotel_seq = ''
        if r.has_key('hotel_seq') and r['hotel_seq'] is not None:
            hotel_seq = r['hotel_seq']
        key = r['city_code'].strip() + '|' + r['query'].strip()
        if not old_datas.has_key(key):
            old_datas[key] = (r['id'], r['search_cnt'], r['detail_cnt'], r['status'], r['type'])
        else:
            res = old_datas[key]
            if res[4] < r['type']:
                old_datas[key] = (r['id'], r['search_cnt'], r['detail_cnt'], r['status'], r['type'])
    return cnt

tot_insert = 0
def insert_into_db(city_code, query, tag, ty, hotel_seq, search_cnt, detail_cnt):
    global tot_insert
    tot_insert += 1
    #return
    sql = "insert into qt_hotel_log_analyse_result(city_code, query, query_py, type, tag, tag_py, hotel_seq, search_cnt, detail_cnt, status) values (%s, %s, all_to_pinyin(%s), %d, %s, all_to_pinyin(%s), %s, %d, %d, 0)" % (adapt(city_code), adapt(query), adapt(query), ty, adapt(tag), adapt(tag), adapt(hotel_seq), search_cnt, detail_cnt)
    pg_cursor = hsdb_conn.cursor()
    try:
        pg_cursor.execute(sql)
    except:
        pg_cursor.close()
        hsdb_conn.rollback()
        print "insert error", city_code, query
        return
    pg_cursor.close()
    hsdb_conn.commit()

tot_update = 0
def update_db(oid, city_code, query, tag, ty, hotel_seq, search_cnt, detail_cnt):
    global tot_update
    tot_update += 1
    #return
    sql = "update qt_hotel_log_analyse_result set last_mod = now(), city_code = %s, query = %s, query_py = all_to_pinyin(%s), type = %d, tag = %s, tag_py = all_to_pinyin(%s), hotel_seq = %s, search_cnt = %d, detail_cnt = %d where id = %d" % (adapt(city_code), adapt(query), adapt(query), ty, adapt(tag), adapt(tag), adapt(hotel_seq), search_cnt, detail_cnt, oid)
    pg_cursor = hsdb_conn.cursor()
    try:
        pg_cursor.execute(sql)
    except:
        pg_cursor.close()
        hsdb_conn.rollback()
        print "update error", city_code, query
        return
    pg_cursor.close()
    hsdb_conn.commit()

def get_new_datas_from_db():
    global tot_insert, tot_update
    sql = "select * from qt_hotel_log_analyse_result_tmp_id where city_code is not null and query is not null and tag is not null and city_code != '' and query != ''"
    cur = hsdb_conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute(sql)
    cnt = 0
    insert = []
    for r in cur.fetchall():
        cnt += 1
        hotel_seq = ''
        if r.has_key('hotel_seq') and r['hotel_seq'] is not None:
            hotel_seq = r['hotel_seq']
        key = r['city_code'].strip() + '|' + r['query'].strip()
        if not old_datas.has_key(key):
            insert_into_db(r['city_code'].strip(), r['query'].strip(), r['tag'].strip(), r['type'], hotel_seq, r['search_cnt'], r['detail_cnt'])
        else:
            res = old_datas[key]
            del old_datas[key]
            currentType = res[4]
            if currentType > r['type']:
                continue
            if r['search_cnt'] == res[1] and r['detail_cnt'] == res[2]:
                continue
            if res[3] == 1 and r['type'] <= 1:
                continue
            #print res, r['search_cnt'], r['detail_cnt']
            update_db(res[0], r['city_code'].strip(), r['query'].strip(), r['tag'].strip(), r['type'], hotel_seq, r['search_cnt'], r['detail_cnt'])
    print "inserted : ", tot_insert, ", updated : ", tot_update
    return cnt

def delete_from_db():
    for v in old_datas.values():
        did = v[0]
        if v[3] == 1:
            #已经删除了的
            continue
        sql = "update qt_hotel_log_analyse_result set status = 1, last_mod = now() where id = %d" % (did, )
        pg_cursor = hsdb_conn.cursor()
        try:
            pg_cursor.execute(sql)
        except:
            pg_cursor.close()
            hsdb_conn.rollback()
            print "delete error", did
            return
        pg_cursor.close()
        hsdb_conn.commit()

if __name__ == '__main__':
    get_old_datas_from_db()
    get_new_datas_from_db()
    print 'del size : ', len(old_datas)
    if len(old_datas) > 300000:
        exit(1)
    delete_from_db()

