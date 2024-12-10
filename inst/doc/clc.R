## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(clc)

source_gpkg <- system.file("extdata", "clc.gpkg", package = "clc")

clc_data <- clc(source = source_gpkg, layer_name = "clc")

## ----setup2, eval=FALSE-------------------------------------------------------
# library(clc)
# 
# conn <- RPostgres::dbConnect(
#   RPostgres::Postgres(),
#   dbname = 'exampledb',
#   host = 'localhost',
#   port = '5432',
#   user = 'user',
#   password = 'password'
# )
# 
# clc_data <- clc(source = conn, layer_name = "clc")
# 
# DBI::dbDisconnect(conn)

## ----example-1, fig.width=10, fig.height=7, dpi=300, out.width="100%", fig.align='center', fig.alt="CLC example 1, original"----
clc_data |> 
  plot_clc()

## ----example-1-1, fig.width=10, fig.height=7, dpi=300, out.width="100%", fig.align='center', fig.alt="CLC example 1, original with prepare plot"----
p <- clc_data |>
  prepare_plot()

levels <- clc_data |>
  get_levels()

p <- p +
  ggplot2::scale_fill_manual(
    values = stats::setNames(levels$color, levels$id),
    labels = stats::setNames(levels$description, levels$id),
    name = ""
  ) +
  ggplot2::theme(
    legend.position = "right",
    legend.key.height = ggplot2::unit(2, "cm"),
    legend.title = ggplot2::element_text(size = 12),
    legend.text = ggplot2::element_text(size = 10)
  ) +
  ggplot2::theme_minimal()

p

## ----example-2, fig.width=10, fig.height=7, dpi=300, out.width="100%", fig.align='center', fig.alt="CLC example 2, clipped"----
# Read the clipping layer (region of interest)
region <- sf::st_read(source_gpkg, layer = "lanjaron", quiet = TRUE)

# Clip the CLC data to the region of interest
clc_clipped <- clc_data |> 
  cut_to_extent(region)

# Visualize the clipped CLC data with its associated style
clc_clipped |> 
  plot_clc()

## ----example-4----------------------------------------------------------------
# Define the output GeoPackage file
output_gpkg <- tempfile(fileext = ".gpkg")

# Capture output to suppress messages (optional)
sink(tempfile())

# Save the clipped data and its styles to the new GeoPackage
clc_clipped |> 
  save_to(output_gpkg)

# Stop capturing output
sink()

## ----example-4-2, eval=FALSE--------------------------------------------------
# conn <- RPostgres::dbConnect(
#   RPostgres::Postgres(),
#   dbname = 'exampledb2',
#   host = 'localhost',
#   port = '5432',
#   user = 'user',
#   password = 'password'
# )
# 
# clc_clipped |>
#   save_to(conn, 'exampledb2')
# 
# DBI::dbDisconnect(conn)

## ----example-4-3, fig.width=10, fig.height=7, dpi=300, out.width="100%", fig.align='center', fig.alt="CLC example 3, copying styles"----
# Create a new GeoPackage without style definition
destination_gpkg <- tempfile(fileext = ".gpkg")
clc_layer <- sf::st_read(source_gpkg, layer = "clc", quiet = TRUE)
sf::st_write(
  clc_layer,
  destination_gpkg,
  layer = "clc2",
  delete_layer = TRUE,
  quiet = TRUE
)

# Copy the style to the new GeoPackage
clc_clipped |>
  copy_to(to = destination_gpkg, layers = "clc2")

# Create a clc object from the new GeoPackage and view it
clc_data2 <- clc(source = destination_gpkg, layer_name = "clc2")

clc_data2 |>
  plot_clc()

## ----example-3----------------------------------------------------------------
raster_path <- system.file("extdata", "mdt.tif", package = "clc")
base_raster <- terra::rast(raster_path)

clc_raster1 <- clc_clipped |> 
  as_raster(base_raster = base_raster)

## ----example-3-2--------------------------------------------------------------
clc_raster2 <- clc_clipped |> 
  as_raster(resolution = 50)

## ----example-3-3, fig.width=10, fig.height=7, dpi=300, out.width="100%", fig.align='center', fig.alt="CLC example 4, raster"----
clc_raster1 |> 
  plot_clc()

## ----example-5----------------------------------------------------------------
clc_r <- clc_raster1 |>
  get_raster()

output_tif <- tempfile(fileext = ".tif")
terra::writeRaster(clc_r,
                   output_tif,
                   filetype = "GTiff",
                   overwrite = TRUE)

