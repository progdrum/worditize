library(topicmodels)
library(mallet)


# Retrieve the specified books and process the text
process_books <- function(titles) {
  books <- 
    map(titles, get_book) %>% 
    reduce(full_join) %>% 
    unnest_tokens(word, text) %>% 
    anti_join(stop_words) %>% 
    count(gutenberg_id, word, sort = TRUE) %>% 
    left_join(gutenberg_metadata, by = "gutenberg_id") %>% 
    select(gutenberg_id:title)

  return(books)
}

# Generate an LDA analysis (takes processed books data and number of topics to mine)
# It is assumed there will be columns titled "title", "word", and "n"
get_books_lda <- function(books, num_topics) {
  books_lda <- 
    books %>% 
    cast_dtm(title, word, n) %>% 
    LDA(k = num_topics, control = list(seed = 777))
  
  return(books_lda)
}

# Get top N terms from topic model and generate plots
topic_beta_graphs <- function(books_topics, n = 10) {
  tbeta <- tidy(books_topics, matrix = "beta")

  top_terms_beta <- 
    tbeta %>%
    group_by(topic) %>%
    top_n(10, beta) %>%
    ungroup() %>%
    arrange(topic, -beta)
  
  term_graphs_beta <- 
    top_terms_beta %>%
    mutate(term = reorder(term, beta)) %>%
    ggplot(aes(term, beta, fill = factor(topic))) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~ topic, scales = "free") +
    coord_flip()
  
  return(term_graphs_beta)
}

topic_gamma_info <- function(books_topics) {
  return(tidy(books_topics, matrix = "gamma"))
}
