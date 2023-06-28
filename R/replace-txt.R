


pacman::p_load(dplyr, stringr, purrr)



files <- fs::dir_ls(path = "qmd", glob = "*.qmd")
file_names <- files |>
  # remove ext
  str_remove_all(pattern = "\\.qmd") |> 
  str_remove_all(pattern = "qmd/")


replace_text <- function(file, name) {
  qmd_txt <- readLines(file)
  new_txt <- qmd_txt |> 
    str_remove_all(pattern = "Data Science Notebook, ")
  write(new_txt, file = paste0("qmd2/", name, ".qmd"))
}

walk2(files, file_names, replace_text, .progress = TRUE)

# replace_text("qmd/low-hanging-fruit.qmd", "low-hanging-fruit")
