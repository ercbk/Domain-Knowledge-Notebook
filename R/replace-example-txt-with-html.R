# Replaces "Example" text in notes with html ribbon effect








pacman::p_load(dplyr, stringr, purrr)


files <- fs::dir_ls(path = "qmd", glob = "*.qmd")
file_names <- files |>
  # remove ext
  str_remove_all(pattern = "\\.qmd") |> 
  str_remove_all(pattern = "qmd/")

replace_ex_txt_with_html <- function(file, name) {
  md_txt <- readLines(file)
  txt_clean <- md_txt |>
    str_replace_all(pattern = "`Example`|Example(?=\\:)", "[Example]{.ribbon-highlight}")
  write(txt_clean, file = paste0("qmd2/", name, ".qmd"))
}

walk2(files, file_names, replace_ex_txt_with_html, .progress = TRUE)

replace_ex_txt_with_html("qmd/nlp-general.qmd", "nlp-general")
fs::file_move("qmd2/nlp-general.qmd", "qmd/nlp-general.qmd")





