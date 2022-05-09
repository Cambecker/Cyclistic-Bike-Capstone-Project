# Cyclistic Case Study: Converting Casual Customers to Annual Members
## Scenario
This project forms the final module of the Google Data Analytics Professional Certificate, the goal of which is to complete a capstone project demonstrating the skills taught throughout the course. Cyclistic is a fictional bike-share company based on an existing bike-share company in Chicago. For the purpose of the project I am a Junior Data Analyst tasked with exploring the differences between casual customers (single-ride or full-day passes) and annual members, to provide insights and recommendations on how to convert the former to the latter, as annual members are more profitable to the business.

## Process
### Data
This case study uses the last 12 months of Cyclistic's bike trip data located [here](https://divvy-tripdata.s3.amazonaws.com/index.html), covering from April 2021 to March 2022. The data has been made available by Motivate International Inc. under this [licence](https://www.divvybikes.com/data-license-agreement). I used RStudio to prepare the data as this was the language taught in the Google Data Analytics Professional Certificate and I wanted to improve my R skills.

#### Outline of data preparation ([Script](Cyclistic.R))
- Load each month into dataframe.
- Combine all 12 dataframes into one.
- Omit NA values.
- Check for duplicate entries using ride_id column.
  - There was no duplicates, thus no follow up to remove.
- Drop ride_id, start_lat, start_lng, end_lat, end_lng.
  - Latitude and longitude columb had a significant amount of entries to only 2 decimal points making them an inaccurate measure in terms of geographical position within a city. ride_id no longer required as we know there were no duplicates, so each row is a unique ride.
- Add a column for duration of trip using started_at and ended_at columns.
- Remove trips that with a duration less than 30 seconds AND that ended at the same location they started.
  - It was expected that these trips were customers that changed their mind or picked a bike that may be damaged or faulty and then put it back and swapped it for another, creating a new trip. The choice for 30 seconds was arbirtray and there might be a better duration to use as a cut-off in this case.
- Removed negative trips times and trips longer than 86400 seconds (1 day).
  - Trips longer than 1 day excluded as the company Cyclistic is based on states that trips longer than 1 day will count as a stolen or lost bike.
- Added month and day of week columns using started-at column.
  - This will allow us to easily see how trips differ by day and month.
- View summary statistics.
- Create basic visualisations.
  - These were basically just drafts for what I intended to visualise in Tableau.
- Write cleaned data to a csv to import to Tableau.

### Visualisations
To visualise the cleaned data I opted to use Tableau for the same reasons I opted to prepare the data with RStudio. It is the visualisation software taught in the Google Data Analytics Professional Certificate and I wanted to improve my skills with that software. Visualisations can be found [here](https://public.tableau.com/app/profile/cameron.becker/viz/CyclisticCaseStudy_16520656309490/Story1).

## Conclusion
### Findings
- Total trips are higher during and towards the warmer months peaking in July and August, and lower towards the colder months, lowest in January and February.
- More trips are made by annual members in all months except July 2021 and the disparity between casual customers and annual members decreases towards warmer months.
- Casual customers have a longer average trip duration throughout every month and day.
- Casual customers have more trips on the weekend while annual members have more throughout the week.
- Total trips by annual members peaks about 8am and 5pm during the week, likely due to work commutes.
- Total trips by casual customers peaks around midday to early afternoon (12pm - 4pm) on weekends.

### Summary
It appears that current annual members typically use the bikes for commuting to and from work, mostly during the warmer months but still through the colder months of the year. Whereas casual customers typically use bikes on weekends and during warmer months. As such, my recommendations for converting casual customers to members are:
1. Introduce a weekend membership at a pro rata rate to appeal to customers who typicallyy use bikes over the weekend and less so throughout the week.
2. Introduce a 6-month membership for customers who typically only use bikes through the warmer months of the year (May - October, based on the data.
