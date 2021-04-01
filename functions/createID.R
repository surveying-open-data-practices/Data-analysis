createID <- function(key_df){
   id_df <- key_df %>% 
      # Add column called ID that contains the row number as ID to ensure every row has a unique ID to refer to
      mutate(id = dplyr::row_number())
}