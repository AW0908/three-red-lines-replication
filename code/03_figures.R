# T045 Rework 1: native font-only replay of the five figures retained in the PDF.
# Cairo cannot load locally (missing X11 libraries); Quartz embeds native Times.
# Existing plotting expressions are read verbatim; numeric inputs are delivered
# CSVs (and paired histogram counts reconstructed by the unchanged T029 identity).
# No estimator, bootstrap, data file or numeric table is run or written here.
if ("--embed-proposal-fonts" %in% commandArgs(trailingOnly = TRUE) &&
    capabilities("aqua") && requireNamespace("systemfonts", quietly = TRUE) &&
    grepl("Times New Roman", systemfonts::match_fonts("Times New Roman")$path[1], fixed = TRUE)) {
  set.seed(20261030)
  suppressPackageStartupMessages(library(ggplot2))
  grDevices::quartzFonts(TNR = grDevices::quartzFont(c("TimesNewRomanPSMT",
    "TimesNewRomanPS-BoldMT", "TimesNewRomanPS-ItalicMT", "TimesNewRomanPS-BoldItalicMT")))
  files <- list.files("outputs/tables", full.names = TRUE)
  before_hash <- tools::md5sum(files)
  td <- tempfile("t045_times_"); dir.create(td)
  read_output <- function(stem) read.csv(paste0("outputs/tables/", stem, ".csv"),
    stringsAsFactors = FALSE, na.strings = c("", "NA", "--"))
  nf <- function(x) length(unique(x[!is.na(x)]))
  draw_slice <- function(file, start, end, envir, edit = identity) {
    lines <- readLines(file, warn = FALSE)
    a <- grep(start, lines, fixed = TRUE); b <- grep(end, lines, fixed = TRUE)
    stopifnot(length(a) == 1L, length(b) == 1L, b > a)
    eval(parse(text = edit(paste(lines[a:(b-1L)], collapse = "\n"))), envir)
  }
  times_target <- function(target, width, height) {
    grDevices::quartz(type = "pdf", file = file.path(td, basename(target)),
      width = width, height = height)
    par(family = "TNR")
  }
  # 1. Exact stored T023 observed and fitted counts.
  env <- new.env(parent = globalenv())
  z <- read_output("t023_excess_mass_bins")
  env$main_prediction <- z[z$ratio == "rl1" & z$period == "post" &
    z$sample_rule == "main_sample" & z$threshold == .7 & z$specification == "main", ]
  stopifnot(nrow(env$main_prediction) == 60L)
  env$base_theme <- theme_minimal(base_size = 10, base_family = "TNR") +
    theme(legend.position = "top", legend.title = element_blank(), panel.grid.minor = element_blank(),
      plot.caption = element_text(size = 8, hjust = 0), strip.text = element_text(face = "bold"))
  env$save_pdf <- function(plot, name, width, height) {
    times_target(paste0("t023_", name, ".pdf"), width, height)
    print(plot); invisible(dev.off())
  }
  draw_slice("code/06_bunching_tests.R", "p <- ggplot(main_prediction,", "# Guards:", env)
  # 2. Original component medians from the delivered event audit.
  env <- new.env(parent = globalenv())
  z <- read_output("t027_event_audit"); env$e1 <- z[z$ratio == "rl1" & z$lag == 1L, ]
  env$cells <- c("post_crossings", "pre_crossings", "post_stayers")
  env$post_logit <- median(env$e1$total[env$e1$cell == "post_crossings"], na.rm = TRUE)
  env$post_pp <- 100*.70*(1-.70)*env$post_logit
  draw_slice("code/08_decomposition.R", "fig<-list(); parts<-", "stopifnot(identical(input_hash,", env,
    function(x) sub('grDevices::pdf("outputs/figures/t027_decomposition_rl1.pdf",width=9,height=8.5,\n  useDingbats=FALSE,timestamp=FALSE,title="T027 descriptive accounting decomposition")',
      'times_target("t027_decomposition_rl1.pdf",9,8.5)', x, fixed = TRUE))
  # 3. T029 paired histograms: same domains, anchor, grid and counts; estimates
  # and counts in the legend come from the existing CSV, not a fitted model.
  env <- new.env(parent = globalenv())
  z <- read.csv("data/processed/panel_firm_halfyear.csv", stringsAsFactors = FALSE)
  z <- z[!is.na(z$sample_main) & z$sample_main, ]
  N <- z$tl-z$adv; valid <- is.finite(N)&N>0&is.finite(z$te)&z$te>0
  official <- ifelse(valid,N/(N+z$te),NA_real_)
  j <- match(paste(z$firm_id,"2019-12-31"),paste(z$firm_id,z$date))
  den <- N+z$te-z$mi+z$mi[j]
  frozen <- ifelse(valid&is.finite(z$mi)&is.finite(z$mi[j])&is.finite(den)&den>0,N/den,NA_real_)
  paired <- z$date>="2020-12-31"&z$date<="2022-12-31"&is.finite(official)&is.finite(frozen)
  edges <- round(seq(.4,1,.01),10); env$mid <- (head(edges,-1)+tail(edges,-1))/2
  stats <- read_output("t029_counterfactual_bunching")
  stats <- stats[stats$window=="post"&stats$variant=="all"&stats$scope=="paired"&stats$specification=="main",]
  env$fits <- list()
  for (metric in c("official", "frozen")) {
    x <- if(metric=="official")official[paired] else frozen[paired]
    ix <- findInterval(x,edges,rightmost.closed=TRUE)
    observed <- tabulate(ix[ix>0L&ix<length(edges)],nbins=length(edges)-1L)
    row <- stats[stats$metric==metric, ]
    stopifnot(nrow(row)==1L, length(x)==row$n, nf(z$firm_id[paired])==row$n_firms,
      sum(observed)==row$n_in_range)
    env$fits[[metric]] <- list(observed=observed, estimate=row$estimate,
      n=row$n,n_firms=row$n_firms,n_in_range=row$n_in_range)
  }
  env$cols <- c("#176B8E","#B24B3C","#6E7F3F","#8B5BA6")
  env$open_pdf <- function(name,width,height,title) times_target(paste0("t029_",name,".pdf"),width,height)
  draw_slice("code/11_mechanism.R", 'open_pdf("bunching_frozen",', 'open_pdf("distance_es",', env)
  # 4. Original matched constructed/published observations and keyed disagreements.
  env <- new.env(parent = globalenv())
  z <- read_output("t040_matched_observations")
  env$r <- z[z$ratio=="rl1"&is.finite(z$error), ]; env$dis <- read_output("t040_disagreements")
  stopifnot(nrow(env$r)==64L, nrow(env$dis)==6L)
  draw_slice("code/13_rl1_validation.R", "pdf('outputs/figures/t040_constructed_vs_published.pdf'", "# Output results with explicit", env,
    function(x) sub("pdf('outputs/figures/t040_constructed_vs_published.pdf',width=11,height=7,\n useDingbats=FALSE,timestamp=FALSE,title='T040 constructed and firm-published RL1')",
      'times_target("t040_constructed_vs_published.pdf",11,7)', x, fixed=TRUE))
  # 5. Exact previously simulated draws; no simulation is repeated.
  env <- new.env(parent = globalenv()); env$sim <- read_output("t043_meas_error_draws")
  z <- read_output("t023_excess_mass")
  env$b0 <- list(b=z$b[z$ratio=="rl1"&z$sample_rule=="main_sample"&
    z$period=="post"&z$threshold==.7&z$specification=="main"])
  stopifnot(length(env$b0$b)==1L)
  # The source uses temporary-file staging; replace only its device and publish call.
  draw_slice("code/15_referee2.R", "grDevices::pdf(f,width=10,height=8.5", "cat('T043 measurement error:", env,
    function(x) {
      x <- sub("grDevices::pdf(f,width=10,height=8.5,useDingbats=FALSE,timestamp=FALSE,title='T043 measurement-error perturbations')",
        'times_target("t043_meas_error.pdf",10,8.5)',x,fixed=TRUE)
      sub("; stage(f,'outputs/figures/t043_meas_error.pdf')", "", x, fixed=TRUE)
    })
  normalize_text <- function(path) {
    x <- paste(system2("pdftotext",shQuote(c(path,"-")),stdout=TRUE),collapse=" ")
    x <- gsub("\u2212", "-", x, fixed=TRUE)
    sort(strsplit(x,"[[:space:]]+")[[1]])
  }
  targets <- list.files(td,pattern="[.]pdf$",full.names=TRUE)
  stopifnot(length(targets)==5L)
  for (file in targets) {
    target <- file.path("outputs/figures",basename(file))
    stopifnot(identical(normalize_text(target), normalize_text(file)))
    fonts <- system2("pdffonts",shQuote(file),stdout=TRUE)
    stopifnot(any(grepl("TimesNewRoman",fonts)),!any(grepl("Arial|Helvetica|Nimbus",fonts)))
    stopifnot(file.copy(file,target,overwrite=TRUE))
    cat("T045 native Quartz/Times New Roman; text unchanged:",target,"\n")
  }
  stopifnot(identical(before_hash, tools::md5sum(files)))
  unlink(td,recursive=TRUE)
  cat("T045 font-only export complete; five retained figures; no numeric output changed.\n")
  quit(save="no",status=0L)
}

