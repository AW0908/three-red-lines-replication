# Shared output/guard helpers. Sourcing this file only defines functions;
# Rscript code/00_setup.R also checks the build dependencies below.
# MTPA_TEST_CRLF=1 is a test-only hook for exercising Windows line endings.
mtpa_eol <- function() {
  if (identical(Sys.getenv("MTPA_TEST_CRLF"), "1")) "\r\n" else "\n"
}
mtpa_write_csv <- function(x, path, ...) {
  con <- file(path, open = "wb")
  on.exit(close(con))
  write.csv(x, con, ..., eol = mtpa_eol())
}
mtpa_write_table <- function(x, path, ...) {
  con <- file(path, open = "wb")
  on.exit(close(con))
  write.table(x, con, ..., eol = mtpa_eol())
}
mtpa_write_lines <- function(text, path) {
  # Some LaTeX producers supply one string containing embedded line breaks.
  if (identical(mtpa_eol(), "\r\n"))
    text <- gsub("\n", "\r\n", text, fixed = TRUE)
  con <- file(path, open = "wb")
  on.exit(close(con))
  writeLines(text, con, sep = mtpa_eol(), useBytes = TRUE)
}
# Only text outputs are normalised; PDF hashes retain the original bytes.
mtpa_sha256 <- function(path) {
  if (!tolower(tools::file_ext(path)) %in% c("csv", "tex"))
    return(unname(tools::sha256sum(path)))
  bytes <- readBin(path, what = "raw", n = file.info(path)$size)
  normalised <- tempfile(fileext = ".bin")
  on.exit(unlink(normalised))
  writeBin(bytes[bytes != as.raw(13L)], normalised)
  unname(tools::sha256sum(normalised))
}
mtpa_guard <- function(ok, message) {
  if (!isTRUE(ok)) {
    if (identical(Sys.getenv("MTPA_GUARDS"), "warn"))
      warning(message, " [MTPA_GUARDS=warn; continuing; existing protected files retained]",
              call. = FALSE)
    else stop(message, call. = FALSE)
  }
  invisible(ok)
}
mtpa_guard_pdf <- function(staged, target) {
  # Validate newly built PDFs and existing protected targets in every mode.
  # Producer metadata and rendering can differ across R/package versions.
  for (path in c(staged, if (file.exists(target)) target)) {
    if (!file.exists(path) || is.na(file.info(path)$size) ||
        file.info(path)$size <= 5L ||
        !identical(readBin(path, what = "raw", n = 5L), charToRaw("%PDF-")))
      stop("STOP: protected T005 output is not a non-empty PDF: ", path,
           call. = FALSE)
  }
  if (file.exists(target) &&
      !identical(mtpa_sha256(staged), mtpa_sha256(target))) {
    if (identical(Sys.getenv("MTPA_GUARDS"), "strict_pdf"))
      mtpa_guard(FALSE, paste0("STOP: protected T005 PDF differs: ", target))
    else
      message("PDF differs, probably R/package version; numbers are guarded via CSV/TEX: ",
              target)
  }
  invisible(TRUE)
}

mtpa_setup <- function() {
  # Run from replication/. No data downloads are part of this setup.
  set.seed(20261016)
  entries <- trimws(readLines("environment.lock", warn = FALSE))
  entries <- entries[nzchar(entries) & !grepl("^(#|\\[)", entries)]
  fields <- strsplit(entries, "[[:space:]]+")
  stopifnot(all(lengths(fields) == 2L))
  recorded <- setNames(vapply(fields, `[`, character(1), 2L),
                       vapply(fields, `[`, character(1), 1L))
  stopifnot(!anyDuplicated(names(recorded)), "R" %in% names(recorded))
  cat("R: installed", as.character(getRversion()), "recorded", recorded[["R"]], "\n")
  if (getRversion() != package_version(recorded[["R"]]))
    warning("R version differs from environment.lock; exact output reproduction is unverified.")
  if (getRversion() < "4.4.0" || !"sha256sum" %in% getNamespaceExports("tools"))
    stop("This build requires R >= 4.4 with tools::sha256sum; use the recorded R version.")

  # Direct dependencies derived from library(), requireNamespace(), and :: in
  # cleaning, estimation and figure scripts, including 07_rd.R.
  # stats, grDevices and tools ship with R. Other lock entries are retained.
  used <- c("data.table", "readxl", "ggplot2", "scales", "fixest",
            "modelsummary", "kableExtra", "rdrobust", "rddensity", "stats", "grDevices", "tools")
  if (length(setdiff(used, names(recorded))))
    stop("Packages missing from environment.lock: ", paste(setdiff(used, names(recorded)), collapse = ", "))
  packages <- used
  missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
  rd_missing <- intersect(missing, c("rdrobust", "rddensity"))
  if (length(rd_missing))
    stop("STOP T024: required local RD packages unavailable: ", paste(rd_missing, collapse = ", "),
         ". Install separately before this offline build; no substitute or download attempted.")
  if (length(missing)) {
    # Mainland China alternative: https://mirrors.ustc.edu.cn/CRAN/
    install.packages(missing, repos = "https://cloud.r-project.org")
  }
  if (any(!vapply(packages, requireNamespace, logical(1), quietly = TRUE)))
    stop("Required packages remain unavailable after installation.")
  installed <- vapply(packages, function(p) as.character(packageVersion(p)), character(1))
  print(data.frame(package = packages, installed = unname(installed),
                   recorded = unname(recorded[packages])), row.names = FALSE)
  different <- packages[installed != recorded[packages]]
  if (length(different))
    warning("Installed versions differ from environment.lock: ", paste(different, collapse = ", "),
            ". Continuing; byte-identical outputs are not guaranteed.")
  cat("Setup complete.\n")
}
if (sys.nframe() == 0L) mtpa_setup()
