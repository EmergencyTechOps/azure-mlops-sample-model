#!/bin/bash

RESOURCE_GROUP="mlops-group"
APP_NAME="mlops-app"
PLAN_NAME="mlops-plan"

# Create Azure resources
az group create --name $RESOURCE_GROUP --location eastus
az appservice plan create --name $PLAN_NAME --resource-group $RESOURCE_GROUP --sku B1 --is-linux
az webapp create --resource-group $RESOURCE_GROUP --plan $PLAN_NAME --name $APP_NAME --runtime "PYTHON|3.8"

# Deploy Flask API
az webapp up --name $APP_NAME --resource-group $RESOURCE_GROUP --sku B1