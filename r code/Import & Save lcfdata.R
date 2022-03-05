# Install and/or load packages with pacman
pacman::p_load(  # Use p_load function from pacman
  arulesCBA,     # Classification Based on Association
  caret,         # Confusion matrix for predictions
  magrittr,      # Pipes
  pacman,        # Load/unload packages
  rio,           # Import/export data
  tidyverse,     # So many reasons
)

# LOAD AND PREPARE DATA ####################################

# Set random seed for reproducibility in processes like
# splitting the data. You can use any number.
set.seed(1)

df <- read.csv("~/Downloads/Raw F Training.csv", stringsAsFactors=TRUE)
df <- select(df, -Call.Number)

df %<>% 
  rename(y = Brittle) %>%   # Rename class variable as `y`
  mutate(
    y = ifelse(
      y == 0, 
      "NotBrittle", 
      "Brittle"
    )
  ) %>%
  mutate(y = factor(y))  # Recode class label as factor

#If rename needed rename(data, new = old)
#df <- rename(df, PlaceCode = PlaceCode)

df$PubDate <- as.double(df$PubDate)
df$Age <- as.double(df$Age)

# SAVE DATA ################################################

df %>% saveRDS("data/csudhsmpl.rds")


