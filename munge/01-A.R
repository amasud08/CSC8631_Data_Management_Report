setwd("~/Desktop/CSC8631_Report")

library(ProjectTemplate)
load.project()

# had to install.packages("Rcpp") separately 

#get an idea of the enrolments data
glimpse(cyber.security.1_enrolments)
glimpse(cyber.security.2_enrolments)
glimpse(cyber.security.3_enrolments)
glimpse(cyber.security.4_enrolments)
glimpse(cyber.security.5_enrolments)
glimpse(cyber.security.6_enrolments)
glimpse(cyber.security.7_enrolments)

# Adding runs to the data to differentiate between the different datasets for when I combine
cyber.security.1_enrolments$run = 1
cyber.security.2_enrolments$run = 2
cyber.security.3_enrolments$run = 3
cyber.security.4_enrolments$run = 4
cyber.security.5_enrolments$run = 5
cyber.security.6_enrolments$run = 6
cyber.security.7_enrolments$run = 7

# joining data together 
pasted_enrolments <- mget(paste0("cyber.security.", 1:7, "_enrolments"))
all_enrolments <- reduce(pasted_enrolments, full_join)

# How many people enrolled per run?
num_of_students_per_run <- all_enrolments %>%
  group_by(run) %>%
  count() 

ggplot(num_of_students_per_run, aes(x=run, y=n)) +
  geom_line() +
  geom_point() +
  theme_light() +
  labs(title = "Number of student enrollments by session",
       x = "Session", y = "Numbers of students")

# Where are the majority of students situated?
countries <- all_enrolments %>%
  mutate_if(is.factor, as.character) %>%
  select(detected_country) %>%
  count(detected_country) %>%
  arrange(desc(n))

countries %>% 
  select(n) %>%
  max()
which.max(countries$n == 11663)   # answer was GB
# countries[65, ]

# for country list: 
# https://www.datahub.io/core/country-list#r


### What's the percentage of students that give their details during enrollment?
student_details_age <- all_enrolments %>%
  group_by(run, age_range) %>%
  count()

# removing unknown students data
student_age_NA <- student_details_age %>%
  mutate(age_range = replace(age_range, age_range == "Unknown", NA)) %>%
  drop_na()

ggplot(student_age_NA, aes(x=age_range, y=n)) +
  geom_point(aes(colour=run)) +
  scale_colour_manual("blue", "red", "pink", "purple", "orange", "green", "yellow") +
  theme_minimal()

# scale_x_continuous 

# What time of day did students typically participate in the course?
date_time <- all_enrolments %>%
  select(enrolled_at, run, detected_country) %>%
  separate(enrolled_at, c("date", "time", "UTC"), sep=" ")

organise_times <- date_time %>%
  group_by(run) %>%
  arrange(run, time) %>%
  mutate_if(is.character, as.factor)

plot(date_time)

ggplot(organise_times, aes(x=run, y=time)) +
  geom_line()

install.packages("lubridate")
library(lubridate)

date_time %>%
  group_by(run) %>%
  ggplot(aes(time)) +
  geom_freqpoly(binwidth = 86400)





