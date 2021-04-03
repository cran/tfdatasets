## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  eval = (identical(Sys.getenv("EVAL_VIGNETTE", "false"), "true") || identical(Sys.getenv("CI"), "true")) && (tensorflow::tf_version() >= "2.0")
) 

## -----------------------------------------------------------------------------
#  library(tfdatasets)
#  library(dplyr)
#  data(hearts)

## -----------------------------------------------------------------------------
#  head(hearts)

## -----------------------------------------------------------------------------
#  ids_train <- sample.int(nrow(hearts), size = 0.75*nrow(hearts))
#  hearts_train <- hearts[ids_train,]
#  hearts_test <- hearts[-ids_train,]

## -----------------------------------------------------------------------------
#  spec <- feature_spec(hearts_train, target ~ .)

## -----------------------------------------------------------------------------
#  spec <- spec %>%
#    step_numeric_column(
#      all_numeric(), -cp, -restecg, -exang, -sex, -fbs,
#      normalizer_fn = scaler_standard()
#    ) %>%
#    step_categorical_column_with_vocabulary_list(thal)

## -----------------------------------------------------------------------------
#  spec

## -----------------------------------------------------------------------------
#  spec <- spec %>%
#    step_bucketized_column(age, boundaries = c(18, 25, 30, 35, 40, 45, 50, 55, 60, 65))

## -----------------------------------------------------------------------------
#  spec <- spec %>%
#    step_indicator_column(thal) %>%
#    step_embedding_column(thal, dimension = 2)

## -----------------------------------------------------------------------------
#  spec <- spec %>%
#    step_crossed_column(thal_and_age = c(thal, bucketized_age), hash_bucket_size = 1000) %>%
#    step_indicator_column(thal_and_age)

## -----------------------------------------------------------------------------
#  spec <- feature_spec(hearts_train, target ~ .) %>%
#    step_numeric_column(
#      all_numeric(), -cp, -restecg, -exang, -sex, -fbs,
#      normalizer_fn = scaler_standard()
#    ) %>%
#    step_categorical_column_with_vocabulary_list(thal) %>%
#    step_bucketized_column(age, boundaries = c(18, 25, 30, 35, 40, 45, 50, 55, 60, 65)) %>%
#    step_indicator_column(thal) %>%
#    step_embedding_column(thal, dimension = 2) %>%
#    step_crossed_column(c(thal, bucketized_age), hash_bucket_size = 10) %>%
#    step_indicator_column(crossed_thal_bucketized_age)

## -----------------------------------------------------------------------------
#  spec_prep <- fit(spec)

## -----------------------------------------------------------------------------
#  str(spec_prep$dense_features())

## -----------------------------------------------------------------------------
#  library(keras)
#  
#  input <- layer_input_from_dataset(hearts_train %>% select(-target))
#  
#  output <- input %>%
#    layer_dense_features(dense_features(spec_prep)) %>%
#    layer_dense(units = 32, activation = "relu") %>%
#    layer_dense(units = 1, activation = "sigmoid")
#  
#  model <- keras_model(input, output)
#  
#  model %>% compile(
#    loss = loss_binary_crossentropy,
#    optimizer = "adam",
#    metrics = "binary_accuracy"
#  )

## ---- warning=FALSE-----------------------------------------------------------
#  history <- model %>%
#    fit(
#      x = hearts_train %>% select(-target),
#      y = hearts_train$target,
#      epochs = 15,
#      validation_split = 0.2
#    )
#  
#  plot(history)

## -----------------------------------------------------------------------------
#  hearts_test$pred <- predict(model, hearts_test %>% select(-target))
#  Metrics::auc(hearts_test$target, hearts_test$pred)

