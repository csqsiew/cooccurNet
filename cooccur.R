#' Co-occurence (sub-routine for Goni)
#' 
#' @description Computes co-occurence of responses within
#' a given window
#' 
#' @param data Matrix or data frame.
#' Preprocessed verbal fluency data
#' 
#' @param window Numeric.
#' Size of window to look for co-occurences in
#' 
#' @return A binary matrix 
#' 
#' @author Alexander Christensen <alexpaulchristensen@gmail.com>
#' 
#' @noRd
# Co-occurrence matrix
# Updated 26.03.2020
cooccur <- function(data, window = 2)
{
    # Data matrix
    mat <- as.matrix(data)
    
    # Replace "" with NA
    mat <- ifelse(mat == "", NA, mat)
    
    # Unique responses
    uniq.resp <- sort(na.omit(unique(as.vector(mat))))
    
    # Initialize number matrix
    num.mat <- mat
    
    # Replace responses with numbers
    for(i in 1:nrow(mat))
    {num.mat[i,] <- match(mat[i,], uniq.resp)}
    
    # Convert to numeric
    num.mat <- apply(num.mat,2,as.numeric)
    
    # Add NAs the length of window to matrix
    num.mat <- as.matrix(cbind(matrix(NA, nrow = nrow(num.mat), ncol = window),
                               num.mat,
                               matrix(NA, nrow = nrow(num.mat), ncol = window)))
    
    # Co-occurence matrix
    co.mat <- matrix(0, nrow = length(uniq.resp), ncol = length(uniq.resp))
    colnames(co.mat) <- uniq.resp
    rownames(co.mat) <- uniq.resp
    
    # Loop through each word
    for(i in 1:length(uniq.resp))
        for(j in 1:nrow(data))
        {
            # Find word position
            pos <- which(i == num.mat[j,])
            
            if(length(pos) != 0)
            {
                # Word neighbors
                for(k in 1:length(pos))
                {
                    if(k == 1)
                    {pos_neigh <- c((pos[k] - window:1), pos[k] + 1:window)
                    }else{pos_neigh <- c(pos_neigh, c((pos[k] - window:1), pos[k] + 1:window))}
                }
                
                # Get neighboring words
                words <- num.mat[j, pos_neigh]
                
                # Unique words (excluding self)
                words <- setdiff(unique(words[!is.na(words)]),i)
                
                # Count co-occurence
                co.mat[i, words] <- co.mat[i, words] + 1
            }
        }
    
    return(co.mat)
}