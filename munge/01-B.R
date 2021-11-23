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

plot_num_of_students <- ggplot(num_of_students_per_run, aes(x=run, y=n)) +
  geom_line() +
  geom_point(colour="red") +
  xlim(0, 7) +
  ylim(0, 15000) +
  theme_light() +
  labs(title = "Number of student enrollments by session",
       x = "Session", y = "Numbers of students") 

# Trying to set the limits of t
# plot_num_of_students + 
#   scale_x_continuous(limits=c(0, 7)) +
#   scale_y_continuous(limits=c(0, 1200)) 

### This leads to questions as to why students are enrolling on the course less over time. 
### What else can I consider when thinking about my analysis? Can speculate a little?
### Maybe can consider the leaving surveys to think about when exactly students are leaving the course. 

# Where are the majority of students situated?
countries <- all_enrolments %>%
  # mutate_if(is.factor, as.character) %>%
  select(detected_country) %>%
  count(detected_country) %>%
  mutate(detected_country = replace(detected_country, detected_country == "--", NA)) %>%
  drop_na() %>%
  arrange(desc(n))

ggplot(countries, aes(x=detected_country, y=n)) +
  geom_point(aes(colour=detected_country), size = 2, show.legend = FALSE) +
  geom_text(aes(detected_country, label = detected_country), nudge_x = 3) +
  scale_y_log10() +
  theme_minimal() +
  theme(axis.ticks.x = element_blank(), axis.text.x = element_blank()) +
  labs(title = "Number of student enrolments by country",
       x = "Country", y = "Numbers of enrolment (log scale)") 


# countries %>% 
#   select(n) %>%
#   max()
# which.max(countries$n == 11663)   # answer was GB
# # countries[65, ]


# installing countrycode to see what countries students have enrolled from 
install.packages("countrycode")
library(countrycode)

countries_w_name <- countries %>%
  mutate(country_name = countrycode(sourcevar = detected_country,
                               origin = "iso2c",
                               destination = "country.name",
                               custom_match = c("XK" = "Kosovo"))) %>%
  mutate(region = countrycode(sourcevar = country_name,
                                    origin = "country.name",
                                    destination = "region",
                                    custom_match = c("Réunion" = "Sub-Saharan Africa"))) 

# installing ggrepel to help with labelling on plots and points
install.packages("ggrepel")
library(ggrepel)

# Plotting countries and regions to see if that'll make a difference
ggplot(countries_w_name, aes(x=country_name, y=n), group=region) +
  geom_point(aes(colour=region), size = 4) +
  # geom_text(aes(country_name, label = country_name), nudge_x = 3) +
  geom_text_repel(aes(label=country_name)) +
  scale_y_log10() +
  theme_minimal() +
  theme(axis.ticks.x = element_blank(), axis.text.x = element_blank()) +
  labs(title = "Number of student enrolments by country",
       x = "Country", y = "Numbers of enrolment (log scale)") 

# Trying to change axes to see if that would be more relevant
ggplot(countries_w_name, aes(x=n, y=country_name), group=region) +
  geom_point(aes(colour=region), size = 4) +
  # geom_text(aes(country_name, label = country_name), nudge_x = 3) +
  geom_text_repel(aes(label=country_name)) +
  scale_x_log10() +
  theme_minimal() +
  theme(axis.ticks.y = element_blank(), axis.text.y = element_blank()) +
  labs(title = "Number of student enrolments by country",
       x = "Country", y = "Numbers of enrolment (log scale)") 

# Then trying it as a boxplot
ggplot(countries_w_name, aes(x=region, y=n, fill=region)) +
  geom_boxplot() +
  geom_point(position=position_jitterdodge(),alpha=0.3) +
  scale_y_log10() +
  geom_text_repel(aes(label=country_name)) +
  theme_minimal()


###showing the countries over multiple runs to see if there's any difference
countries_1 <- all_enrolments %>%
    group_by(run, detected_country) %>%
    count(detected_country) %>%
    mutate(detected_country = replace(detected_country, detected_country == "--", NA)) %>%
    drop_na() %>%
    mutate(country_name = countrycode(sourcevar = detected_country,
                                    origin = "iso2c",
                                    destination = "country.name",
                                    custom_match = c("XK" = "Kosovo"))) %>%
    mutate(region = countrycode(sourcevar = country_name,
                              origin = "country.name",
                              destination = "region",
                              custom_match = c("Réunion" = "Sub-Saharan Africa")))

ggplot(countries_1, aes(x=region, y=n, fill=region)) +
  geom_boxplot() +
  geom_jitter() +
  scale_y_log10() +
  theme(axis.ticks.x = element_blank(), axis.text.x = element_blank()) +
  facet_wrap(~run)



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





