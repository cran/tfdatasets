## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(eval = FALSE)

## ----eval=FALSE---------------------------------------------------------------
#  devtools::install_github("rstudio/tfdatasets")

## ----eval=FALSE---------------------------------------------------------------
#  library(tfdtasets)
#  install_tensorflow()

## -----------------------------------------------------------------------------
#  library(tfdatasets)
#  
#  # create specification for parsing records from an example file
#  iris_spec <- csv_record_spec("iris.csv")
#  
#  # read the dataset
#  dataset <- text_line_dataset("iris.csv", record_spec = iris_spec)
#  
#  # take a glimpse at the dataset
#  str(dataset)

## -----------------------------------------------------------------------------
#  # provide colum names and types explicitly
#  iris_spec <- csv_record_spec(
#    names = c("SepalLength", "SepalWidth", "PetalLength", "PetalWidth", "Species"),
#    types = c("double", "double", "double", "double", "integer"),
#    skip = 1
#  )
#  
#  # read the datset
#  dataset <- text_line_dataset("iris.csv", record_spec = iris_spec)

## -----------------------------------------------------------------------------
#  mtcars_spec <- csv_record_spec("mtcars.csv", types = "dididddiiii")

## -----------------------------------------------------------------------------
#  dataset <- text_line_dataset("iris.csv", record_spec = iris_spec, parallel_records = 4)

## -----------------------------------------------------------------------------
#  dataset <- text_line_dataset("iris.csv", record_spec = iris_spec, parallel_records = 4) %>%
#    dataset_batch(128) %>%
#    dataset_prefetch(1)

## -----------------------------------------------------------------------------
#  # Creates a dataset that reads all of the examples from two files, and extracts
#  # the image and label features.
#  filenames <- c("/var/data/file1.tfrecord", "/var/data/file2.tfrecord")
#  dataset <- tfrecord_dataset(filenames) %>%
#    dataset_map(function(example_proto) {
#      features <- list(
#        image = tf$FixedLenFeature(shape(), tf$string),
#        label = tf$FixedLenFeature(shape(), tf$int32)
#      )
#      tf$parse_single_example(example_proto, features)
#    })

## -----------------------------------------------------------------------------
#  filenames <- c("/var/data/file1.tfrecord", "/var/data/file2.tfrecord")
#  dataset <- tfrecord_dataset(filenames, num_parallel_reads = 4)

## ----eval=FALSE---------------------------------------------------------------
#  library(tfdatasets)
#  
#  record_spec <- sql_record_spec(
#    names = c("disp", "drat", "vs", "gear", "mpg", "qsec", "hp", "am", "wt",  "carb", "cyl"),
#    types = c(tf$float64, tf$int32, tf$float64, tf$int32, tf$float64, tf$float64,
#              tf$float64, tf$int32, tf$int32, tf$int32, tf$int32)
#  )
#  
#  dataset <- sqlite_dataset(
#    "data/mtcars.sqlite3",
#    "select * from mtcars",
#    record_spec
#  )
#  
#  dataset

## -----------------------------------------------------------------------------
#  dataset <- dataset %>%
#    dataset_map(function(record) {
#      record$Species <- tf$one_hot(record$Species, 3L)
#      record
#    })

## -----------------------------------------------------------------------------
#  dataset <- dataset %>%
#    dataset_map(num_parallel_calls = 4, function(record) {
#      record$Species <- tf$one_hot(record$Species, 3L)
#      record
#    })

## -----------------------------------------------------------------------------
#  dataset <- dataset %>%
#    dataset_map(num_parallel_calls = 4, function(record) {
#      record$Species <- tf$one_hot(record$Species, 3L)
#      record
#    }) %>%
#    datset_prefetch(1)

## -----------------------------------------------------------------------------
#  dataset <- dataset %>%
#    dataset_map_and_batch(batch_size = 128, function(record) {
#      record$Species <- tf$one_hot(record$Species, 3L)
#      record
#    }) %>%
#    datset_prefetch(1)

## -----------------------------------------------------------------------------
#  dataset <- csv_dataset("mtcars.csv") %>%
#    dataset_filter(function(record) {
#      record$mpg >= 20
#  })
#  
#  dataset <- csv_dataset("mtcars.csv") %>%
#    dataset_filter(function(record) {
#      record$mpg >= 20 & record$cyl >= 6L
#    })

## -----------------------------------------------------------------------------
#  mtcars_dataset <- text_line_dataset("mtcars.csv", record_spec = mtcars_spec) %>%
#    dataset_prepare(x = c(mpg, disp), y = cyl)
#  
#  iris_dataset <- text_line_dataset("iris.csv", record_spec = iris_spec) %>%
#    dataset_prepare(x = -Species, y = Species)

## -----------------------------------------------------------------------------
#  mtcars_dataset <- text_line_dataset("mtcars.csv", record_spec = mtcars_spec) %>%
#    dataset_prepare(cyl ~ mpg + disp)

## -----------------------------------------------------------------------------
#  mtcars_dataset <- text_line_dataset("mtcars.csv", record_spec = mtcars_spec) %>%
#    dataset_prepare(cyl ~ mpg + disp, batch_size = 16)

