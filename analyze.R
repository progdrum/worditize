library(tidytext)
library(tidyverse)
library(stringr)
library(wordcloud)
library(gutenbergr)

# Read in a file to process (and I should really do some preprocessing here!)
slurp <- function(filename) {
  file_text <- read_file(filename)
  return(file_text)
}

# Get Project Gutenberg book by title based on ID
get_book <- function(pg_title) {
  pg_id <- gutenberg_metadata %>% 
    filter(title == pg_title) %>% 
    select(gutenberg_id)
  book <- gutenberg_download(pg_id[[1]])
  
  return(book)
}

# Basic, initial text processing
process_text <- function(file_text) {
  tidied <- file_text %>% 
    unnest_tokens(word, text) %>%
    mutate(word = str_extract(word, "[a-z']+")) %>% 
    anti_join(stop_words)
  
  return(tidied)
}

# Plot word counts (takes pre-processed text from function above)
word_counts <- function(ptext) {
  plt <- count(ptext, word, sort = TRUE) %>% 
    top_n(10) %>% 
    ggplot(aes(word, n)) + 
    geom_col() + 
    coord_flip()
  
  return(plt)
}

# Bind sentiment data frames to word tibble
bind_sentiments <- function(words) {
  # Use purrr and a parameter to facilitate arbitrary lexicons?
  nrc_sent <- inner_join(get_sentiments("nrc"), words)
  afinn_sent <- inner_join(get_sentiments("afinn"), words)
  bing_sent <- inner_join(get_sentiments("bing"), words)
  
  # Return as a list
  return(list(nrc = nrc_sent, afinn = afinn_sent, bing = bing_sent))
}

# Get NRC sentiment count
get_nrc_count <- function(words_sent) {
  return(count(words_sent, sentiment, sort = TRUE))
}

# Get AFINN sentiment counts
get_afinn_counts <- function(words_sent) {
  total <- reduce(words_sent$score, `+`)
  avg <- mean(words_sent$score)
  med <- median(words_sent$score)
  counts <- count(words_sent, score, sort = TRUE)
  
  return(list(total = total, avg = avg, med = med, counts = counts))
}

# Get Bing sentiment counts
get_bing_count <- function(words_sent) {
  return(count(words_sent, sentiment, sort = TRUE))
}

# Plot the sentiment counts
sentiment_counts <- function(ptext) {
  sents <- bind_sentiments(ptext)
  
  nrc_plt <- get_nrc_count(sents_nrc) %>% 
    top_n(10) %>% 
    ggplot(aes(word, n)) + 
    geom_col() + 
    coord_flip()
  
  afinn_plt <- get_afinn_counts(sents$afinn)$counts %>% 
    top_n(10) %>% 
    ggplot(aes(word, n)) + 
    geom_col() + 
    coord_flip()
  
  bing_plt <- get_bing_count(sents$bing) %>% 
    top_n(10) %>% 
    ggplot(aes(word, n)) + 
    geom_col() + 
    coord_flip()
  
  return(nrc = nrc_plt, afinn = afinn_plt, bing = bing_plt)
}
