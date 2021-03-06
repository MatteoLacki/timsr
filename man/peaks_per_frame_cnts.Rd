% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/timsr.R
\name{peaks_per_frame_cnts}
\alias{peaks_per_frame_cnts}
\title{Get the number of peaks per frame.}
\usage{
peaks_per_frame_cnts(timsr)
}
\arguments{
\item{timsr}{Instance of TimsR.}
}
\value{
Number of peaks in each frame.
}
\description{
Get the number of peaks per frame.
}
\examples{
\dontrun{
D = TimsR('path/to/your/folder.d')
print(peaks_per_frame_cnts(D)) 
}
}
