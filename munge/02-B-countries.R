#### Where are the majority of students situated?

countries <- all_enrolments %>%
  select(detected_country) %>%        # selecting detected countries from all enrolments 
  count(detected_country) %>%         # Then getting the count of those countries
  mutate(detected_country = replace(detected_country, detected_country == "--", NA)) %>%     # saw that there were some unknowns so replacing them with NA
  drop_na() %>%                       # removing all NAs
  arrange(desc(n))                    # arranging the data in order of the most enrollments by country


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