# colors the text of packages and the curly braces in notes




pacman::p_load(dplyr, stringr, purrr)



files <- fs::dir_ls(path = "qmd", glob = "*.qmd")
file_names <- files |>
  # remove ext
  str_remove_all(pattern = "\\.qmd") |> 
  str_remove_all(pattern = "qmd/")



replace_pkg_txt_with_html <- function(file, name) {
  
  qmd_txt <- readLines(file)
  
  linked_clean <- qmd_txt |>
    # replace linked python packages text with html
    # front part
    str_replace_all(pattern = "\\{\\{\\[", "[{{]{style='color: goldenrod'}[") |> 
    # back part
    str_replace_all(pattern = "\\)\\}\\}", "){style='color: goldenrod'}[}}]{style='color: goldenrod'}") |> 
    # replace linked r packages text with html
    # front part
    str_replace_all(pattern = "\\{\\[", "[{]{style='color: #990000'}[") |> 
    # back part
    str_replace_all(pattern = "\\)\\}", "){style='color: #990000'}[}]{style='color: #990000'}")
  
  
  # Replace Unlinked Python package text with html----
  
  # Strip pkg txt of curly brackets
  py_pkg_names <- linked_clean |> 
    str_extract_all(pattern = "\\{\\{[a-zA-Z]+\\}\\}") |> 
    compact() |> 
    str_remove_all("\\{") |> 
    str_remove_all("\\}") |> 
    unique()
  
  # Take names and create regex patterns and replacement text
  py_pkgs_patterns <- function(pkg_name) {
    pattern_str <- paste0("\\{\\{", pkg_name, "\\}\\}")
    repl_str <- paste0("[{{", pkg_name, "}}]{style='color: goldenrod'}")
    list(pattern_str = pattern_str,
         repl_str = repl_str)
  }
  
  # Create list of patterns and replacement text
  py_patterns_ls <- map(py_pkg_names, py_pkgs_patterns)
  
  # Replace pkg text with html
  replace_txt <- function(dat, patterns) {
    if (length(patterns) == 0) {
      return(dat)
    }
    pattern_str <- patterns[[1]]$pattern_str
    repl_str <- patterns[[1]]$repl_str
    replaced_txt <- dat |> 
      str_replace_all(pattern = pattern_str, repl_str)
    new_patterns <- patterns[-1]
    replace_txt(replaced_txt, new_patterns)
  }
  
  # Replace all unlinked Python pkg text with html
  py_unlinked_replaced_txt <- replace_txt(linked_clean, py_patterns_ls)
  
  
  
  # Replace R package text with html----
  
  # Strip pkg txt of curly brackets
  r_pkg_names <- linked_clean |> 
    # Was having trouble trying to NOT match unlinked py pkgs, but https://www.autoregex.xyz/ came up with this voodoo regex for the last part of regex expression. "?!" is "not followed by but I have no idea what the whole thing means lol. Used prompt, "match a word inside curly braces but not a word inside double curly braces".
    str_extract_all(pattern = "\\{[a-zA-Z]+\\}(?![^{]*\\})") |> 
    compact() |> 
    str_remove_all("\\{") |> 
    str_remove_all("\\}") |> 
    unique()
  
  # Take names and create regex patterns and replacement text
  r_pkgs_patterns <- function(pkg_name) {
    pattern_str <- paste0("\\{", pkg_name, "\\}")
    repl_str <- paste0("[{", pkg_name, "}]{style='color: #990000'}")
    list(pattern_str = pattern_str,
         repl_str = repl_str)
  }
  
  # Create list of patterns and replacement text
  r_patterns_ls <- map(r_pkg_names, r_pkgs_patterns)
  
  # Replace all unlinked R pkg text with html
  r_unlinked_replaced_txt <- replace_txt(py_unlinked_replaced_txt, r_patterns_ls)
  
  
  write(r_unlinked_replaced_txt, file = paste0("qmd2/", name, ".qmd"))
  
}

walk2(files, file_names, replace_pkg_txt_with_html, .progress = TRUE)




