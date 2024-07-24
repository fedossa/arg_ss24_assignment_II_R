library(dplyr)
library(readr)
library(readxl)
library(tidyr)
library(forcats)


main <- function() {
  data <- load_data()
  penman_table <- data[[1]]
  merged_data <- merge_data(data[[2]], data[[3]])
  df <- add_pb_and_ri(merged_data)
  replication_results <- group_and_summarize(df)
  save(list = c("penman_table", "replication_results"), file = "output/results.rda")
}

load_data <- function() {
  penman_table <- read_csv("data/external/penman_2013_results.csv") %>%
    mutate(pb_group = factor(pb_group))
  wscp_static <- read_tsv("data/external/wscp_static.txt")
  wscp_panel <- read_excel("data/external/wscp_panel.xlsx")
  return(list(penman_table, wscp_panel, wscp_static))
}


merge_data <- function(wscp_panel, wscp_static) {
  wscp_static_us <- wscp_static %>% 
    filter(country == "UNITED STATES")
  df <- inner_join(wscp_panel, wscp_static_us |> select(isin), by = "isin")
  return(df)
}

mleadlag <- function(x, n, ts_id) {
  pos <- match(as.numeric(ts_id) + n, as.numeric(ts_id))
  return(x[pos])
}

add_pb_and_ri <- function(df) {
  df <- df %>%
    filter(mve > 0, bve > 0) %>%
    mutate(
      firmid = as.numeric(as.factor(isin)),
      year = as.numeric(year_),
      pb = mve / bve
    ) %>%
    group_by(firmid) %>%
    mutate(
        l_bve = mleadlag(bve, -1, year),
        ri = ninc - 0.10 * l_bve
    )

  for (i in 0:6) {
    df <- df %>%
    group_by(firmid) %>%
    mutate(!!paste0("ri_", i) := mleadlag(ri, i, year) / bve)
  }

  df <- drop_na(df, starts_with("ri_"))
  return(df)
}


group_and_summarize <- function(df) {
  quantiles <- quantile(df$pb, probs = seq(0, 1, 1/20), na.rm = FALSE)
  
  df <- df %>%
    mutate(
      pb_group = cut(pb, breaks = quantiles, include.lowest = TRUE, labels = 20:1)
    ) %>%
    group_by(pb_group) %>%
    summarise(
        pb = median(pb, na.rm = TRUE),
        across(starts_with("ri_"), \(x) median(x, na.rm = TRUE))
    ) %>%
    ungroup() %>%
    arrange(desc(pb))

  return(df)
}

main()