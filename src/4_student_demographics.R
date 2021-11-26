### What are the demographics of students?
# Want to remind myself of what to look for
all_enrolments %>%
  glimpse()
# Want to look at gender, age_range, highest_education_level and employment_status


## First looking at gender generally
all_enrolments %>%
  count(gender)

# Then want to look at gender per run to see how different that looks
student_gender_per_run <- all_enrolments %>%
  group_by(run, gender) %>%
  count()

# found lots of unknowns so want to remove data of unknown students
student_gender <- student_gender_per_run %>%
  mutate(gender = replace(gender, gender == "Unknown", NA)) %>%
  drop_na()

# Now want to plot the data to see what that looks like
student_gender_plot <- ggplot(student_gender, aes(x=gender, y=n)) +
  geom_bar(aes(x=gender, fill=gender), stat='identity') +
  scale_fill_manual("Gender", values = c("#9999CC", "#E69F00", "#009E73", "#0072B2")) +   # want to set the colour so used a colour blind friendly colour pallete
  facet_wrap(~run) +                                                                      # want to display plots per run 
  geom_label(aes(x=gender, label=n)) +                                                    # want to add a label of totals to the bar chart
  labs(title="Gender of students per run ",
       x="Gender", y="Number of students")

student_gender_plot


## Now want to look at age-range
all_enrolments %>%
  count(age_range)

# Want to know how many students there are by age per run
student_details_age <- all_enrolments %>%
  group_by(run, age_range) %>%
  count()

# found lots of unknowns want to remove data of unknown students
student_age <- student_details_age %>%
  mutate(age_range = replace(age_range, age_range == "Unknown", NA)) %>%
  drop_na() %>%
  mutate(age_range = replace(age_range, age_range == ">65", "65+"))    # want to reorder >65 on the plot so age is in order

# plotting student age data
student_age_plot <- ggplot(student_age, aes(x=age_range, y=n)) +
  geom_bar(aes(x=age_range, fill=age_range), stat='identity') +
  scale_fill_manual("Age", values = c("#9999CC", "#CC79A7", "#009E73", "#56B4E9", "#F0E442", "#E69F00", "#D55E00")) +
  facet_wrap(~run) +
  geom_label(aes(x=age_range, label=n)) +
  labs(title="Age of students per run ",
       x="Age", y="Number of students")

student_age_plot



## Now want to look at highest_education_level
all_enrolments %>%
  count(highest_education_level)

# Want to know how many students there are by education level per run
student_education_per_run <- all_enrolments %>%
  group_by(run, highest_education_level) %>%
  count()

# found lots of unknowns want to remove data of unknown students
student_education <- student_education_per_run %>%
  mutate(highest_education_level = replace(highest_education_level, highest_education_level == "Unknown", NA)) %>%
  drop_na() 

# plotting student education data
student_education_plot <- ggplot(student_education, aes(x=highest_education_level, y=n)) +
  geom_bar(aes(x=highest_education_level, fill=highest_education_level), stat='identity') +
  scale_fill_manual("Education Level", values = c("#9999CC", "#CC79A7", "#009E73", "#56B4E9", "#F0E442", "#E69F00", "#D55E00", "#0072B2")) +
  facet_wrap(~run) +
  geom_label(aes(x=highest_education_level, label=n)) +
  labs(title="Educational level of students per run ",
       x="Education Level", y="Number of students") +
  theme(axis.text.x = element_text(angle = 90))            # want the text to be vertical to fit neatly

student_education_plot


## Now want to look at employment status
all_enrolments %>%
  count(employment_status)

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

# plotting student employment status data
student_employment_plot <- ggplot(student_employment2, aes(x=employment_status, y=total)) +
  geom_bar(aes(x=employment_status, fill=employment_status), stat='identity') +
  scale_fill_manual("Employment Status", values = c("#9999CC", "#CC79A7", "#009E73", "#56B4E9", "#F0E442", "#E69F00", "#D55E00", "#0072B2")) +
  facet_wrap(~run) +
  geom_label(aes(x=employment_status, label=total)) +
  labs(title="Employment status of students per run ",
       x="Employment Status", y="Number of students") +
  theme(axis.text.x = element_text(angle = 90))

student_employment_plot