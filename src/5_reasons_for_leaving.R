# Want to start exploring the leaving reponses data 
# (This has been combined with the all_enrollments data - see code in munge file)

# exploring the combined datasets to see the full list of columns
head(leaving_responses)

# Creating a new dataframe with the original leaving_responses dataframe and just adding the enrolled_at column from the all_enrolments file
new_leaving_responses <- leaving_responses %>%
  select(learner_id, enrolled_at, left_at, leaving_reason, last_completed_step, last_completed_week_number, run)

new_leaving_responses %>%
  mutate(str_replace_all(leaving_reason, "â€™", "'"))

# looking at the reasons why students left
reasons <- new_leaving_responses %>%
  count(leaving_reason) %>%                                                             # counting the number of students that provided reasons for leaving
  mutate(str_replace_all(leaving_reason, "â€™", "'")) %>%                               # Replacing incorrect characters in the string
  rename(leaving_reasons = `str_replace_all(leaving_reason, "â\\200\\231", "'")`) %>%   # renaming the new column given to reason
  select(-leaving_reason)                                                               # removing the original leaving_reason column

reasons_plot <- ggplot(reasons, aes(x=reorder(leaving_reasons, -n), y=n)) +
  geom_bar(aes(fill=leaving_reasons), stat="identity", show.legend = FALSE) +
  coord_flip() +
  labs(title="Student reasons for leaving",
       x="Reasons for leaving", y="Number of students") 

reasons_plot

# looking at the timelines of when students enrolled between when they left