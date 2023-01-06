#https://www.stat.berkeley.edu/~s133/dates.html

# install.packages("ical")
library(ical)
library(dplyr)
library(tidyverse)
library(lubridate, warn.conflicts = FALSE)


############################################
# step 1, importing calendar and obtain blocked timeslots
a<-ical_parse_df("~/Downloads/shiyiyin@verily.com.ics")

# get time booked for the next 10 days
# ingnoring events that is longer than 2 days
useful<-a%>%
filter(difftime(dtend,Sys.time(),units='days')<10)%>%
filter(difftime(dtend,Sys.time(),units='days')>0)%>%
filter(difftime(dtend,dtstart,units='days')<2)%>%
select(dtstart, dtend)

######
# very tricky dealing with rrules
####
# filter based on dtstart, if the dtstart is far in the future, more than 11 days, then no need for calculation.
# filter based on rrule_until, if the rrule_until is before today then no need for calculation. if NA then need to calculate
# for rrule_freq=="MONTHLY", adding entry until the rrule_until, is that is NA, then until 11 days into the future
# rrule_freq rrule_interval rrule_byday rrule_until rrule_wkst 


useful_interval<-interval(useful$dtstart, useful$dtend)


##############################################
# step 2
# setup workday from 9-5pm local time
#format(workweek,'%A',usetz=TRUE)

future<-seq(as.Date(Sys.time()),by='days',length=10)
#future<-seq(Sys.time(),by='days',length=10)[-1]
workweek<-future[!(format(future,'%A')%in%c("Saturday","Sunday"))]
# a different function achieve the same thing
#weekdays(future)%in%c("Saturday","Sunday")
start<-as.POSIXct(paste(workweek, "9:00:00"))
end<-as.POSIXct(paste(workweek, "17:00:00"))
workweek_interval<-interval(start, end)




#####################
# step 3 
# doing the math
# https://lubridate.tidyverse.org/reference/interval.html
# idea right now
# use the time point involved to make all possible time intervals, and take out the shorts ones, then take out the ones that intersect with the time blocked ones
lubridate::setdiff(workweek_interval[2], useful_interval[1])
intersect(workweek_interval[2], useful_interval[1])
setdiff(workweek_interval[5], useful_interval[c(2,5)])

union(workweek_interval[2], useful_interval[1])
setequal(workweek_interval[2], useful_interval[1])

lubridate::setdiff(useful_interval[1],workweek_interval[2])
int_overlaps(useful_interval[1],workweek_interval[2])

########################
# output the time interval

#################################
#as.POSIXct(paste(workweek, "9:00:00"),tz="EST")
# for target time zone working hours feature


format(useful,usetz=T)


format(a$start,usetz=TRUE)


setdiff(1:5, 1:8)
setdiff(1:8, 3:5)
