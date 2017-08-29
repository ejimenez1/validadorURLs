G_TOKEN_SIZE <- 3


# function separates text into n-sized grams
tokenizer <- function(txt, n){
  print("tokenizing text...")
  txt_split <- strsplit(txt, " ")[[1]]
  txt_split_letters<- strsplit(txt_split, "")
  txt_tokenized <- ""
  for(letter_split in txt_split_letters)
  {
    token <- ""
    i = 0
    for(letter in letter_split)
    {
      if(i < n){
        token <- paste(token, letter,sep = "")
        i <- i + 1
      }
      
      if (i == n)
      {
        txt_tokenized <- paste(txt_tokenized, token, sep = "")
        txt_tokenized <- paste(txt_tokenized, " ", sep = "")
        token <- ""
        i <- 0;
      }
      
    }
  }
  
  print("tokenizing completed.")
  return (txt_tokenized)
} 

# obtains url token indexes given a dictionary
# this fn creates the binary features for each url
processUrl <- function (url, dictionary){
  
  # URL text tokenization (3-word elements)
  tokenized_url = tokenizer(url, 3)
  # source & corpus
  url_source <- VectorSource(tokenized_url)
  corpus <- Corpus(url_source)
  # URL text cleaning
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removeWords, 
                   c("com", "www", "post", "org", "html", 
                     "net", stopwords("english")))
  
  dtm <- DocumentTermMatrix(corpus)
  dtm2 <- as.matrix(dtm)
  # obtains array if tokenized words 
  url_words <- colnames(dtm2)
  # search "words" in Dictionary and buid array with indexes
  index_array <- NULL
  i = 1
  for(d in dictionary$token)
  {
    for(w in url_words)
    {
      if(w == d)
      {
        index_array <- c(index_array, i)
      }
    }
    i <- i + 1
  }
  
  return (index_array)
}

getDictionary <- function(){
  # load tokens from csv (term dictonary)
  dictionary <- read.csv('Dictionary.csv')
  colnames(dictionary) <- c("token","count")
  
  return (dictionary)
}

# creates binary feature set
urlFeatures <- function(indices, n){
  # create zero-array of size n 
  x <- numeric(length = n)
  for(i in indices)
  {
    x[i] <- 1
  }
  
  return (x)
}