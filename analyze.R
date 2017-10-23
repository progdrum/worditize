library(tidytext)
library(readr)
library(dplyr)
library(ggplot2)

# Read in a file to process
slurp <- function(filename) {
  file_text <- read_file(filename)
}

# Basic, initial text processing
process_text <- function(file_text) {
  tidied <- file_text %>% 
    unnest_tokens(word, text) %>%
    mutate(word = str_extract(word, "[a-z']+")) %>% 
    anti_join(stop_words)
}

# Plot word counts (takes pre-processed text from function above)
word_counts <- function(ptext) {
  plt <- count(ptext, word, sort = TRUE) %>% 
    top_n(10) %>% 
    ggplot(aes(word, n)) + 
    geom_col() + 
    coord_flip()
}
