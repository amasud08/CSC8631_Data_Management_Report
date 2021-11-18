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