# T045 font-only export. Run from replication/:
# Rscript code/03_figures.R --embed-proposal-fonts
# Existing graphics, coordinates, widths and text are retained. The standard
# Helvetica resources are resolved to metrically compatible Arial TrueType and
# embedded. Only font-resource names are changed before Ghostscript pdfwrite.
# No analysis, input data or output table is read or written in this mode.
if ("--embed-proposal-fonts" %in% commandArgs(trailingOnly = TRUE)) {
  set.seed(20261030)
  gs <- Sys.which("gs"); stopifnot(nzchar(gs))
  fontdir <- "/System/Library/Fonts/Supplemental"
  faces <- c(ArialMT="Arial.ttf", `Arial-BoldMT`="Arial Bold.ttf",
             `Arial-ItalicMT`="Arial Italic.ttf", `Arial-BoldItalicMT`="Arial Bold Italic.ttf")
  stopifnot(all(file.exists(file.path(fontdir, faces))))
  td <- tempfile("t045_fonts_"); dir.create(td)
  fmap <- file.path(td,"Fontmap")
  writeLines(paste0("/",names(faces)," (",file.path(fontdir,faces),") ;"), fmap)
  old <- c("Helvetica-BoldOblique","Helvetica-Oblique","Helvetica-Bold","Helvetica")
  new <- c("Arial-BoldItalicMT","Arial-ItalicMT","Arial-BoldMT","ArialMT")
  names <- c("t023_excess_mass_rl1", "t029_bunching_frozen", "t027_decomposition_rl1",
             "t031_grid", "t041_bunching_by_date", "t040_constructed_vs_published",
             "t041_frozen_horizons", "t029_distance_es", "t043_meas_error")
  for (name in names) {
    target <- paste0("outputs/figures/",name,".pdf")
    input <- file.path(td,paste0(name,"_in.pdf")); output <- file.path(td,paste0(name,".pdf"))
    bytes <- readBin(target,"raw",n=file.info(target)$size)
    # Equal byte lengths preserve xref offsets. These names occur in uncompressed
    # PDF font dictionaries, not compressed drawing streams.
    for (j in seq_along(old)) {
      pat <- charToRaw(paste0("/",old[j])); hits <- grepRaw(pat,bytes,all=TRUE,fixed=TRUE)
      replacement <- charToRaw(paste0("/",new[j],strrep(" ",nchar(old[j])-nchar(new[j]))))
      for (h in hits) bytes[h+seq_along(pat)-1L] <- replacement
    }
    writeBin(bytes,input)
    args <- c("-q","-dBATCH","-dNOPAUSE","-sDEVICE=pdfwrite","-dEmbedAllFonts=true",
              "-dSubsetFonts=true",paste0("-sFONTMAP=",fmap),paste0("-sOutputFile=",output),input)
    stopifnot(system2(gs,shQuote(args))==0L)
    before <- system2("pdftotext",shQuote(c(target,"-")),stdout=TRUE)
    after <- system2("pdftotext",shQuote(c(output,"-")),stdout=TRUE)
    normalize_text <- function(x) sort(strsplit(gsub("\u2212", "-", paste(x,collapse=" "),fixed=TRUE),"[[:space:]]+")[[1]])
    stopifnot(identical(normalize_text(before),normalize_text(after)))
    fonts <- system2("pdffonts",shQuote(output),stdout=TRUE)
    stopifnot(!any(grepl("Helvetica|Nimbus|CMR[0-9]",fonts)))
    stopifnot(file.copy(output,target,overwrite=TRUE))
    cat("T045 embedded fonts; extracted text unchanged:",target,"\n")
  }
  # Recompile the unchanged PRISMA drawing with native text fonts. All node text,
  # counts, positions, colors and geometry are copied verbatim from the source.
  src <- readLines("../state/litsearch/prisma.tex",warn=FALSE)
  i <- grep("fontenc",src,fixed=TRUE); stopifnot(length(i)==1L)
  src[i] <- paste0("\\usepackage{newtxmath}\\usepackage[no-math]{fontspec}",
                   "\\setmainfont{Times New Roman}\\setsansfont{Times New Roman}",
                   "\\DeclareSymbolFont{operators}{OT1}{ntxtlf}{m}{n}")
  tex <- file.path(td,"prisma.tex"); writeLines(src,tex)
  stopifnot(system2("xelatex",shQuote(c("-interaction=nonstopmode",paste0("-output-directory=",td),tex)),
                    stdout=file.path(td,"prisma_build.log"),stderr=file.path(td,"prisma_build.err"))==0L)
  stopifnot(file.copy(file.path(td,"prisma.pdf"),"outputs/figures/prisma.pdf",overwrite=TRUE))
  cat("T045 PRISMA font-only XeLaTeX export: outputs/figures/prisma.pdf\n")
  unlink(td,recursive=TRUE)
  cat("T045 font-only export complete; no numeric output changed.\n")
  quit(save="no",status=0L)
}

