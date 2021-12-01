# Creating a new dataframe with the original leaving_responses dataframe and just adding the enrolled_at column from the all_enrolments file
new_leaving_responses <- leaving_responses %>%
  select(learner_id, enrolled_at, left_at, leaving_reason, last_completed_step, last_completed_week_number, run)



