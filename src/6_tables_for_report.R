# Tables used in the report using gt package 
# These tables can be found in Rmarkdown_Report

# Table 1 - Section 3 of the report
all_enrolments %>%
  select(fully_participated_at, gender, country, age_range, highest_education_level) %>%
  head() %>%
  gt() %>%       # use gt package to make a table
  tab_header(title = "Table 1: Sample of the enrolments dataset") %>%
  cols_label(fully_participated_at = "Fully Participated", gender = "Gender", country = "Country",
             age_range = "Age Range", highest_education_level = "Education Level")  #Change labels


# Table 2 - Section 4.2 of the report
countries %>%
  head(5) %>%
  gt() %>%       
  tab_header(title = "Table 2: Sample of number of Student Enrolments by Country") %>%
  cols_label(detected_country = "Detected Country", n = "Number of Students")


# Table 3 - Section 4.2 of the report
countries_w_name %>%
  head(5) %>%
  gt() %>%       
  tab_header(title = "Table 3: Sample of Student Enrolments by Country and Region") %>%
  cols_label(detected_country = "Detected Country", n = "Number of Students", 
             country_name = "Country", region = "Region") 

# Table 4 - Section 4.3 of the report
all_enrolments %>%
  count(age_range) %>%
  mutate(age_range = replace(age_range, age_range == "Unknown", NA)) %>%
  drop_na() %>%
  mutate(age_range = replace(age_range, age_range == ">65", "65+")) %>%
  mutate(Percentage = round((n / sum(n)) * 100, 2)) %>%
  gt() %>%       
  tab_header(title = "Table 4: Age range of students across all runs") %>%
  cols_label(age_range = "Age Range", n = "Number of Students", 
             Percentage = "Percentage %") 

# Table 5 - Section 4.3 of the report
all_enrolments %>%
  count(highest_education_level) %>%
  mutate(highest_education_level = replace(highest_education_level, highest_education_level == "Unknown", NA)) %>%
  drop_na() %>%
  mutate(Percentage = round((n / sum(n)) * 100, 2)) %>%
  gt() %>%       
  tab_header(title = "Table 5: Educational level of students across all runs") %>%
  cols_label(highest_education_level = "Education Level", n = "Number of Students", 
             Percentage = "Percentage %")  