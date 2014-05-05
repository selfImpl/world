#!/home/q/python2.7.3/bin/python
# coding=utf8

import gzip
import psycopg2
import psycopg2.extras
from psycopg2.extensions import adapt
import sys
import time


reload(sys)
sys.setdefaultencoding('utf8')


TRADING_AREA_SUFFIX = u'商圈'


def get_hs2():
    con = psycopg2.connect(
        database = 'hs',
        user = 'postgres',
        password = 'pOn9o$0cGDOU_h5N%0jaEOKSKm2LynkP',
        host = 'l-hsdb2.h.cn6.qunar.com',
        port = 5435
    )
    return con


def timeit(method):
    def timed(*args, **kw):
        ts = time.time()
        result = method(*args, **kw)
        te = time.time()
        print >> sys.stderr, '%r  %2.2f sec' % (method.__name__, te - ts)
        return result
    return timed


def get_cities():
    con = get_hs2()
    cur = con.cursor(cursor_factory=psycopg2.extras.DictCursor)
    sql = ''' select city_code from qt_hotel_log_analyse_result where type = 1 group by city_code having count(1) > 0 order by city_code '''
    cur.execute(sql)
    cities = [ r['city_code'] for r in cur.fetchall() ]
    cur.close()
    con.close()
    return cities


def get_current_status(city_code):
    pois = []
    trading_areas = []
    hotel_names = []

    con = get_hs2()
    cur = con.cursor(cursor_factory=psycopg2.extras.DictCursor)
    sql = ''' select id, query, type, poi_in_name from qt_hotel_log_analyse_result where city_code = %s and type in (1, 3, 8) '''
    cur.execute(sql, (city_code, ))

    for r in cur.fetchall():
        i = r['id']
        t = r['type']
        q = r['query']
        if t == 1: # poi
            pois.append([i, q, '', r['poi_in_name'], 0])
        elif t == 3: # trading_area
            q = q.strip(TRADING_AREA_SUFFIX)
            trading_areas.append(q)
            trading_areas.append(q + TRADING_AREA_SUFFIX)
        elif t == 8: # hotel_name(including alias)
            hotel_names.append(q)
        else:
            print 'unknown t: %s' % t

    cur.close()
    con.close()
    return pois, trading_areas, hotel_names


@timeit
def calc_need_update(pois, trading_areas, hotel_names, f):
    for p in pois:
        query = p[1]
        if query in trading_areas:
            continue
        for name in hotel_names:
            if query in name:
                p[-1] = 1
                p[2] = name
                break

    for p in pois:
        if p[-1] == 1:
            f.write('%s\n' % '\t'.join(map(str, p)))

    return [(p[-1], p[0]) for p in pois if p[-1] != p[-2]]


def do_update(need_update):
    con = get_hs2()
    cur = con.cursor(cursor_factory=psycopg2.extras.DictCursor)
    sql = ''' update qt_hotel_log_analyse_result set poi_in_name = %s, last_mod = now() where id = %s '''
    cur.executemany(sql, need_update)
    con.commit()
    cur.close()
    con.close()


@timeit
def main():
    f = gzip.open('/tmp/poi_in_name.gz', 'wb')
    cities = get_cities()
    #cities = ['tianjin_city', 'liaoyang']
    for city_code in cities:
        print '=' * 80, city_code
        pois, trading_areas, hotel_names = get_current_status(city_code)
        need_update = calc_need_update(pois, trading_areas, hotel_names, f)
        print 'pois: %s, trading_areas: %s, hotel_names: %s, need_update: %s' % (len(pois), len(trading_areas), len(hotel_names), len(need_update))
        if len(need_update) > 0:
            do_update(need_update)
    f.close()


if __name__ == '__main__':
    main()