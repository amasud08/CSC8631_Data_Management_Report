#### Where are the majority of students situated?

countries <- all_enrolments %>%
  select(detected_country) %>%        # selecting detected countries from all enrolments 
  count(detected_country) %>%         # Then getting the count of those countries
  mutate(detected_country = replace(detected_country, detected_country == "--", NA)) %>%     # saw that there were some unknowns so replacing them with NA
  drop_na() %>%                       # removing all NAs
  arrange(desc(n))                    # arranging the data in order of the most enrollments by country

