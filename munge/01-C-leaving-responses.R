# As the students have been decreasing, want to understand why that may be

# would like to quickly glance at the data just to see what it contains
glimpse(cyber.security.1_leaving.survey.responses)   # no data
glimpse(cyber.security.2_leaving.survey.responses)   # no data
glimpse(cyber.security.3_leaving.survey.responses)   # no data
glimpse(cyber.security.4_leaving.survey.responses)  
glimpse(cyber.security.5_leaving.survey.responses)
glimpse(cyber.security.6_leaving.survey.responses)
glimpse(cyber.security.7_leaving.survey.responses)


# Add another column to the data to differentiate between the different datasets for combining the data 
cyber.security.4_leaving.survey.responses$run = 4     
cyber.security.5_leaving.survey.responses$run = 5
cyber.security.6_leaving.survey.responses$run = 6
cyber.security.7_leaving.survey.responses$run = 7


# joining data together 
pasted_leaving_responses <- mget(paste0("cyber.security.", 4:7, "_leaving.survey.responses"))    # combine the data together
all_leaving_responses <- reduce(pasted_leaving_responses, full_join)                             # create a join between the data
leaving_responses <- inner_join(all_leaving_responses, all_enrolments, by = "learner_id")        # join the data with all enrollments to include data on when students enrolled
