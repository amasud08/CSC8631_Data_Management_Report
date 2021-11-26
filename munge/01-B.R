setwd("~/Desktop/CSC8631_Report")

library(ProjectTemplate)
load.project()

# Installing countrycode to add country and region to the data 
install.packages("countrycode")   # install the package 
library(countrycode)              # load the library

# installing ggrepel to help with labeling on plots and points
install.packages("ggrepel")
library(ggrepel)

# # had to install.packages("Rcpp") separately as was having problems with my laptop
# 
# # Get an idea of the enrolments data. Does each dataset have the same headings?
# glimpse(cyber.security.1_enrolments)
# glimpse(cyber.security.2_enrolments)
# glimpse(cyber.security.3_enrolments)
# glimpse(cyber.security.4_enrolments)
# glimpse(cyber.security.5_enrolments)
# glimpse(cyber.security.6_enrolments)
# glimpse(cyber.security.7_enrolments)
# 
# # Moved this data into the munge folder to assist with pre-processing
# # # Adding runs to the data to differentiate between the different datasets for when I combine
# # cyber.security.1_enrolments$run = 1
# # cyber.security.2_enrolments$run = 2
# # cyber.security.3_enrolments$run = 3
# # cyber.security.4_enrolments$run = 4
# # cyber.security.5_enrolments$run = 5
# # cyber.security.6_enrolments$run = 6
# # cyber.security.7_enrolments$run = 7
# # 
# # # joining data together 
# # pasted_enrolments <- mget(paste0("cyber.security.", 1:7, "_enrolments"))
# # all_enrolments <- reduce(pasted_enrolments, full_join)
# 
# 
# #### How many people enrolled per run?
# # Getting a count of number of enrollments, grouped by run 
# num_of_students_per_run <- all_enrolments %>%
#   group_by(run) %>%
#   count() 
# 
# # Plotting the data to see what it shows
# plot_num_of_students <- ggplot(num_of_students_per_run, aes(x=run, y=n)) +
#   geom_line() +
#   geom_point(colour="deeppink1") +
#   xlim(0, 7) +
#   ylim(0, 15000) +
#   theme_light() +
#   labs(title = "Number of student enrollments per run",
#        x = "Run", y = "Numbers of students") 
# 
# plot_num_of_students
# 
# ### This leads to questions as to why students are enrolling on the course less over time. 
# ### It's difficult to answer this with the data given. 
#  
# 
# #### Where are the majority of students situated?
# 
# head(all_enrolments)
# # In looking at the data, there are two columns that can show student location, country and detected_country
# # detected_country seems to have more populated data so using that for analysis
# 
# 
# countries <- all_enrolments %>%
#   select(detected_country) %>%        # selecting detected countries from all enrolments 
#   count(detected_country) %>%         # Then getting the count of those countries
#   mutate(detected_country = replace(detected_country, detected_country == "--", NA)) %>%     # saw that there were some unknowns so replacing them with NA
#   drop_na() %>%                       # removing all NAs
#   arrange(desc(n))                    # arranging the data in order of the most enrollments by country
# 
# 
# # make a plot to show the country data 
# ggplot(countries, aes(x=detected_country, y=n)) +                             # plotting x and y axis from countries data 
#   geom_point(aes(colour=detected_country), size = 2, show.legend = FALSE) +   # setting the point colour + size + removing the legend 
#   geom_text(aes(detected_country, label = detected_country), nudge_x = 3) +   # Adding the country code text to the plot, using nudge to keep point and text distinct 
#   scale_y_log10() +                                                           # changing the scale to a log scale 
#   theme_minimal() +
#   theme(axis.ticks.x = element_blank(), axis.text.x = element_blank()) +      # removing the x axis labels as too congested
#   labs(title = "Number of student enrolments by country",
#        x = "Country", y = "Numbers of enrolment (log scale)") 
# # made this plot but it shows nothing so want to add countries to the data to plot that differently
# 
# 
# # Found a package called countrycode which can help add country and region to the data to see where exactly students are from
# install.packages("countrycode")   # install the package 
# library(countrycode)              # load the library
# 
# # manipulating the data to add country
# countries_w_name <- countries %>%
#   mutate(country_name = countrycode(sourcevar = detected_country,          # calling on the countrycode function and accessing the detected_country column
#                                     origin = "iso2c",                           # taking the original 2 digit country code
#                                     destination = "country.name",               # Outputting the country name
#                                     custom_match = c("XK" = "Kosovo"))) %>%     # initial analysis showed that there was no match with Kosovo so adding that manually
#   # Now doing the same for region
#   mutate(region = countrycode(sourcevar = country_name,                    # Pairing the new country name column with countrycode's region
#                               origin = "country.name",                     # taking the new country name column
#                               destination = "region",                      # and pairing that with region
#                               custom_match = c("Réunion" = "Sub-Saharan Africa"))) # initial analysis showed that there was no match with Réunion so adding that manually
# 
# 
# # installing ggrepel to help with labeling on plots and points
# install.packages("ggrepel")
# library(ggrepel)
# 
# 
# # Plotting the results to see if adding countries will make a difference
# ggplot(countries_w_name, aes(x=country_name, y=n), group=region) +
#   geom_point(aes(colour=region), size = 4) +
#   geom_text_repel(aes(label=country_name)) +
#   scale_y_log10() +
#   theme_minimal() +
#   theme(axis.ticks.x = element_blank(), axis.text.x = element_blank()) +
#   labs(title = "Number of student enrolments by country",
#        x = "Country", y = "Number of enrolment (log scale)") 
# # This is still a bit messy and doesn't really show me anything
# 
# 
# # Plotting a boxplot instead to see if that will show region more clearly
# country_boxplot <- ggplot(countries_w_name, aes(x=region, y=n, fill=region)) +
#   geom_boxplot() +
#   geom_point(position=position_jitterdodge(),alpha=0.3) +
#   scale_y_log10() +
#   theme_minimal() +
#   labs(title = "Number of student enrolments by country and region, highlighting the most and least enrolled countries",
#        x = "Region", y = "Number of enrolments (log scale)") 
# 
# # Too many labels for all the countries so want to only show the countries that have the most and least enrolments
# head_tail = countries_w_name %>% {       # Pipe the data
#   rbind(head(., 10), tail(., 10))        # bind the most and least through the head and tail, set the amount to 10 
# } %>%
#   group_by(country_name, n)              # group the bind by country name and numbers 
# 
# country_boxplot + geom_text_repel(data=head_tail, aes(label=country_name))   # layer the original plot with the text from the head_tail data 
# 
# ### What are the demographics of students?
# # Want to remind myself of what to look for 
# all_enrolments %>%
#   glimpse()
# # Want to look at gender, age_range, highest_education_level and employment_status
# 
# 
# ## First looking at gender generally
# all_enrolments %>%
#   count(gender)
# 
# # Then want to look at gender per run
# student_gender_per_run <- all_enrolments %>%
#   group_by(run, gender) %>%
#   count()
# 
# # found lots of unknowns so want to remove data of unknown students
# student_gender <- student_gender_per_run %>%
#   mutate(gender = replace(gender, gender == "Unknown", NA)) %>%
#   drop_na()
# 
# # Now want to plot the data to see what that looks like
# student_gender_plot <- ggplot(student_gender, aes(x=gender, y=n)) +
#   geom_bar(aes(x=gender, fill=gender), stat='identity') +
#   scale_fill_manual("Gender", values = c("#E69F00", "#009E73", "#CC79A7", "#56B4E9")) +
#   facet_wrap(~run) +
#   geom_label(aes(x=gender, label=n)) +
#   labs(title="Number of students by gender per run ",
#        x="Gender", y="Number of students")
# 
# student_gender_plot
# 
# 
# ## Now want to look at age-range
# all_enrolments %>%
#   count(age_range) 
# 
# # Want to know how many students there are by age per run
# student_details_age <- all_enrolments %>%
#   group_by(run, age_range) %>%
#   count()
# 
# # found lots of unknowns want to remove data of unknown students
# student_age <- student_details_age %>%
#   mutate(age_range = replace(age_range, age_range == "Unknown", NA)) %>%
#   drop_na()
# 
# # plotting student age data
# student_age_plot <- ggplot(student_age, aes(x=age_range, y=n)) +
#   geom_bar(aes(x=age_range, fill=age_range), stat='identity') +
#   scale_fill_manual("Age", values = c("#E69F00", "#009E73", "#CC79A7", "#56B4E9", "#F0E442", "#0072B2", "#D55E00")) +
#   facet_wrap(~run) +
#   geom_label(aes(x=age_range, label=n)) +
#   labs(title="Age of students per run ",
#        x="Age", y="Number of students")
# 
# student_age_plot
# 
# 
# ## Now want to look at highest_education_level
# all_enrolments %>%
#   count(highest_education_level) 
# 
# # Want to know how many students there are by education level per run
# student_education_per_run <- all_enrolments %>%
#   group_by(run, highest_education_level) %>%
#   count()
# 
# # found lots of unknowns want to remove data of unknown students
# student_education <- student_education_per_run %>%
#   mutate(highest_education_level = replace(highest_education_level, highest_education_level == "Unknown", NA)) %>%
#   drop_na()
# 
# # plotting student education data
# student_education_plot <- ggplot(student_education, aes(x=highest_education_level, y=n)) +
#   geom_bar(aes(x=highest_education_level, fill=highest_education_level), stat='identity') +
#   scale_fill_manual("Education Level", values = c("#E69F00", "#009E73", "#CC79A7", "#56B4E9", "#F0E442", "#0072B2", "#D55E00", "#9999CC")) +
#   facet_wrap(~run) +
#   geom_label(aes(x=highest_education_level, label=n)) +
#   labs(title="Educational level of students per run ",
#        x="Education Level", y="Number of students") +
#   theme(axis.text.x = element_text(angle = 90)) 
# 
# student_education_plot 
# 
# 
# ## Now want to look at employment status
# all_enrolments %>%
#   count(employment_status) 
# 
# # Want to know how many students there are by employment status per run
# student_employment_per_run <- all_enrolments %>%
#   group_by(run, employment_status) %>%
#   count()
# 
# # found lots of unknowns want to remove data of unknown students
# student_employment <- student_employment_per_run %>%
#   mutate(employment_status = replace(employment_status, employment_status == "Unknown", NA)) %>%
#   drop_na() 
# 
# # not working and unemployed are the same thing so want to combine them.
# # Looking for work - you could be in a job and looking for work so don't want to combine them
# # Start by replacing converting "not_working" with "unemployed"
# student_employment1 <- student_employment %>%
#   mutate(employment_status = replace(employment_status, employment_status == "not_working", "unemployed"))
# 
# # Add the sums of unemployed together
# student_employment2 <- student_employment1 %>%
#   summarise(total = sum(n)) %>%
#   arrange(total)
# 
# # plotting student employment status data
# student_employment_plot <- ggplot(student_employment2, aes(x=employment_status, y=total)) +
#   geom_bar(aes(x=employment_status, fill=employment_status), stat='identity') +
#   scale_fill_manual("Employment Status", values = c("#E69F00", "#009E73", "#CC79A7", "#56B4E9", "#F0E442", "#0072B2", "#D55E00", "#9999CC")) +
#   facet_wrap(~run) +
#   geom_label(aes(x=employment_status, label=total)) +
#   labs(title="Employment status of students per run ",
#        x="Employment Status", y="Number of students") +
#   theme(axis.text.x = element_text(angle = 90)) 
# 
# student_employment_plot
# 
# 
# 
# 
# 
# 
# # What time of day did students typically participate in the course?
# date_time <- all_enrolments %>%
#   select(enrolled_at, run, detected_country) %>%
#   separate(enrolled_at, c("date", "time", "UTC"), sep=" ")
# 
# organise_times <- date_time %>%
#   group_by(run) %>%
#   arrange(run, time) %>%
#   mutate_if(is.character, as.factor)
# 
# plot(date_time)
# 
# ggplot(organise_times, aes(x=run, y=time)) +
#   geom_line()
# 
# install.packages("lubridate")
# library(lubridate)
# 
# date_time %>%
#   group_by(run) %>%
#   ggplot(aes(time)) +
#   geom_freqpoly(binwidth = 86400)
# 
# 
# 
# 
# 
