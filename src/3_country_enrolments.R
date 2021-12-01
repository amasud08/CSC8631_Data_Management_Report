#### Where are the majority of students situated?

# Installed packages countrycode and grepel for this section. This is included in the pre-processing script.


head(all_enrolments)
# In looking at the data, there are two columns that can show student location, country and detected_country
# detected_country seems to have more populated data so using that for analysis


# The processing for the variable countries has been added to the munge file so you don't need to run this code. 
countries <- all_enrolments %>%
  select(detected_country) %>%        # selecting detected countries from all enrolments 
  count(detected_country) %>%         # Then getting the count of those countries
  mutate(detected_country = replace(detected_country, detected_country == "--", NA)) %>%     # saw that there were some unknowns so replacing them with NA
  drop_na() %>%                       # removing all NAs
  arrange(desc(n))                    # arranging the data in order of the most enrollments by country


# manipulating the data to add country name and region - Run code
countries_w_name <- countries %>%
  mutate(country_name = countrycode(sourcevar = detected_country,          # calling on the countrycode function and accessing the detected_country column
                                    origin = "iso2c",                           # taking the original 2 digit country code
                                    destination = "country.name",               # Outputting the country name
                                    custom_match = c("XK" = "Kosovo"))) %>%     # initial analysis showed that there was no match with Kosovo so adding that manually
  # Now doing the same for region
  mutate(region = countrycode(sourcevar = country_name,                    # Pairing the new country name column with countrycode's region
                              origin = "country.name",                     # taking the new country name column
                              destination = "region",                      # and pairing that with region
                              custom_match = c("Réunion" = "Sub-Saharan Africa"))) # initial analysis showed that there was no match with Réunion so adding that manually


# Plotting a boxplot tp show where the students are from by country and region 
country_boxplot <- ggplot(countries_w_name, aes(x=region, y=n, fill=region)) +
  geom_boxplot() +
  geom_point(position=position_jitterdodge(),alpha=0.3) +
  scale_y_log10() +
  theme_minimal() +
  labs(title = "Number of student enrolments by country and region, highlighting the most and least enrolled countries",
       x = "Region", y = "Number of enrolments (log scale)") 

# Too many labels for all the countries so want to only show the countries that have the most and least enrolments
head_tail = countries_w_name %>% {       # Pipe the data
  rbind(head(., 10), tail(., 10))        # bind the most and least through the head and tail, set the amount to 10 
} %>%
  group_by(country_name, n)              # group the bind by country name and numbers 

country_boxplot + geom_text_repel(data=head_tail, aes(label=country_name))   # layer the original plot with the text from the head_tail data 