# T005: descriptive evidence only. Run: cd replication && Rscript code/03_figures.R
# Inputs are read-only; all paths are relative to replication/.
source("code/00_setup.R", local = TRUE)
set.seed(20261016)
options(digits = 17)
suppressPackageStartupMessages(library(ggplot2))
panel_path <- "data/processed/panel_firm_halfyear.csv"
input_hash <- tools::md5sum(panel_path)
d <- read.csv(panel_path, stringsAsFactors = FALSE, na.strings = c("NA", ""))
variables <- c("rl1", "rl2", "rl2_adj", "rl3", "n_breached", "mi_share",
               "mi_gap", "jv_ta", "perp_te", "rl2_gap", "inv_ta", "log_ta")
required <- unique(c("firm_id", "date", "sample_main", "dose_pre", "market", "listing",
                     "soe", "b1", "b2", "b3", variables))
absent <- setdiff(required, names(d))
if (length(absent)) stop("STOP: missing columns: ", paste(absent, collapse = ", "))
d <- d[!is.na(d$sample_main) & d$sample_main, ]
d$date <- as.Date(d$date)
stopifnot(!anyDuplicated(d[c("firm_id", "date")]))
firms <- unique(d[c("firm_id", "dose_pre")])
stopifnot(!anyDuplicated(firms$firm_id))
firms <- firms[!is.na(firms$dose_pre), ]
stopifnot(all(firms$dose_pre >= 0 & firms$dose_pre <= 3))
# Keep the descriptive date at 2019-12-31, changing only the treatment groups.
baseline <- d[d$date == as.Date("2019-12-31") & !is.na(d$dose_pre), ]
stopifnot(!anyDuplicated(baseline$firm_id), all(baseline$firm_id %in% firms$firm_id))
baseline$dose_group <- floor(baseline$dose_pre + 0.5)
stopifnot(all(baseline$dose_group %in% 0:3))
pre <- d$date >= as.Date("2017-06-30") & d$date <= as.Date("2019-12-31")
post <- d$date >= as.Date("2020-12-31") & d$date <= as.Date("2022-12-31")
windows <- list(full = rep(TRUE, nrow(d)), pre = pre, post = post)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
# Stage every output, check all protected targets, then publish together.
# Only the by-dose table may replace an existing target after all gates pass.
staged_outputs <- list()
stage_output <- function(staged, target) {
  staged_outputs[[length(staged_outputs) + 1L]] <<- list(
    staged = staged, target = target,
    protected = !basename(target) %in% c("t005_by_dose.csv", "t005_by_dose.tex"))
}
write_csv <- function(x, name) {
  target <- paste0("outputs/tables/", name, ".csv")
  staged <- tempfile(fileext = ".csv")
  mtpa_write_csv(x, staged, row.names = FALSE, na = "NA")
  stage_output(staged, target)
}
stats <- function(x) {
  x <- x[!is.na(x)]
  stopifnot(all(is.finite(x)))
  c(N = length(x), mean = if (length(x)) mean(x) else NA_real_,
    SD = if (length(x) > 1L) sd(x) else NA_real_,
    setNames(if (length(x)) as.numeric(quantile(x, c(.1, .25, .5, .75, .9), type = 7))
             else rep(NA_real_, 5), c("p10", "p25", "median", "p75", "p90")))
}
summary_rows <- list()
for (period in names(windows)) for (v in variables) {
  take <- windows[[period]] & (v != "log_ta" | d$market == "A")
  summary_rows[[length(summary_rows) + 1L]] <- data.frame(
    period = period, variable = v, market_scope = if (v == "log_ta") "A only" else "A and HK",
    as.list(stats(d[[v]][take])), check.names = FALSE)
}
summary_table <- do.call(rbind, summary_rows)
write_csv(summary_table, "t005_summary_stats")

