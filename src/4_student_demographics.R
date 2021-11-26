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
  geom_label(aes(x=gender, label=n)) +
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

