## asks 5 questions about this dataset
data("flights")

# load library

library(nycflights13)
library(dplyr)
library(tidyverse)
library(lubridate)


## Q1. Flights carrier for Year 2013
total_flights <- flights %>%
  filter(year == 2013) %>%
  count(carrier) %>%
  arrange(desc(n)) %>%
  left_join(airlines)

total_flights <- total_flights %>% 
  select(name, n)


## Q2. Top origin EWR for year 2013
origin_ewr <- flights %>%
  filter(origin == "EWR") %>% 
  count(carrier) %>%
  arrange(desc(n)) %>% 
  left_join(airlines)

origin_ewr <- origin_ewr %>% 
  select(name, n)

## Q3. Top Destination for Year 2013
top_dest <- flights %>%
  count(dest) %>%
  arrange(desc(n)) %>%
  inner_join(airports, by = c("dest" = "faa")) %>%
  head(10)

top_dest <- top_dest %>% 
  select(name, n)


## Q4. destination low flights
low_dest <- flights %>%
  count(dest) %>%
  arrange(desc(n)) %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  tail(10)

low_dest <- low_dest %>% 
  select(name, n)


## Q5. Max flights in one day

max_day <- flights %>%
  filter(origin == "EWR" & dest == "ORD") %>% 
  select(year, month, day, carrier) %>%
  mutate(dep_date = ymd(paste(year, month, day))) %>% 
  group_by(dep_date) %>% 
  count(carrier) %>%
  arrange(desc(n)) %>% 
  left_join(airlines) %>%
  head()

max_day <- max_day %>% 
  select(name, dep_date, n)
