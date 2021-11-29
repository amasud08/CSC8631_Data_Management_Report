#### Where are the majority of students situated?

head(all_enrolments)
# In looking at the data, there are two columns that can show student location, country and detected_country
# detected_country seems to have more populated data so using that for analysis


countries <- all_enrolments %>%
  select(detected_country) %>%        # selecting detected countries from all enrolments 
  count(detected_country) %>%         # Then getting the count of those countries
  mutate(detected_country = replace(detected_country, detected_country == "--", NA)) %>%     # saw that there were some unknowns so replacing them with NA
  drop_na() %>%                       # removing all NAs
  arrange(desc(n))                    # arranging the data in order of the most enrollments by country


# make a plot to show the country data 
ggplot(countries, aes(x=detected_country, y=n)) +                             # plotting x and y axis from countries data 
  geom_point(aes(colour=detected_country), size = 2, show.legend = FALSE) +   # setting the point colour + size + removing the legend 
  geom_text(aes(detected_country, label = detected_country), nudge_x = 3) +   # Adding the country code text to the plot, using nudge to keep point and text distinct 
  scale_y_log10() +                                                           # changing the scale to a log scale 
  theme_minimal() +
  theme(axis.ticks.x = element_blank(), axis.text.x = element_blank()) +      # removing the x axis labels as too congested
  labs(title = "Number of student enrolments by country",
       x = "Country", y = "Numbers of enrolment (log scale)") 
# made this plot but it shows nothing so want to add countries to the data to plot that differently


# Found a package called countrycode which can help add country and region to the data to see where exactly students are from
install.packages("countrycode")   # install the package 
library(countrycode)              # load the library

# manipulating the data to add country
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


# installing ggrepel to help with labeling on plots and points
install.packages("ggrepel")
library(ggrepel)


# Plotting the results to see if adding countries will make a difference
ggplot(countries_w_name, aes(x=country_name, y=n), group=region) +
  geom_point(aes(colour=region), size = 4) +
  geom_text_repel(aes(label=country_name)) +
  scale_y_log10() +
  theme_minimal() +
  theme(axis.ticks.x = element_blank(), axis.text.x = element_blank()) +
  labs(title = "Number of student enrolments by country",
       x = "Country", y = "Number of enrolment (log scale)") 
# This is still a bit messy and doesn't really show me anything so don't want to use this but will keep it as a point of reference


# Plotting a boxplot instead to see if that will show region more clearly
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