# LaTeX fragments require booktabs and threeparttable in the parent document.
escape_tex <- function(x) gsub("_", "\\_", x, fixed = TRUE)
fmt <- function(x) ifelse(is.na(x), "--", formatC(x, format = "f", digits = 4))
latex <- function(header, rows, note, name, align) {
  target <- paste0("outputs/tables/", name, ".tex")
  staged <- tempfile(fileext = ".tex")
  mtpa_write_lines(c("\\begin{threeparttable}", paste0("\\begin{tabular}{", align, "}"),
    "\\toprule", paste0(paste(header, collapse = " & "), " \\\\"), "\\midrule",
    rows, "\\bottomrule", "\\end{tabular}", "\\begin{tablenotes}[flushleft]",
    "\\footnotesize", paste0("\\item ", note), "\\end{tablenotes}",
    "\\end{threeparttable}"), staged)
  stage_output(staged, target)
}
summary_tex <- apply(summary_table, 1, function(r) paste0(paste(c(
  r["period"], escape_tex(r["variable"]), as.integer(r["N"]),
  fmt(as.numeric(r[c("mean", "SD", "p10", "p25", "median", "p75", "p90")]))),
  collapse = " & "), " \\\\"))
latex(c("Period", "Variable", "N", "Mean", "SD", "p10", "p25", "Median", "p75", "p90"),
  summary_tex,
  paste("Main sample (sample\\_main = TRUE), available firm-half-years; no winsorisation.",
        "Full: 2016H2--2022H2; pre: 2017H1--2019H2; post: 2020H2--2022H2.",
        "Each variable uses its nonmissing observations; log\\_ta uses A-shares only because HK currency is unresolved.",
        "SD is the sample standard deviation; quantiles use R type 7. Ratios are in levels.",
        "rl1 follows the processed panel's unverified definition; rl3 uses unrestricted cash only where available."),
  "t005_summary_stats", "llrrrrrrrr")

