metric_map <- function(sf, metric, remove_constant = TRUE) {

  if(remove_constant) {
    sf <- filter(sf, inf_model != "Constant")
  }

  sf %>%
    split(.$survey) %>%
    lapply(function(x) {
      x %>%
        ggplot(aes(fill = .data[[metric]])) +
        geom_sf(size = 0.1, colour = scales::alpha("grey", 0.25)) +
        scale_fill_viridis_c(option = "C") +
        facet_grid(~ inf_model) +
        theme_minimal() +
        labs(fill = toupper(metric), title = x$survey_id[1]) +
        theme(
          axis.title.x = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          axis.title.y = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          strip.text = element_text(face = "bold"),
          plot.title = element_text(face = "bold"),
          legend.position = "bottom",
          legend.key.width = unit(4, "lines")
        )
    })
}
