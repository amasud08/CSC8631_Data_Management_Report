setwd("~/Desktop/CSC8631_Report")

# Add another column to the data to differentiate between the different datasets 
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