dose_vars <- c("rl1", "rl2", "rl3", "mi_share", "jv_ta", "perp_te", "log_ta")
group_stats <- function(b) {
  out <- c(firms = nrow(b), share_HK = mean(b$market == "HK"),
           share_delisted = mean(b$listing == "delisted"),
           soe_known = sum(!is.na(b$soe)),
           share_soe_among_known = if (all(is.na(b$soe))) NA_real_ else mean(b$soe, na.rm = TRUE))
  for (v in dose_vars) {
    x <- b[[v]][v != "log_ta" | b$market == "A"]
    s <- stats(x)
    out <- c(out, setNames(s[c("N", "mean", "median")], paste0(v, c("_N", "_mean", "_median"))))
  }
  out
}
by_dose <- data.frame(statistic = names(group_stats(baseline)), check.names = FALSE)
for (g in c("0", "1", "2", "3", "All")) {
  b <- if (g == "All") baseline else baseline[baseline$dose_group == as.integer(g), ]
  by_dose[[g]] <- unname(group_stats(b))
}
stopifnot(sum(as.numeric(by_dose[1, c("0", "1", "2", "3")])) == by_dose$All[1])
write_csv(by_dose, "t005_by_dose")
dose_tex <- vapply(seq_len(nrow(by_dose)), function(i) {
  values <- as.numeric(by_dose[i, -1])
  is_count <- by_dose$statistic[i] %in% c("firms", "soe_known") || grepl("_N$", by_dose$statistic[i])
  paste0(paste(c(escape_tex(by_dose$statistic[i]),
    if (is_count) as.character(as.integer(values)) else fmt(values)), collapse = " & "), " \\\\")
}, character(1))
latex(c("Statistic", "Dose 0", "Dose 1", "Dose 2", "Dose 3", "All"), dose_tex,
  paste("Main sample (sample\\_main = TRUE) with nonmissing dose\\_pre; one observation per firm at 31 December 2019.",
        "Groups use floor(dose\\_pre + 0.5) (0--3), rounding half-integers upward. dose\\_pre is mean breaches over 2017H1--2019H2 (at least 3 dates). All pools these four groups.",
        "Share delisted means listing = delisted in the Wind delisting list (delistings 2017--2024),",
        "not delisting by 2022. SOE share is among firms with known soe; soe\\_known gives that denominator.",
        "Variable-specific N is reported; log\\_ta uses A-shares only (HK currency unresolved).",
        "Shares and ratios are in levels. No winsorisation. rl1 definition remains unverified; rl3 uses all cash when restricted cash is missing."),
  "t005_by_dose", "lrrrrr")

