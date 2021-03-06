% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/timsr.R
\name{MS1}
\alias{MS1}
\title{Get MS1 frame numbers.}
\usage{
MS1(timsr)
}
\arguments{
\item{timsr}{Instance of TimsR}
}
\value{
Numbers of frames corresponding to MS1, i.e. precursor ions.
}
\description{
Get MS1 frame numbers.
}
\examples{
\dontrun{
D = TimsR('path/to/your/folder.d')
print(MS1(D)) 
}
}
