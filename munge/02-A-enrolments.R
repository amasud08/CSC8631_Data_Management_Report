#### How many people enrolled per run?
# Getting a count of number of enrollments, grouped by run 
num_of_students_per_run <- all_enrolments %>%
  group_by(run) %>%
  count()