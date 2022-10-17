# textsightr function but mod for shiny app 

coocurNet <- function(filename) {
    # read in text
    con <- file(filename, "r", blocking = FALSE)
    text <- readLines(con)
    close(con) 
    
    # convert raw text into sentences 
    x <- corpus::text_split(text, units = "sentences", size = 1)
    
    # clean up the sentences 
    x$text <- tolower(x$text) %>% gsub("(?!\')[[:punct:]]", ' ', ., perl = TRUE) # lowercase, remove punct, but leave the apostrophe in 
    
    # convert sentences into individual word vectors and merge into a matrix with empty 
    # to mimic fluency data
    
    # split sentences into word vectors 
    x$out <- sapply(1:nrow(x), function(i) {x$text[i] %>% as.character() %>% strsplit(split = ' ') %>% unlist()})
    
    # compute max sentence length 
    x$length <- sapply(1:nrow(x), function(i) {length(unlist(x$out[i]))})
    
    # set up empty df for storing 
    empty_df <- data.frame()
    
    # function to append NAs to word vectors that are too short 
    for(i in 1:nrow(x)) { # for each sentence 
        foo <- x$out[i] %>% unlist() # extract the word vector 
        
        if(length(foo) < max(x$length)) { # if the number of words in the sentence is less than the maximum length
            # print('yes')
            foo <- append(foo, rep(NA, max(x$length)-length(foo))) # append NAs behind
            empty_df <- empty_df %>% rbind(foo) # append row into dataframe 
        } else {
            empty_df <- empty_df %>% rbind(foo) # append row into dataframe, no need to append NAs 
        }
    }
    
    empty_m <- cooccur(empty_df, 1) # use cooccur function to make matrix from "verbal fluency-esque" data structure
    empty_m[upper.tri(empty_m)] <- 0 # only keep the correct direction for directed graphs 
    
    g <- graph_from_adjacency_matrix(empty_m, mode = 'undirected', weighted = TRUE, diag = FALSE)
    
    return(g)
}