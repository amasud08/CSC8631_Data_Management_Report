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

# Tried this plot initially but it didn't really show anything
ggplot(countries, aes(x=detected_country, y=n)) +
  geom_point(aes(colour=detected_country), size = 2, show.legend = FALSE) +    # Set the colour as the countries
  geom_text(aes(detected_country, label = detected_country), nudge_x = 3) +    # moved the text out of the way of the points
  scale_y_log10() +                                                            # Set the scale to a log scale to ensure 
  theme_minimal() +                                                            # Made the background lighter
  theme(axis.ticks.x = element_blank(), axis.text.x = element_blank()) +       # removed the x axis labels as there were too many 
  labs(title = "Initial Plot: Number of student enrolments by country",
       x = "Country", y = "Numbers of enrolment (log scale)") 


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


# Decided to try a boxplot instead to show where the students are from by country and region 
country_boxplot <- ggplot(countries_w_name, aes(x=region, y=n, fill=region)) +
  geom_boxplot() +                                                               # tried a boxplot this time
  geom_point(position=position_jitterdodge(),alpha=0.3) +                        # including the points, lightened them and ensured their positioning is good
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

# Save the plot as an image
ggsave(filename = 'graphs/2_enrolments_by_region.png', dpi=600, width=4.5, height=3, units="in", scale=3) 
