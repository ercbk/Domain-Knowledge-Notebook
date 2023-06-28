# Take the names of the terms in the Terms section of the notes and makes them purple



pacman::p_load(dplyr, stringr, purrr)


files <- fs::dir_ls(path = "qmd", glob = "*.qmd")
file_names <- files |>
  # remove ext
  str_remove_all(pattern = "\\.qmd") |> 
  str_remove_all(pattern = "qmd/")


replace_Terms_txt_with_html <- function(file, name) {
  
  qmd_txt <- readLines(file)
  
  # Gets the row index of where the Terms section starts
  start_terms_idx <- str_which(qmd_txt, "^Terms")
  if (length(start_terms_idx) == 0) {
    return("nothing")
  }
  
  # Finds the empty values which I'll use to find the end of the Terms section
  empty_idxs <- str_which(qmd_txt, "^$")
  # Get the empty value indexes after the beginning of the Terms section
  empty_after_start_idx <- empty_idxs[empty_idxs > start_terms_idx]
  # There an empty value after "Terms", so we want the second one which will mark the end of the section
  end_terms_idx <- empty_after_start_idx[[2]]
  
   # Get the text before and after the Terms section, replace text with html, and merge everything back together
  before_txt <- qmd_txt[1:(start_terms_idx - 1)]
  new_txt <- qmd_txt[start_terms_idx:end_terms_idx] |> 
    str_replace_all(pattern = "\\*\\*(?=[a-zA-Z])", "\\[\\*\\*") |> 
    str_replace_all(pattern = "\\*\\*(?= )", "\\*\\*\\]{style='color: #009499'}")
  after_txt <- qmd_txt[(end_terms_idx + 1):length(qmd_txt)]
  combined_txt <- c(before_txt, new_txt, after_txt)
  
  write(combined_txt, file = paste0("qmd2/", name, ".qmd"))
  
}

# walk2(files, file_names, replace_Terms_txt_with_html, .progress = TRUE)


replace_Terms_txt_with_html("qmd/economics.qmd", "economics")

fs::file_move("qmd2/causal-inference.qmd", "qmd/causal-inference.qmd")


# Alternative: Use when there are extra lines within the Terms section
# Terms and the next section after Terms needs to contain h2 tags (e.g. ## Moose)

replace_Terms_txt_with_html2 <- function(file, name) {
  
  qmd_txt <- readLines(file)
  
  # Gets the row index of where the Terms section starts
  start_terms_idx <- str_which(qmd_txt, "## Terms")
  if (length(start_terms_idx) == 0) {
    return("nothing")
  }
  
  # Finds the h2 tags which I'll use to find the end of the Terms section
  h2_idxs <- str_which(qmd_txt, "^## ")
  # Get the empty value indexes after the beginning of the Terms section
  h2_after_start_idx <- h2_idxs[h2_idxs > start_terms_idx]
  # There an empty value after "Terms", so we want the second one which will mark the end of the section
  h2_terms_idx <- h2_after_start_idx[[1]]
  
  # Get the text before and after the Terms section, replace text with html, and merge everything back together
  before_txt <- qmd_txt[1:(start_terms_idx - 1)]
  new_txt <- qmd_txt[start_terms_idx:(h2_terms_idx - 1)] |> 
    str_replace_all(pattern = "\\*\\*(?=[a-zA-Z])", "\\[\\*\\*") |> 
    str_replace_all(pattern = "\\*\\*(?= )", "\\*\\*\\]{style='color: #009499'}")
  after_txt <- qmd_txt[(h2_terms_idx):length(qmd_txt)]
  combined_txt <- c(before_txt, new_txt, after_txt)
  
  write(combined_txt, file = paste0("qmd2/", name, ".qmd"))
  
}

replace_Terms_txt_with_html2("qmd/healthcare.qmd", "healthcare")

fs::file_move("qmd2/healthcare.qmd", "qmd/healthcare.qmd")

