DEFAULT_VHS_VERSION <- "0.11.0"
DEFAULT_TTYD_VERSION <- "1.7.7"
DEFAULT_FFMPEG_VERSION <- "latest"

#' Install vhs and its runtime dependencies
#'
#' Downloads `vhs`, `ttyd`, and `ffmpeg` into the per-user cache returned by
#' [vhsr_cache_dir()]. Where binaries cannot be auto-downloaded for a given
#' platform (notably `ttyd` and `ffmpeg` on macOS), the function aborts with
#' a one-line `brew install` instruction; system-installed binaries on
#' `PATH` are picked up automatically by [vhsr_doctor()] afterwards.
#'
#' @param tools Character vector of tools to install. Defaults to all three.
#' @param force If `TRUE`, re-download even if the binary already exists.
#' @param versions A named list overriding the default version of any tool,
#'   for example `list(vhs = "0.10.0")`.
#' @return Invisibly returns the cache directory path.
#' @export
vhsr_install <- function(
  tools = c("vhs", "ttyd", "ffmpeg"),
  force = FALSE,
  versions = list()
) {
  tools <- match.arg(tools, several.ok = TRUE)
  cache <- vhsr_cache_dir()
  dir.create(cache, recursive = TRUE, showWarnings = FALSE)

  defaults <- list(
    vhs = DEFAULT_VHS_VERSION,
    ttyd = DEFAULT_TTYD_VERSION,
    ffmpeg = DEFAULT_FFMPEG_VERSION
  )

  for (tool in tools) {
    install_one(
      tool,
      cache,
      force = force,
      version = versions[[tool]] %||% defaults[[tool]]
    )
  }
  cli::cli_alert_success("vhsR cache: {.path {cache}}")
  invisible(cache)
}

install_one <- function(tool, cache, force, version) {
  existing <- switch(
    tool,
    vhs = vhsr_vhs_path(),
    ttyd = vhsr_ttyd_path(),
    ffmpeg = vhsr_ffmpeg_path()
  )
  if (nzchar(existing) && !force) {
    cli::cli_alert_info("{tool}: already available ({.path {existing}})")
    return(invisible(existing))
  }
  switch(
    tool,
    vhs = install_vhs(cache, version),
    ttyd = install_ttyd(cache, version),
    ffmpeg = install_ffmpeg(cache, version)
  )
}

install_vhs <- function(cache, version) {
  os <- vhsr_os()
  arch <- vhsr_arch()
  os_name <- switch(os, darwin = "Darwin", linux = "Linux", windows = "Windows")
  ext <- if (os == "windows") "zip" else "tar.gz"
  asset <- sprintf("vhs_%s_%s_%s.%s", version, os_name, arch, ext)
  url <- sprintf(
    "https://github.com/charmbracelet/vhs/releases/download/v%s/%s",
    version,
    asset
  )
  download_and_extract(url, cache, exe_name = vhsr_exe("vhs"))
}

install_ttyd <- function(cache, version) {
  os <- vhsr_os()

  if (os == "darwin") {
    cli::cli_abort(c(
      "vhsR can't auto-install {.code ttyd} on macOS.",
      i = "Run {.code brew install ttyd} - the official path on macOS.",
      i = "{.fn vhsr_doctor} will pick it up from {.envvar PATH} afterwards."
    ))
  }

  if (os == "windows") {
    asset <- "ttyd.win32.exe"
    target <- file.path(cache, "ttyd.exe")
  } else {
    arch_part <- switch(
      vhsr_arch(),
      "x86_64" = "x86_64",
      "arm64" = "aarch64"
    )
    asset <- paste0("ttyd.", arch_part)
    target <- file.path(cache, "ttyd")
  }

  url <- sprintf(
    "https://github.com/tsl0922/ttyd/releases/download/%s/%s",
    version,
    asset
  )
  cli::cli_progress_step("Downloading {.val {asset}}")
  utils::download.file(url, target, mode = "wb", quiet = TRUE)
  if (os != "windows") {
    Sys.chmod(target, "0755")
  }
  cli::cli_alert_success("Installed {.code ttyd} to {.path {target}}")
  invisible(target)
}

install_ffmpeg <- function(cache, version) {
  os <- vhsr_os()

  if (os == "darwin") {
    cli::cli_abort(c(
      "vhsR doesn't auto-install {.code ffmpeg} on macOS.",
      i = "Run {.code brew install ffmpeg} - the standard path on macOS.",
      i = "{.fn vhsr_doctor} will pick it up from {.envvar PATH} afterwards."
    ))
  }

  arch_part <- if (os == "linux") {
    switch(vhsr_arch(), "x86_64" = "linux64", "arm64" = "linuxarm64")
  } else if (os == "windows") {
    if (vhsr_arch() != "x86_64") {
      cli::cli_abort("No prebuilt ffmpeg for Windows {.val {vhsr_arch()}}.")
    }
    "win64"
  }

  ext <- if (os == "windows") "zip" else "tar.xz"
  release <- if (identical(version, "latest")) {
    "latest"
  } else {
    paste0("n", version)
  }
  asset <- sprintf("ffmpeg-master-latest-%s-gpl.%s", arch_part, ext)
  url <- sprintf(
    "https://github.com/BtbN/FFmpeg-Builds/releases/download/%s/%s",
    release,
    asset
  )
  download_and_extract(url, cache, exe_name = vhsr_exe("ffmpeg"))
}

download_and_extract <- function(url, dest_dir, exe_name) {
  cli::cli_progress_step("Downloading {.val {basename(url)}}")
  td <- withr::local_tempdir()
  archive <- file.path(td, basename(url))
  utils::download.file(url, archive, mode = "wb", quiet = TRUE)

  cli::cli_progress_step("Extracting {.val {basename(url)}}")
  ex_dir <- file.path(td, "extracted")
  dir.create(ex_dir)

  if (grepl("\\.zip$", url)) {
    utils::unzip(archive, exdir = ex_dir)
  } else {
    utils::untar(archive, exdir = ex_dir)
  }

  found <- list.files(
    ex_dir,
    pattern = paste0("^", exe_name, "$"),
    recursive = TRUE,
    full.names = TRUE
  )
  if (length(found) == 0) {
    cli::cli_abort("Could not find {.code {exe_name}} inside {.url {url}}")
  }

  target <- file.path(dest_dir, exe_name)
  file.copy(found[[1L]], target, overwrite = TRUE)
  Sys.chmod(target, "0755")
  cli::cli_alert_success("Installed {.code {exe_name}} to {.path {target}}")
  invisible(target)
}
