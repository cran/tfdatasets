% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataset_methods.R
\name{dataset_unique}
\alias{dataset_unique}
\title{A transformation that discards duplicate elements of a Dataset.}
\usage{
dataset_unique(dataset, name = NULL)
}
\arguments{
\item{dataset}{A tf.Dataset.}

\item{name}{(Optional.) A name for the tf.data operation.}
}
\value{
A tf.Dataset
}
\description{
Use this transformation to produce a dataset that contains one instance of
each unique element in the input (See example).
}
\note{
This transformation only supports datasets which fit into memory and
have elements of either tf.int32, tf.int64 or tf.string type.
}
\examples{
\dontrun{
c(0, 37, 2, 37, 2, 1) \%>\% as_tensor("int32") \%>\%
  tensor_slices_dataset() \%>\%
  dataset_unique() \%>\%
  as_array_iterator() \%>\% iterate() \%>\% sort()
# [1]  0  1  2 37
}
}
