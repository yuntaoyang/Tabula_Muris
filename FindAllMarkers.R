#---- R environment ------------------------------------------------------------
# install.packages("seurat-4.4.0.tar.gz", repos = NULL, type = "source")
# install.packages('dplyr')
library(Seurat)
library(dplyr)
#---- List all the Robjects ----------------------------------------------------
files <- dir(path = "./Robjects", full.names = TRUE)
#---- Summary data  ------------------------------------------------------------
summary_list <- vector("list", length(files))
#---- Find markers -------------------------------------------------------------
results <- lapply(seq_along(files), function(i) {
  file <- files[i]
  # Load the Seurat object
  load(file)
  seurat_obj <- UpdateSeuratObject(object = tiss)
  # Update identity classes based on 'cell_ontology_class'
  Idents(seurat_obj) <- seurat_obj@meta.data$cell_ontology_class
  # Find cell ontology id
  cell_ontology <- seurat_obj@meta.data %>%
    select(cell_ontology_class, cell_ontology_id) %>%
    distinct()
  # Find all markers
  markers <- FindAllMarkers(seurat_obj, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25) %>%
    left_join(cell_ontology, by = c("cluster" = "cell_ontology_class")) %>%
    select(cluster, cell_ontology_id, gene, p_val, p_val_adj, avg_log2FC, pct.1, pct.2) %>%
    rename(cell_ontology_class = cluster)
  # Write markers to CSV
  output_file <- gsub("Robjects/(.*)\\.Robj$", "markers/\\1.csv", file)
  write.csv(markers, output_file, row.names = FALSE)
  # Summary cell_ontology_class
  class_summary <- table(markers$cell_ontology_class)
  class_summary_df <- as.data.frame(class_summary)
  names(class_summary_df) <- c("cell_ontology_class", "number")
  class_summary_df$file <- basename(file)
  return(class_summary_df)
  }
)
#---- Combine summaries --------------------------------------------------------
df_summary <- do.call(rbind, results)
write.csv(df_summary, "./markers/markers.csv", row.names = FALSE)
