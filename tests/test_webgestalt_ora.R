# Test WebGestaltR ora

library(WebGestaltR)
library(tidyverse)
library(org.Hs.eg.db)
library(sigora)
library(GO.db)
library(slam)
library(prora)

dd <- prora::exampleContrastData
dfiles <- "example_data.txt"

# Parameters --------------------------------------------------------------

organism <- "hsapiens"
ID_col <- "UniprotID"
fc_col <- "estimate"
target_GSEA <- c(
  "geneontology_Biological_Process",
  "geneontology_Cellular_Component",
  "geneontology_Molecular_Function"
)
fc_threshold <- 0.5
greater <- TRUE
nperm <- 10


# Run ---------------------------------------------------------------------

fpath_se <- tools::file_path_sans_ext(basename(dfiles))
odir <- make.names(fpath_se)

if (!dir.exists(odir)) {
  dir.create(odir)
}

colnames(dd) <- make.names(colnames(dd))
dd <- get_UniprotID_from_fasta_header(dd) %>%
  filter(!is.na(UniprotID))

sapply(target_GSEA, function(x) {
  prora::runWebGestaltORA(
    data = dd,
    fpath = "",
    organism = organism,
    ID_col = ID_col,
    target = x,
    threshold = fc_threshold,
    greater = greater,
    nperm = nperm,
    score_col = fc_col,
    outdir = file.path(odir, "WebGestaltORA")
  )
})
