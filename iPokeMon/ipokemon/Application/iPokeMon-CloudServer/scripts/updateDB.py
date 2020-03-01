#!/usr/bin/python
# vim: set fileencoding=utf-8 :

import sys, os
from subprocess import Popen, PIPE
import datetime

import redis
from hashlib import md5
import time

import itertools

RADIS_HOST = '127.0.0.1'
REDIS_PORT = 6379
REDIS_DB   = 8

# Region Data File Name
BASE_FOLDER_REGION = os.path.join(os.path.dirname(__file__), 'region_data/')
REGION_NEW = BASE_FOLDER_REGION + 'new_set_output'

# Wild PMs Data File Name
BASE_FOLDER = os.path.join(os.path.dirname(__file__),'wpm_data/')
MWD_OUTPUT  = BASE_FOLDER + 'wpm_output'
MWD_UPDATE  = BASE_FOLDER + 'wpm_update'
MWD_RM      = BASE_FOLDER + 'wpm_remove'

# Region
# re: is for real region DB
# nre: is for new region set that wait to be modified
class Region(object):
    def __init__(self):
        self.redis = redis.Redis(RADIS_HOST, REDIS_PORT, REDIS_DB)

    # get new regions' set
    def get_new_set(self, p_code_country):
        key = "nre:%s" % p_code_country
        if not self.redis.exists(key):
            print('-0- KEY NOT EXISTS')
            return
        print('### OUTPUTING NEW REGIONS...')
        # output data to file
        f = open(REGION_NEW , 'a')
        # output time
        f.write('# TIME - %s\n' % datetime.datetime.now().strftime('%m/%d/%Y - %H:%M'))
        # output data
        # format e.g.:
        #   CN=Zhejiang Province=Hangzhou City
        for new_region in self.redis.smembers(key):
            f.write('%s\n' % new_region)
        f.close()
        print('### OUTPUTING NEW REGIONS DONE')

    # add modified(add |code|) regions to DB
    # <re> e.g.:
    #   CN:ZJ:HZ=Zhejiang Province=Hangzhou City
    # re[:8] = CN:ZJ:HZ
    def add_regions(self):
        with open(REGION_NEW) as f:
            print('### SETTING REGION...')
            for re in f:
                re = re[:-1]
                if re[:1] == '#':
                    continue
                self.redis.set('re:%s' % re[:8], re)
                print('-1- SET - re:%s -> %s' % (re[:8], re))
            print('### SETTING REGION DONE')

    # clean new region set
    def clean_set(self, p_code_country):
        key = "nre:%s" % p_code_country
        if not self.redis.exists(key):
            print('-0- KEY NOT EXISTS')
        if self.redis.delete(key):
            print('-1- DELETE - %s' % key)



# Wild Pokemon
class WPM(object):
    def __init__(self):
        self.redis = redis.Redis(RADIS_HOST, REDIS_PORT, REDIS_DB)

    # do nothing, just output
    def output(self):
        with open(MWD_OUTPUT) as f:
            for KEY in f:
                print('%s | %s' % (str(KEY)[:-1], self.redis.get(str(KEY)[:-1])))

    # update the most widely distributed PMs
    # mwd: Most Widely Distributed
    # <country_code>:mwd
    def update(self):
        with open(MWD_UPDATE) as f:
            for KEY, VALUE in itertools.izip_longest(*[f] * 2):
                self.redis.set(str(KEY)[:-1], str(VALUE)[:-1])
                print('ADD: %s | %s' % (str(KEY)[:-1], self.redis.get(str(KEY)[:-1])))

    # remove
    def remove(self):
        with open(MWD_RM) as f:
            for KEY in f:
                self.redis.delete(str(KEY)[:-1])
                print('RM: %s | %s' % (str(KEY)[:-1], self.redis.get(str(KEY)[:-1])))

# RUN QUEUE
def run_queue():
    # Region
    re = Region()
    #re.add_regions()     # add modified (|code|) region data to DB, it'll overwrite original key-value pair
    #re.get_new_set('CN') # get new region set from DB
    #re.clean_set('CN')   # clean new region set in DB

    # Wild Pokemon
    wpm = WPM()
    wpm.update()
    #wpm.output()
    #wpm.remove()

if __name__ == '__main__':
    run_queue()
