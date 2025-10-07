library(tidyverse)

npv <- read_csv("data_raw/US-National-Parks_RecreationVisits_1979-2024.csv")
View(npv)

# Currently in clean format

# Average visits per year
avg_visits <- npv |>
  summarise(avg_visits = mean(RecreationVisits),
            .by = ParkName) |>
  arrange(desc(avg_visits))
View(avg_visits)

npv |>
  filter(ParkName == "Shenandoah NP") |>
  ggplot(aes(x = Year, y = RecreationVisits, group = ParkName)) +
  geom_line() +
  theme_bw()


# Separate location and visitation data into separate tables

national_parks <- npv |>
  select(ParkName, Region, State) |>
  distinct(ParkName, .keep_all = TRUE)
View(national_parks)

visits <- npv |>
  select(ParkName, Year, RecreationVisits)
view(visits)


# Transform visit data to long format
visits_wide <- visits |>
  pivot_wider(names_from = Year,
              values_from = RecreationVisits)
View(visits_wide)

# Return to long

visits_long <- visits_wide |>
  pivot_longer(cols = !ParkName,
               names_to = "Year",
               values_to = "RecreationVisits")
View(visits_long)

# Rejoin visit and location data
npv_construct <- visits_long |>
  left_join(national_parks, by = "ParkName") |>
  filter(!is.na(RecreationVisits))
View(npv_construct)
