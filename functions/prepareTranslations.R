prepareTranslations = function(enlish_keyfile, french_keyfile, portuguese_keyfile, data_dir = "data"){
   
   # Read key files in ----
   en_keys <- read_csv(here("data", "results-for-idrc-surveyin-2020-11-06-1612-key.en.csv")) 
   fr_keys <- read_csv(here("data", "results-for-idrc-surveyin-2020-11-06-1556-key.fr.csv"))
   pt_keys <- read_csv(here("data", "results-for-idrc-surveyin-2020-11-06-1555-key.pt.csv"))
   
   # Fix files to ensure each question/answer is on the same row in the different translations
   # French survey is missing option 12 for Q19
   fr_keys <- fr_keys %>% 
      dplyr::add_row(URN = "12", `Unique Response Number` = "Je n'ai aucun problème pratique pour partager mes données", .before = 233)
   
   # Create unique key column ----
   
   source(here("functions", "createID.R"))
   
   en_ids <- createID(en_keys)
   fr_ids <- createID(fr_keys)
   pt_ids <- createID(pt_keys)
   
   # CLEAN UP RAW DATA ----
   
   remove(en_keys, fr_keys, pt_keys)
   
   # Join key files to have translations in one tibble ----
   translations <- en_ids %>% 
      # Add contents of French key file to English key file
      dplyr::left_join(fr_ids, by = "id") %>% 
      # Add contents of Portuguese key file to previous
      dplyr::left_join(pt_ids, by = "id") %>% 
      # Drop duplicate columns
      dplyr::select(-c(URN.x, URN.y)) %>%
      # Move ID and URN columns to the front
      dplyr::relocate(id) %>% 
      dplyr::relocate(URN, .after = "id") %>% 
      # Rename columns to have sensible names
      dplyr::rename(urn = URN,
                    english = `Unique Response Number.x`,
                    french = `Unique Response Number.y`,
                    portug = `Unique Response Number`)
   
   # Return the newly created tibble with 3 translations and questions/options 
   return(translations)
}