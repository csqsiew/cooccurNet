# function to convert some text into a 2-word co-occurrence graph 

coocurNet <- function(filename) {
    # read in text
    con <- file(filename, "r", blocking = FALSE)
    text <- readLines(con, encoding = 'UTF-8') ## encoding is specified 
    close(con) 
    
    # convert raw text into sentences 
    x <- strsplit(text, '\\.') |> unlist()
    
    # clean up the sentences 
    x <- tolower(x) %>% gsub("(?!\')[[:punct:]]", ' ', ., perl = TRUE) # lowercase, remove punct, but leave the apostrophe in 
    
    
    ### LEMMATIZER HERE ### 
    
   
    # use tokenizer to create 2-grams from sentences 
    new_x <- data.frame(bigram = tokenize_ngrams(x, n = 2L) |> unlist()) |> count(bigram) |> 
      separate(bigram, into = c('from', 'to'), sep = ' ', remove = T) |> rename(weight = n)
    
    # create the network from the edge list  
    g <- graph_from_data_frame(new_x) 
   
    return(g)
}