# timestamp=FALSE (R >= 4.4) suppresses CreationDate/ModDate for byte-identical PDFs.
save_pdf <- function(plot, file) {
  staged <- tempfile(fileext = ".pdf")
  grDevices::pdf(staged, width = 6.5, height = 4,
                 useDingbats = FALSE, timestamp = FALSE, title = "T005 descriptive evidence")
  print(plot)
  invisible(dev.off())
  stage_output(staged, paste0("outputs/figures/", file, ".pdf"))
}
base_theme <- theme_minimal(base_size = 10) + theme(
  legend.position = "top", legend.title = element_blank(),
  plot.caption = element_text(size = 7.5, hjust = 0),
  plot.title = element_text(size = 12), panel.grid.minor = element_blank())
specs <- list(rl1 = c(low = .30, high = 1.10, width = .02, threshold = .70),
              rl2 = c(low = -.50, high = 3, width = .05, threshold = 1),
              rl3 = c(low = 0, high = 3, width = .05, threshold = 1))
labels <- c(rl1 = "Liabilities net of advances / assets net of advances",
            rl2 = "Net debt / total equity", rl3 = "Cash / short-term debt")
bunching <- list()
for (v in names(specs)) {
  s <- specs[[v]]
  edges <- seq(s["low"], s["high"], by = s["width"])
  # Snap numerical roundoff at exact decimal edges; intervals are [left,right), final right included.
  edges <- round(edges, 10)
  stopifnot(any(abs(edges - s["threshold"]) < 1e-12),
            max(abs(diff(edges) - s["width"])) < 1e-12)
  fig_rows <- list(); notes <- character()
  for (period in c("pre", "post")) {
    raw <- d[[v]][windows[[period]]]
    x <- raw[!is.na(raw)]
    stopifnot(all(is.finite(x)), length(x) > 0)
    # findInterval leaves out-of-range observations visible as indices 0 / length(edges).
    ix <- findInterval(x, edges, rightmost.closed = TRUE)
    counts <- tabulate(ix[ix > 0 & ix < length(edges)], nbins = length(edges) - 1L)
    below <- sum(x < s["low"]); above <- sum(x > s["high"])
    stopifnot(sum(counts) + below + above == length(x))
    k <- which(abs(edges - s["threshold"]) < 1e-12)
    # The two adjacent bins: one below and one above (the requested +/-1-bin window).
    near <- c(counts[k - 1L], counts[k])
    rows <- data.frame(ratio = v, period = period, row_type = "bin",
      bin = seq_along(counts), lower = head(edges, -1), upper = tail(edges, -1),
      count = counts, share = counts / length(x), n_nonmissing = length(x), n_missing = sum(is.na(raw)))
    special <- data.frame(ratio = v, period = period,
      row_type = c("outside_below", "outside_above", "threshold_below", "threshold_above", "within_one_bin"),
      bin = NA_integer_,
      lower = c(-Inf, s["high"], s["threshold"] - s["width"], s["threshold"], s["threshold"] - s["width"]),
      upper = c(s["low"], Inf, s["threshold"], s["threshold"] + s["width"], s["threshold"] + s["width"]),
      count = c(below, above, near, sum(near)),
      share = c(below, above, near, sum(near)) / length(x),
      n_nonmissing = length(x), n_missing = sum(is.na(raw)))
    bunching[[length(bunching) + 1L]] <- rbind(rows, special)
    fig_rows[[period]] <- rows
    notes <- c(notes, sprintf("%s: N=%d; outside=%d (below=%d, above=%d); missing=%d.",
                    if (period == "pre") "Pre" else "Post", length(x), below + above, below, above, sum(is.na(raw))))
    cat(sprintf("%s %s: within +/-1 bin %d/%d = %.10f; outside %d (below %d, above %d); missing %d\n",
                v, period, sum(near), length(x), sum(near)/length(x), below+above, below, above, sum(is.na(raw))))
  }
  plot_data <- do.call(rbind, fig_rows)
  plot_data$period <- factor(plot_data$period, levels = c("pre", "post"),
    labels = c("Pre: 2017H1-2019H2", "Post: 2020H2-2022H2"))
  caveat <- if (v == "rl1") "rl1 definition follows the processed panel (unverified)." else if (v == "rl3")
    "Cash includes restricted cash when its breakdown is unavailable." else ""
  p <- ggplot(plot_data, aes(x = (lower + upper)/2, y = share, fill = period)) +
    geom_col(position = position_dodge(width = s["width"]), width = s["width"] * .94,
             colour = "black", linewidth = .15) +
    geom_vline(xintercept = s["threshold"], linetype = "dashed", linewidth = .5) +
    scale_fill_manual(values = c("white", "grey40")) +
    scale_x_continuous(limits = c(s["low"], s["high"]), expand = expansion(mult = .002),
                       labels = function(x) sprintf("%.1f", x),
                       oob = scales::oob_keep) +
    scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
    labs(title = paste0("Distribution of ", v, " before and after the policy"),
         x = labels[[v]], y = "Share of nonmissing observations",
         caption = paste(c("Main sample. Shares include out-of-range observations in the denominator.", notes,
              "Bins [left, right); final right edge included. Transition 2020H1 excluded.", caveat), collapse = "\n")) + base_theme
  save_pdf(p, paste0("t005_bunching_", v))
}
bunching_table <- do.call(rbind, bunching)
write_csv(bunching_table, "t005_bunching_counts")

