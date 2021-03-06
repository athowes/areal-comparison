#' Uncomment and run the two line below to resume development of this script
# orderly::orderly_develop_start("1_fit_ck-stan")
# setwd("src/1_fit_ck-stan")

vignette_geometries <- as.character(1:4)
realistic_geometries <- c("grid", "civ", "tex")

geometries <- c()
if(vignette) geometries <- c(geometries, vignette_geometries)
if(realistic) geometries <- c(geometries, realistic_geometries)
if(length(geometries) == 0) stop("Either vignette or realistic must be TRUE")

sim_models <- c("iid", "icar", "ik")

#' Prevent orderly complaining if I don't produce all simulations all of the time
lapply(
  expand.grid(
    "sim_model" = sim_models,
    "geometry" = c(vignette_geometries, realistic_geometries)
  ) %>%
    as.data.frame() %>%
    mutate(file = paste0("fits_", sim_model, "_", geometry, ".rds")) %>%
    pull(file),
  function(file) saveRDS(NULL, file)
)

#' Geometry and simulation model
pars <- expand.grid(
  "geometry" = geometries,
  "sim_model" = sim_models
)

#' Initialise progress bar
pb <- progress_estimated(nrow(pars))

#' Function to run bsae::ck_stan
run_models <- function(geometry, sim_model) {
  pb$tick()$print()

  #' This model can't handle the concentric circles case!
  if(geometry == "2") return(NULL)

  data <- readRDS(paste0("depends/data_", sim_model, "_", geometry, ".rds"))
  fits <- lapply(data, function(x) bsae::ck_stan(x$sf))
  saveRDS(fits, file = paste0("fits_", sim_model, "_", geometry, ".rds"))
}

# Run models and save for each row of pars
purrr::pmap_df(pars, run_models)
