#https://www.stat.berkeley.edu/~s133/dates.html

# install.packages("ical")
library(ical)
library(dplyr)
library(tidyverse)
library(lubridate, warn.conflicts = FALSE)


############################################
# step 1, importing calendar and obtain blocked timeslots
a<-ical_parse_df("Downloads/shiyiyin@verily.com.ics")

# get time booked for the next 10 days
# ingnoring events that is longer than 2 days
useful<-a%>%
filter(difftime(dtend,Sys.time(),units='days')<10)%>%
filter(difftime(dtend,Sys.time(),units='days')>0)%>%
filter(difftime(dtend,dtstart,units='days')<2)%>%
select(dtstart, dtend)


useful_interval


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
workweek_interval




#####################
# doing the math
# https://lubridate.tidyverse.org/reference/interval.html
setdiff(workweek_interval, useful_interval)


########################
# output the time interval

#################################
#as.POSIXct(paste(workweek, "9:00:00"),tz="EST")
# for target time zone working hours feature


format(useful,usetz=T)


format(a$start,usetz=TRUE)
