vhsr_os <- function() {
  sysname <- Sys.info()[["sysname"]]
  switch(
    sysname,
    Darwin = "darwin",
    Linux = "linux",
    Windows = "windows",
    cli::cli_abort("Unsupported OS: {.val {sysname}}")
  )
}

vhsr_arch <- function() {
  m <- tolower(Sys.info()[["machine"]])
  if (m %in% c("x86_64", "x86-64", "amd64")) {
    "x86_64"
  } else if (m %in% c("arm64", "aarch64")) {
    "arm64"
  } else {
    cli::cli_abort("Unsupported architecture: {.val {m}}")
  }
}

vhsr_exe <- function(name) {
  if (vhsr_os() == "windows") paste0(name, ".exe") else name
}

augmented_path <- function() {
  cache <- vhsr_cache_dir()
  if (!dir.exists(cache)) {
    return(Sys.getenv("PATH"))
  }
  paste(cache, Sys.getenv("PATH"), sep = .Platform$path.sep)
}
