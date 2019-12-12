library(tidyverse)
library(lubridate)
library(RSQLite)

system("curl -X GET \
 'https://api.birdapp.com/bird/nearby?latitude=37.77184&longitude=-122.40910&radius=1000' \
 -H 'App-Version: 4.41.0' \
 -H 'Authorization: Bird eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJBVVRIIiwidXNlcl9pZCI6IjcwYjMwZTM5LTdkZmQtNDc5OC1hN2M5LTI5NjYxNjU3ZWU5NyIsImRldmljZV9pZCI6ImJmNzU1OTgyLWVkNTgtNGIxZC04MDMyLWI3NTU0YzRkMjU1OSIsImV4cCI6MTYwNzY1ODQwOX0.UK6hX0HRBiyDilm-AIOq7LjibRhyl7K_4SM0t2_9dtM' \
 -H 'Device-id: bf755982-ed58-4b1d-8032-b7554c4d2559' \
 -H 'Location: {'latitude':37.77249, 'longitude':-122.40910, 'altitude':500,'accuracy':100,'speed':-1,'heading':-1}'  -o bird.json")

data <- jsonlite::fromJSON("data.json")
birds <- data$birds

birds <- birds %>% rowid_to_column("ID") %>% as_tibble()
birdLocations <- birds$location %>% rowid_to_column("ID") %>% as_tibble()

birds %>%
  left_join(., birdLocations, by = "ID") -> birds

birds <- birds %>% select(-ID, -location)

birds %>%
  mutate(
    Date = today(tzone = "EST"),
    Time = now(tzone = "EST")
  ) -> birds
