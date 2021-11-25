#### How many people enrolled per run?
# Getting a count of number of enrollments, grouped by run 
num_of_students_per_run <- all_enrolments %>%
  group_by(run) %>%
  count() 

# Plotting the data to see what it shows
plot_num_of_students <- ggplot(num_of_students_per_run, aes(x=run, y=n)) +
  geom_line() +                        # including a line to highlight 
  geom_point(colour="deeppink1", size=3) +     # changing the colour of the points 
  xlim(0, 7) +                         # setting the limits of the x axis
  ylim(0, 15000) +                     # setting the limits of the y axis
  theme_light() +                      # want a white background 
  labs(title = "Number of student enrolments per run",
       x = "Run", y = "Number of students") 

plot_num_of_students

### This leads to questions as to why students are enrolling on the course less over time. 
### It's difficult to answer this with the data given. 