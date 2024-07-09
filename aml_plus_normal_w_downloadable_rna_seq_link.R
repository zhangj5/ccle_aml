library(dplyr)
library(here)


sample <- read.delim("sample_info.csv", sep = ",")

ccle_aml<-
  sample %>% filter(primary_disease == "Leukemia") %>% filter(grepl("AML", Subtype))

ccle_normal_from_hematopoietic_tissue<-
  sample %>%  filter(primary_disease == "Non-Cancerous") %>%  filter(sample_collection_site == "haematopoietic_and_lymphoid_tissue")

ccle_aml_or_normal_from_hematopoietic=rbind(ccle_aml,ccle_normal_from_hematopoietic_tissue)


ccle_w_downloadable_rna_seq=read.delim("sample.txt") %>% mutate(DepMap_ID=entity.sample_id)

ccle_aml_w_rna_seq<-ccle_aml_or_normal_from_hematopoietic %>% left_join(ccle_w_downloadable_rna_seq,by="DepMap_ID") %>% filter(hg38_rna_bam!="")

write.table(ccle_aml_w_rna_seq, file = here("ccle_aml","samples_with_rna_seq_downloadable_link.tsv"),sep="\t", quote = FALSE, row.names = FALSE)
