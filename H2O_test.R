
# Generate Sample dataset
dataset <- iris

# Create test factor
dataset$curlyFactor <- as.factor(paste0("var {",trunc(runif(nrow(dataset), 1, 10)),"}"))

# To H2O frame
datasetH2O <- as.h2o(dataset, destination_frame= "datasetH2O")

# Train Model
model <- h2o.glm(y = "Species", x = setdiff(names(dataset), "Species"),
                 training_frame = datasetH2O,
                 model_id = "curlyModel",
                 family = "multinomial")

# Download MOJO
modelMOJO <- h2o.download_mojo(model, path = getwd(), get_genmodel_jar = TRUE)

# Generate observations to predict (as JSON)

library(jsonlite)
obsJson1 <- jsonlite::toJSON(as.data.frame(dataset[1,]))
validate(obsJson1)

library(rjson)
obsJson2 <- rjson::toJSON(as.data.frame(dataset[1,]))
validate(obsJson2)

obsJson3 <- '[{"Sepal.Length":4.9,"Sepal.Width":3,"Petal.Length":1.4,"Petal.Width":0.2,"curlyFactor":"var {9}"}]'
validate(obsJson3)

obsJson4 <- "[{'Sepal.Length':4.9,'Sepal.Width':3,'Petal.Length':1.4,'Petal.Width':0.2,'curlyFactor':'var {9}'}]"
validate(obsJson4)

obsJson5 <- '[{"Sepal.Length":4.9,"Sepal.Width":3,"Petal.Length":1.4,"Petal.Width":0.2,"curlyFactor": \'var {9}\'}]'
validate(obsJson5)

# Predict
predMOJO <- h2o.predict_json(model = "curlyModel.zip", json = obsJson4)
predMOJO






