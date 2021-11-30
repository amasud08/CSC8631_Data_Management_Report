### What are the demographics of students?

## Gender
# Want to look at gender per run to see how different that looks
student_gender_per_run <- all_enrolments %>%
  group_by(run, gender) %>%
  count()

# found lots of unknowns so want to remove data of unknown students
student_gender <- student_gender_per_run %>%
  mutate(gender = replace(gender, gender == "Unknown", NA)) %>%
  drop_na()


## Age Range
# Want to know how many students there are by age per run
student_details_age <- all_enrolments %>%
  group_by(run, age_range) %>%
  count()

# found lots of unknowns want to remove data of unknown students
student_age <- student_details_age %>%
  mutate(age_range = replace(age_range, age_range == "Unknown", NA)) %>%
  drop_na() %>%
  mutate(age_range = replace(age_range, age_range == ">65", "65+"))    # want to reorder >65 on the plot so age is in order


## Highest Education Level
# Want to know how many students there are by education level per run
student_education_per_run <- all_enrolments %>%
  group_by(run, highest_education_level) %>%
  count()

# found lots of unknowns want to remove data of unknown students
student_education <- student_education_per_run %>%
  mutate(highest_education_level = replace(highest_education_level, highest_education_level == "Unknown", NA)) %>%
  drop_na() 


## Employment Status
# Want to know how many students there are by employment status per run
student_employment_per_run <- all_enrolments %>%
  group_by(run, employment_status) %>%
  count()

# found lots of unknowns want to remove data of unknown students
student_employment <- student_employment_per_run %>%
  mutate(employment_status = replace(employment_status, employment_status == "Unknown", NA)) %>%
  drop_na()

# not working and unemployed are the same thing so want to combine them.
# Looking for work - you could be in a job and looking for work so don't want to combine that 
# Start by replacing converting "not_working" with "unemployed"
student_employment1 <- student_employment %>%
  mutate(employment_status = replace(employment_status, employment_status == "not_working", "unemployed"))

# Add the sums of unemployed together so that it becomes one column
student_employment2 <- student_employment1 %>%
  summarise(total = sum(n)) %>%
  arrange(total)