dates <- sort(unique(d$date))
stopifnot(length(dates) == 13L)
series <- c(b1 = "Line 1 breached", b2 = "Line 2 breached", b3 = "Line 3 breached", n_breached = "No lines breached")
breaches <- list()
for (day in as.character(dates)) for (v in names(series)) {
  x <- d[[v]][d$date == as.Date(day)]
  if (v == "n_breached") x <- as.numeric(x == 0)
  breaches[[length(breaches) + 1L]] <- data.frame(date = as.Date(day), series = series[[v]],
    share = mean(x, na.rm = TRUE), N = sum(!is.na(x)))
}
breaches <- do.call(rbind, breaches)
breaches$series <- factor(breaches$series, levels = unname(series))
denom_ranges <- vapply(unname(series), function(label) {
  n <- breaches$N[breaches$series == label]
  sprintf("%s: %d-%d", label, min(n), max(n))
}, character(1))
p <- ggplot(breaches, aes(date, share, linetype = series, shape = series)) +
  geom_line(colour = "black", linewidth = .5) + geom_point(colour = "black", size = 1.7) +
  geom_vline(xintercept = as.Date("2020-08-20"), linetype = "dashed", colour = "grey40") +
  scale_linetype_manual(values = c("solid", "dashed", "dotted", "dotdash")) +
  scale_shape_manual(values = c(16, 17, 15, 1)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(labels = scales::label_percent(accuracy = 1), limits = c(0, 1)) +
  guides(linetype = guide_legend(nrow = 2), shape = guide_legend(nrow = 2)) +
  labs(title = "Red-line breach shares over time", x = "Reporting date", y = "Share of firms",
    caption = paste("Main sample, all 13 dates; available cases per series and date. Dashed line: Aug 2020 policy.",
      paste("Denominator ranges:", paste(denom_ranges[1:2], collapse = "; ")),
      paste(denom_ranges[3:4], collapse = "; "),
      "No lines breached requires all three ratios. rl1 definition unverified; restricted cash partly unavailable.", sep = "\n")) + base_theme
save_pdf(p, "t005_breach_shares")
stopifnot(identical(input_hash, tools::md5sum(panel_path)))
# Validate every protected file before publishing any output.
for (x in staged_outputs) {
  if (!x$protected) next
  if (tolower(tools::file_ext(x$target)) == "pdf")
    mtpa_guard_pdf(x$staged, x$target)
  else if (file.exists(x$target))
    mtpa_guard(identical(mtpa_sha256(x$staged), mtpa_sha256(x$target)),
               paste0("STOP: protected T005 output differs: ", x$target))
}
for (x in staged_outputs) {
  # Retain protected targets even when the optional warning mode is enabled.
  if (x$protected && file.exists(x$target)) next
  if (!file.exists(x$target) ||
      !identical(mtpa_sha256(x$staged), mtpa_sha256(x$target)))
    stopifnot(file.copy(x$staged, x$target, overwrite = !x$protected))
}
unlink(vapply(staged_outputs, `[[`, character(1), "staged"))
cat("Dose sizes:", paste(paste0(0:3, "=", as.integer(table(factor(baseline$dose_group, levels = 0:3)))) , collapse = ", "), "; All=", nrow(baseline), "\n", sep = "")
cat("T012: wrote by-dose CSV/TEX; protected summary/bunching/breach-share outputs checked (see any guard warnings); 13 breach-share dates.\n")
cat("Panel unchanged (MD5):", unname(input_hash), "\n")
