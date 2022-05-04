# install packages
install.packages("tidyverse")
install.packages("lubridate")
install.packages("ggplot2")

# load packages
library(tidyverse) # data import and wrangling
library(lubridate) # date functions
library(ggplot2) # visualizations
getwd()


# load files into dataframes
df1 <- read_csv("data/202104-divvy-tripdata.csv")
df2 <- read_csv("data/202105-divvy-tripdata.csv")
df3 <- read_csv("data/202106-divvy-tripdata.csv")
df4 <- read_csv("data/202107-divvy-tripdata.csv")
df5 <- read_csv("data/202108-divvy-tripdata.csv")
df6 <- read_csv("data/202109-divvy-tripdata.csv")
df7 <- read_csv("data/202110-divvy-tripdata.csv")
df8 <- read_csv("data/202111-divvy-tripdata.csv")
df9 <- read_csv("data/202112-divvy-tripdata.csv")
df10 <- read_csv("data/202201-divvy-tripdata.csv")
df11 <- read_csv("data/202202-divvy-tripdata.csv")
df12 <- read_csv("data/202203-divvy-tripdata.csv")


# combine all frames into one
all_trips <- rbind(df1, df2, df3, df4, df5, df6, df7, df8, df9, df10, df11, df12)
all_trips1 <- na.omit(all_trips) # omit NA values


# check for duplicates in ride_id
ride_id <- as.data.frame(all_trips1$ride_id)  # create ride_id as data frame
sum(duplicated(ride_id))   # sum number of duplicated values in ride_id


# drop ride_id, latitudes and longitudes
relevant_data <- subset(all_trips1, select = -c(ride_id, start_lat, start_lng, end_lat, end_lng))


# add duration of bike trip
relevant_data$duration <- as.duration(c(relevant_data$ended_at - relevant_data$started_at)) 


# remove trips under 30 seconds that start and end same location (customer changed mind or got different bike perhaps?)
relevant_data_1 <- relevant_data[relevant_data$duration > 30 & relevant_data$start_station_id != relevant_data$end_station_id, ]


# check if worked
relevant_data_1 %>% filter(duration < 30 & start_station_id == end_station_id)


# remove negative trip times and trips longer than 1 day as divvy policy counts as stolen
relevant_data_2 <- relevant_data_1 %>%
  filter(duration > 0)
relevant_data_3 <- relevant_data_2 %>%
  filter(duration < 86400)


# add month and day of week 
relevant_data_3$date <- as.Date(relevant_data_3$started_at)
relevant_data_3$month <- format(as.Date(relevant_data_3$date), "%m") # month
relevant_data_3$day <- format(as.Date(relevant_data_3$date), "%A") # day of week


# explore unique values to check if anything unusual or incorrect exists
relevant_data_3 %>% count(rideable_type)
relevant_data_3 %>% count(start_station_name)
relevant_data_3 %>% count(start_station_id)
relevant_data_3 %>% count(end_station_name)
relevant_data_3 %>% count(end_station_id)
relevant_data_3 %>% count(member_casual)
relevant_data_3 %>% count(month)
relevant_data_3 %>% count(day)


# summary statistics of duration by membership type
aggregate(relevant_data_4$duration ~ relevant_data_4$member_casual, FUN = summary)


# summary statistics of duration by membership type AND day of the week
aggregate(relevant_data_4$duration ~ relevant_data_4$member_casual + relevant_data_4$day, FUN = summary)


# basic visualizations
# visualize casual vs member average duration by day
relevant_data_4 %>% 
  group_by(member_casual, day) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(duration)) %>%
  arrange(member_casual, day) %>%
  ggplot(aes(x = day, y = average_duration, fill = member_casual)) +
  geom_col(position="dodge")


# visualize casual vs member number of trips by day
relevant_data_4 %>% 
  group_by(member_casual, day) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(duration)) %>%
  arrange(member_casual, day) %>%
  ggplot(aes(x = day, y = number_of_rides, fill = member_casual)) +
  geom_col(position="dodge")


# visualize casual vs member number of trips by month
relevant_data_4 %>% 
  group_by(member_casual, month) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(duration)) %>%
  arrange(member_casual, month) %>%
  ggplot(aes(x = month, y = number_of_rides, fill = member_casual)) +
  geom_col(position="dodge")


# visualize casual vs member average trip duration by month
relevant_data_4 %>% 
  group_by(member_casual, month) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(duration)) %>%
  arrange(member_casual, month) %>%
  ggplot(aes(x = month, y = average_duration, fill = member_casual)) +
  geom_col(position="dodge")


# write cleaned data to csv to import to Tableau
write.csv(relevant_data_4, "C:/Users/cambe/OneDrive/Documents/Coursera Project/Cyclistic_proj\\Bike_data.csv")






