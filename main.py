# https://iranzo.io/blog/2019/09/17/python-and-icalendar-ics-processing/



# coding: utf-8
from datetime import datetime
from datetime import timedelta

import requests
from icalendar import Calendar, Event, vDatetime
from pytz import timezone
import dateutil.rrule as rrule

format = "%Y-%m-%d %H:%M:%S %Z%z"

tz = timezone('Europe/Madrid')

calendars = []
#calendars.append(
#    'http://www.webcal.fi/cal.php?id=191&format=ics&wrn=1&wp=4&wf=53&color=%23FF3100&cntr=es&lang=es&rid=wc')

#calendars.append(
#    '~/Downloads/shiyiyin\@verily.com.ics')
date = (datetime.now() + timedelta(days=3))
datefor = "%s" % date.strftime('%Y-%m-%d')

g = open("../Downloads/shiyiyin@verily.com.ics",'rb')


# for calendar in calendars:
#    r = requests.get(calendar)
#    gcal = Calendar.from_ical(r.text)
gcal = Calendar.from_ical(g.read())

for event in gcal.walk('VEVENT'):
    if 'DTSTART' in event:
        try:
            dtstart = event['DTSTART'].dt.astimezone(timezone('US/Pacific'))
        except:
            dtstart = False
    if 'DTEND' in event:
        try:
            dtend = event['DTEND'].dt.astimezone(timezone('US/Pacific'))
        except:
            dtend = False
    if 'RRULE' in event:
        try:
            ruletext = event['RRULE'].to_ical().decode()
            rule = rrule.rrulestr(ruletext, dtstart=event['DTSTART'].dt)
            nextrule=rule.after(date.astimezone(timezone('US/Pacific')))
        except:
            nextrule = False
    else:
        nextrule = False

    if dtstart or dtend or nextrule:
        if datefor in "%s" % dtstart or datefor in "%s" % dtend or datefor in "%s" % nextrule:
            print("\n📅", event['summary'])

            if dtstart and dtend:
                lenght = (dtend - dtstart).total_seconds()/60
            else:
                lenght = False

            if not nextrule:
                if lenght:
                    print("🕑 start: %s for %s minutes" % (dtstart, lenght))
                    #print("🕑 start: %s for %s minutes" % (dtstart, dtend))
            else:
                print("🕑 start: %s for %s minutes" % (nextrule, lenght))
                print("🕑 start: %s for %s minutes" % (dtstart, dtend))
                # this part has overlap, if an event is in the future then it is not relavent to today
g.close()