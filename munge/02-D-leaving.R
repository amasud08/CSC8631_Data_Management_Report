# Creating a new dataframe with the original leaving_responses dataframe and just adding the enrolled_at column from the all_enrolments file
new_leaving_responses <- leaving_responses %>%
  select(learner_id, enrolled_at, left_at, leaving_reason, last_completed_step, last_completed_week_number, run)


# looking at the reasons why students left
reasons <- new_leaving_responses %>%
  count(leaving_reason) %>%                                       # counting the number of students that provided reasons for leaving
  mutate(str_replace_all(leaving_reason, "â???T", "'"))             # Replacing incorrect characters in the string
# You may have errors with replacing the string depending on your system set-up
# You can check what the correct string replacement should be by entering the following code: head(reasons)
# Then check the responses in the leaving_reasons column

reasons <- reasons %>%                              
  rename(leaving_reasons = `str_replace_all(leaving_reason, "â\\200\\231", "'")`) %>%   # renaming the new column given to reason - DOUBLE CHECK YOUR COLUMN NAME
  select(-leaving_reason)                                                               # removing the original leaving_reason column
