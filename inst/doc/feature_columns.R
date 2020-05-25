## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  eval = (identical(Sys.getenv("EVAL_VIGNETTE", "false"), "true") || identical(Sys.getenv("CI"), "true")) && (tensorflow::tf_version() >= "2.0")
) 

## -----------------------------------------------------------------------------
library(tfdatasets)
hearts_dataset <- tensor_slices_dataset(hearts)
spec <- feature_spec(hearts_dataset, target ~ .)

## -----------------------------------------------------------------------------
spec %>% 
  step_numeric_column(age)

## ---- eval=FALSE--------------------------------------------------------------
#  # Represent a 10-element vector in which each cell contains a tf$float32.
#  spec %>%
#    step_numeric_column(bowling, shape = 10)
#  
#  # Represent a 10x5 matrix in which each cell contains a tf$float32.
#  spec %>%
#    step_numeric_column(my_matrix, shape = c(10, 5))

## ---- eval=FALSE--------------------------------------------------------------
#  # use a function that defines tensorflow ops.
#  spec %>%
#    step_numeric_column(age, normalizer_fn = function(x) (x-10)/5)
#  
#  # use a scaler
#  spec %>%
#    step_numeric_column(age, normalizer_fn = scaler_standard())

## -----------------------------------------------------------------------------
# First, convert the raw input to a numeric column.
spec <- spec %>% 
  step_numeric_column(age)

# Then, bucketize the numeric column.
spec <-  spec %>% 
  step_bucketized_column(age, boundaries = c(30, 50, 70))

## ---- eval=FALSE--------------------------------------------------------------
#  # Create categorical output for an integer feature named "my_feature_b",
#  # The values of my_feature_b must be >= 0 and < num_buckets
#  spec <- spec %>%
#    step_categorical_column_with_identity(my_feature_b, num_buckets = 4)

## -----------------------------------------------------------------------------
spec <- spec %>% 
  step_categorical_column_with_vocabulary_list(
    thal, 
    vocabulary_list = c("fixed", "normal", "reversible")
  )

## ---- eval=FALSE--------------------------------------------------------------
#  spec <- spec %>%
#    step_categorical_column_with_vocabulary_file(thal, vocabulary_file = "thal.txt")

## -----------------------------------------------------------------------------
spec <- spec %>% 
  step_categorical_column_with_hash_bucket(thal, hash_bucket_size = 100)

## ---- eval=FALSE--------------------------------------------------------------
#  spec <- feature_spec(dataset, target ~ latitute + longitude) %>%
#    step_numeric_column(latitude, longitude) %>%
#    step_bucketized_column(latitude, boundaries = c(latitude_edges)) %>%
#    step_bucketized_column(longitude, boundaries = c(longitude_edges)) %>%
#    step_crossed_column(latitude_longitude = c(latitude, longitude), hash_bucket_size = 100)

## ---- eval=FALSE--------------------------------------------------------------
#  spec <- feature_spec(dataset, target ~ .) %>%
#    step_categorical_column_with_vocabulary_list(product_class) %>%
#    step_indicator_column(product_class)

## ---- eval=FALSE--------------------------------------------------------------
#  spec <- feature_spec(dataset, target ~ .) %>%
#    step_categorical_column_with_vocabulary_list(product_class) %>%
#    step_embedding_column(product_class, dimension = 3)

## -----------------------------------------------------------------------------
library(keras)
library(dplyr)

spec <- feature_spec(hearts, target ~ .) %>% 
  step_numeric_column(
    all_numeric(), -cp, -restecg, -exang, -sex, -fbs,
    normalizer_fn = scaler_standard()
  ) %>% 
  step_categorical_column_with_vocabulary_list(thal) %>% 
  step_bucketized_column(age, boundaries = c(18, 25, 30, 35, 40, 45, 50, 55, 60, 65)) %>% 
  step_indicator_column(thal) %>% 
  step_embedding_column(thal, dimension = 2) %>% 
  step_crossed_column(c(thal, bucketized_age), hash_bucket_size = 10) %>%
  step_indicator_column(crossed_thal_bucketized_age)

spec <- fit(spec)

input <- layer_input_from_dataset(hearts %>% select(-target))
output <- input %>% 
  layer_dense_features(feature_columns = dense_features(spec)) %>% 
  layer_dense(units = 1, activation = "sigmoid")

model <- keras_model(input, output)

model %>% 
  compile(
    loss = "binary_crossentropy", 
    optimizer = "adam",
    metrics = "accuracy"
    )

model %>% 
  fit(
    x = hearts %>% select(-target), y = hearts$target,
    validation_split = 0.2
  )

