% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/timsr.R
\name{intensity_per_frame}
\alias{intensity_per_frame}
\title{Get sum of intensity per each frame (retention time).}
\usage{
intensity_per_frame(timsr, recalibrated = TRUE)
}
\arguments{
\item{timsr}{Instance of TimsR}

\item{recalibrated}{Use Bruker recalibrated total intensities or calculate them from scratch with OpenTIMS?}
}
\value{
integer vector: total intensity per each frame.
}
\description{
Get sum of intensity per each frame (retention time).
}
\examples{
\dontrun{
D = TimsR('path/to/your/folder.d')
print(intensity_per_frame(D))
print(intensity_per_frame(D, recalibrated=FALSE)) 
}
}