## -----------------------------------------------------------------------------
#  dataset <- dataset %>%
#    dataset_shuffle(1000) %>%
#    dataset_repeat(10) %>%
#    dataset_batch(128) %>%

## -----------------------------------------------------------------------------
#  dataset <- dataset %>%
#    dataset_shuffle_and_repeat(buffer_size = 1000, count = 10) %>%
#    dataset_batch(128)

## -----------------------------------------------------------------------------
#  dataset <- dataset %>%
#    dataset_map_and_batch(batch_size = 128, function(record) {
#      record$Species <- tf$one_hot(record$Species, 3L)
#      record
#    }) %>%
#    dataset_prefetch(1)

## -----------------------------------------------------------------------------
#  dataset <- dataset %>%
#    dataset_map_and_batch(batch_size = 128, function(record) {
#      record$Species <- tf$one_hot(record$Species, 3L)
#      record
#    }) %>%
#    dataset_prefetch_to_device("/gpu:0")

## -----------------------------------------------------------------------------
#  dataset <- text_line_dataset("mtcars.csv", record_spec = mtcars_spec) %>%
#    dataset_filter(function(record) {
#      record$mpg >= 20 & record$cyl >= 6L
#    }) %>%
#    dataset_shuffle_and_repeat(buffer_size = 1000, count = 10) %>%
#    dataset_prepare(cyl ~ mpg + disp, batch_size = 128) %>%
#    dataset_prefetch(1)

## -----------------------------------------------------------------------------
#  model %>% fit(
#    x_train, y_train,
#    epochs = 30,
#    batch_size = 128
#  )

## -----------------------------------------------------------------------------
#  library(keras3)
#  library(tfdatasets)
#  
#  batch_size = 128
#  steps_per_epoch = 500
#  
#  # function to read and preprocess mnist dataset
#  mnist_dataset <- function(filename) {
#    dataset <- tfrecord_dataset(filename) %>%
#      dataset_map(function(example_proto) {
#  
#        # parse record
#        features <- tf$parse_single_example(
#          example_proto,
#          features = list(
#            image_raw = tf$FixedLenFeature(shape(), tf$string),
#            label = tf$FixedLenFeature(shape(), tf$int64)
#          )
#        )
#  
#        # preprocess image
#        image <- tf$decode_raw(features$image_raw, tf$uint8)
#        image <- tf$cast(image, tf$float32) / 255
#  
#        # convert label to one-hot
#        label <- tf$one_hot(tf$cast(features$label, tf$int32), 10L)
#  
#        # return
#        list(image, label)
#      }) %>%
#      dataset_repeat() %>%
#      dataset_shuffle(1000) %>%
#      dataset_batch(batch_size, drop_remainder = TRUE) %>%
#      dataset_prefetch(1)
#  }
#  
#  model <- keras_model_sequential() %>%
#    layer_dense(units = 256, activation = 'relu', input_shape = c(784)) %>%
#    layer_dropout(rate = 0.4) %>%
#    layer_dense(units = 128, activation = 'relu') %>%
#    layer_dropout(rate = 0.3) %>%
#    layer_dense(units = 10, activation = 'softmax')
#  
#  model %>% compile(
#    loss = 'categorical_crossentropy',
#    optimizer = optimizer_rmsprop(),
#    metrics = c('accuracy')
#  )
#  
#  history <- model %>% fit(
#    mnist_dataset("mnist/train.tfrecords"),
#    steps_per_epoch = steps_per_epoch,
#    epochs = 20,
#    validation_data = mnist_dataset("mnist/validation.tfrecords"),
#    validation_steps = steps_per_epoch
#  )
#  
#  score <- model %>% evaluate(
#    mnist_dataset("mnist/test.tfrecords"),
#    steps = steps_per_epoch
#  )
#  
#  print(score)

## -----------------------------------------------------------------------------
#  dataset <- text_line_dataset("mtcars.csv", record_spec = mtcars_spec) %>%
#    dataset_prepare(cyl ~ mpg + disp) %>%
#    dataset_shuffle(20) %>%
#    dataset_batch(5)
#  
#  iter <- as_iterator(dataset)
#  next_batch <- iter_next(iter)
#  next_batch

## -----------------------------------------------------------------------------
#  dataset <- read_files("data/*.csv", text_line_dataset, record_spec = mtcars_spec,
#                        parallel_files = 4, parallel_interleave = 16) %>%
#    dataset_prefetch(5000) %>%
#    dataset_shuffle_and_repeat(buffer_size = 1000, count = 3) %>%
#    dataset_batch(128)

## -----------------------------------------------------------------------------
#  # command line flags for training script (shard info is passed by training
#  # supervisor that executes the script)
#  FLAGS <- flags(
#    flag_integer("num_shards", 1),
#    flag_integer("shard_index", 1)
#  )
#  
#  # forward shard info to read_files
#  dataset <- read_files("data/*.csv", text_line_dataset, record_spec = mtcars_spec,
#                        parallel_files = 4, parallel_interleave = 16,
#                        num_shards = FLAGS$num_shards, shard_index = FLAGS$shard_index) %>%
#    dataset_shuffle_and_repeat(buffer_size = 1000, count = 3) %>%
#    dataset_batch(128) %>%
#    dataset_prefetch(1)

