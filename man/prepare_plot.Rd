% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clc.R
\name{prepare_plot}
\alias{prepare_plot}
\alias{prepare_plot.clc}
\title{Prepare a Plot for CLC Vectorial Data}
\usage{
prepare_plot(clo)

\method{prepare_plot}{clc}(clo)
}
\arguments{
\item{clo}{A `clc` object.}
}
\value{
A `ggplot2` object ready for rendering.
}
\description{
Generates a `ggplot2` object to visualize CLC Vectorial data. The function
processes the data stored in a `clc` object, ensuring that the codes field is
mapped correctly to the categories and their associated styles.
}
\examples{
source_gpkg <- system.file("extdata", "clc.gpkg", package = "clc")
clo <- clc(source = source_gpkg, layer_name = "clc")

p <- clo |>
  prepare_plot()

levels <- clo |>
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

temp_file <- tempfile(fileext = ".png")
png(filename = temp_file, width = 800, height = 600)

p

dev.off()

}
\seealso{
\code{\link{plot_clc}}

Other CLC class functions: 
\code{\link{as_raster}()},
\code{\link{clc}()},
\code{\link{copy_to}()},
\code{\link{cut_to_extent}()},
\code{\link{get_colors.clc}()},
\code{\link{get_levels.clc}()},
\code{\link{get_raster}()},
\code{\link{plot_clc}()},
\code{\link{save_to}()}
}
\concept{CLC class functions}
