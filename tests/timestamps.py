#!/usr/bin/python
# timestamps.py within https://github.com/wilsonmar/mac-install

import pytz, time
from datetime import datetime, tzinfo, timedelta
from random import randint

def iso8601_utc():
    class simple_utc(tzinfo):
        def tzname(self,**kwargs):
            return "UTC"
        def utcoffset(self, dt):
            return timedelta(0)
    return datetime.utcnow().replace(tzinfo=simple_utc()).isoformat()
    #print(iso8601_utc()+"   = ISO8601 time at +00:00 UTC (Zulu time), with microseconds")

def iso8601_local():
    class local_tz(tzinfo):
        def utcoffset(self, dt):
            ts = time.time()
            offset_in_seconds = (datetime.fromtimestamp(ts) - datetime.utcfromtimestamp(ts)).total_seconds()
            return timedelta(seconds=offset_in_seconds)
    return datetime.now().replace(microsecond=randint(0, 999999)).replace(tzinfo=local_tz()).isoformat()
    # print(iso8601_local()+" = ISO8601 time at local time zone offset, with random microseconds")

print(iso8601_utc()+"   = ISO8601 time at +00:00 UTC (Zulu time), with microseconds")
print(iso8601_local()+" = ISO8601 time at local time zone offset, with random microseconds")
