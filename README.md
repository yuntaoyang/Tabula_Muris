# Tabula_Muris
## Introduction
* This Git repo reproduces marker genes for each tissue and cell type of the Tabula Muris dataset.
* **Reference**: Single-cell transcriptomics of 20 mouse organs creates a Tabula Muris.
## Steps
* Download and install Seurat-4.4.0.tar.gz from `https://github.com/satijalab/seurat/archive/refs/tags/v4.4.0.tar.gz`
    * Seurat v5 encounters an issue with UpdateSeuratObject().
    * Install Seurat v4.4.0 from the source code.
* Download Robjects of the Tabula Muris dataset from `https://figshare.com/articles/dataset/Robject_files_for_tissues_processed_by_Seurat/5821263`
and save them in `./Robjects`.
* Run the R script `Rscript FindAllMarkers.R`.
## Outputs
* Marker genes of each Robject `./markers/*_seurat_tiss.csv`.
* A summary for number of markers in each Robject`./markers/summary.csv`.