# readme for cooccurNet application

## purpose

A R shiny application that generates a network of word cooccurrences given a sample text. The user can visualize the network and download a simple edge list of this network for further analysis. This application was created as a teaching tool for PL4246, Networks in Psychology. 

Application flow: 

1. Upload a .txt file containing some text. Please keep this file size small-ish as the application/server is not optimized for large files. 
   1. If your text data does not work, make sure that (i) it is a .txt file,  (ii) there is no rich text formatting and (iii) add an extra hard return on the last line
2. Wait a bit for the network to generate. 
3. Download the edge list if needed. 

The application does not retain any user data. 

## how to use

### local deployment

Assumes you have R and RStudio installed and know your way around it. 

The following packages are needed: `shiny`, `igraph`, `tidyverse`, `corpus` - install via `install.packages('PackageName')`

Download the files in this repository by clicking on 'Code', 'Download ZIP'.

Open the `app.R` file in Rstudio, make sure your working directory is pointed to wherever the app files are at, and then click on 'Run App'. 

### online app 

A demo of this application can be found here: http://r-server.csqsiew.xyz/cooccurNet/ 

## additional notes 

- Words that co-occur within a window size of 2 are connected (i.e., bigrams) 
- Words that straddle different sentences are not considered as co-occurring.  
- Currently, only a simple list of undirected, unweighted edges is created. Directed and weighted edges are planned for the future. 
- See `lorem.txt` and `output.csv` for examples of input and output files.
- The co-occurrence matrix algorithm was adapted from: https://github.com/AlexChristensen/SemNeT   

## final notes

last updated: 15th August 2021 

Please feel free to adapt for your own use. 

If you found this useful, feel free to tip me here: https://ko-fi.com/csqsiew or check out my work here: http://hello.csqsiew.xyz/ 

Thanks! :)

