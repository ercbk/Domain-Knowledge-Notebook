# fixes image file text
# fixes file names
# converts md to qmd




pacman::p_load(dplyr, stringr, purrr)
setwd("~/R/Projects/Domain-Knowledge-Notebook/md")


files <- fs::dir_ls(glob = "*.md")
file_names <- files |>
  # remove ext
  str_remove_all(pattern = "\\.md") |>
  # remove commas
  str_remove_all(pattern = ",") |>
  # remove spaces
  str_replace_all(pattern = " ", "-") |> 
  str_to_lower()


clean_txt <- function(file, name) {
  md_txt <- readLines(file)
  img_txt_clean <- md_txt |>
    # correct image-file-displaying code
    str_replace_all(pattern = "!\\[\\[\\.", "!\\[\\](\\.") |> 
    str_replace_all(pattern = "g\\]\\]", "g)")
  tab_txt_clean <- img_txt_clean |> 
    str_replace_all(pattern = "^\\* ", "-   ") |> 
    str_replace_all(pattern = "^\t\\* ", "\t\t-   ") |> 
    str_replace_all(pattern = "^\t\t\\* ", "\t\t-   ") |> 
    str_replace_all(pattern = "^\t\t\t\\* ", "\t\t\t\t-   ") |> 
    str_replace_all(pattern = "^\t\t\t\t\\* ", "\t\t\t\t-   ") |> 
    str_replace_all(pattern = "^\t\t\t\t\t\\* ", "\t\t\t\t\t\t-   ") |> 
    str_replace_all(pattern = "^\t\t\t\t\t\t\\* ", "\t\t\t\t\t\t-   ") |> 
    str_replace_all(pattern = "^\t\t\t\t\t\t\t\\* ", "\t\t\t\t\t\t\t\t-   ") |> 
    str_replace_all(pattern = "^\t\t\t\t\t\t\t\t\\* ", "\t\t\t\t\t\t\t\t-   ") |> 
    str_replace_all(pattern = "^\t\t\t\t\t\t\t\t\t\\* ", "\t\t\t\t\t\t\t\t\t\t-   ") |> 
    str_replace_all(pattern = "^\t\t\t\t\t\t\t\t\t\t\\* ", "\t\t\t\t\t\t\t\t\t\t-   ")
  write(tab_txt_clean, file = paste0("../qmd/", name, ".qmd"))
}

walk2(files, file_names, clean_txt)





