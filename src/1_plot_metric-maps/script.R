#' Uncomment and run the two line below to resume development of this script
# orderly::orderly_develop_start("1_plot_metric-maps")
# setwd("src/1_plot_metric-maps")

#' Get geometries for mapping
civ <- readRDS("depends/civ.rds")
grid <- readRDS("depends/grid.rds")
tex <- readRDS("depends/tex.rds")
geometry_1 <- readRDS("depends/geometry-1.rds")
geometry_2 <- readRDS("depends/geometry-2.rds")
geometry_3 <- readRDS("depends/geometry-3.rds")
geometry_4 <- readRDS("depends/geometry-4.rds")

df_rho <- readRDS("depends/df_rho.rds")

pdf("crps-maps.pdf", h = 4, w = 6.25)

produce_maps("civ", civ, "crps")
produce_maps("grid", grid, "crps")
produce_maps("tex", tex, "crps")
produce_maps("1", geometry_1, "crps")
produce_maps("2", geometry_2, "crps")
produce_maps("3", geometry_3, "crps")
produce_maps("4", geometry_4, "crps")

dev.off()

pdf("mse-maps.pdf", h = 4, w = 6.25)

produce_maps("civ", civ, "mse")
produce_maps("grid", grid, "mse")
produce_maps("tex", tex, "mse")
produce_maps("1", geometry_1, "mse")
produce_maps("2", geometry_2, "mse")
produce_maps("3", geometry_3, "mse")
produce_maps("4", geometry_4, "mse")

dev.off()

pdf("mae-maps.pdf", h = 4, w = 6.25)

produce_maps("civ", civ, "mae")
produce_maps("grid", grid, "mae")
produce_maps("tex", tex, "mae")
produce_maps("1", geometry_1, "mae")
produce_maps("2", geometry_2, "mae")
produce_maps("3", geometry_3, "mae")
produce_maps("4", geometry_4, "mae")

dev.off()
