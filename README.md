# 🚀 MLOps Project on Azure with CI/CD Pipeline

## **🔹 Repo Structure**
```
mlops-azure-project/
│── .azure-pipelines/
│   ├── pipeline.yml          # Azure DevOps pipeline definition
│── model/
│   ├── train.py              # ML model training script
│   ├── model.pkl             # Trained model
│── api/
│   ├── app.py                # Flask API to serve ML model
│   ├── requirements.txt       # Python dependencies
│── infra/
│   ├── deploy.sh             # Azure CLI deployment script
│── tests/
│   ├── test_model.py         # Unit tests for the model
│── README.md                 # Documentation
```

---

## **✅ Step 1: Train and Save an ML Model**
### 🔹 `model/train.py`
```python
import numpy as np
import pickle
from sklearn.linear_model import LinearRegression

# Generate sample data
X = np.array([1, 2, 3, 4, 5]).reshape(-1, 1)
y = np.array([2, 4, 6, 8, 10])

# Train a simple model
model = LinearRegression()
model.fit(X, y)

# Save the model
with open("model.pkl", "wb") as f:
    pickle.dump(model, f)

print("Model trained and saved successfully!")
```

---

## **✅ Step 2: Create an API to Serve the Model**
### 🔹 `api/app.py`
```python
from flask import Flask, request, jsonify
import pickle
import numpy as np

app = Flask(__name__)

# Load model
with open("model.pkl", "rb") as f:
    model = pickle.load(f)

@app.route("/predict", methods=["POST"])
def predict():
    data = request.json
    X = np.array(data["input"]).reshape(-1, 1)
    prediction = model.predict(X).tolist()
    return jsonify({"prediction": prediction})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

### 🔹 `api/requirements.txt`
```txt
flask
numpy
scikit-learn
```

---

## **✅ Step 3: Create Azure DevOps CI/CD Pipeline**
### 🔹 `.azure-pipelines/pipeline.yml`
```yaml
trigger:
  - main

pool:
  vmImage: "ubuntu-latest"

stages:
  - stage: Train_Model
    jobs:
      - job: Train
        steps:
          - script: |
              python -m venv venv
              source venv/bin/activate
              pip install numpy scikit-learn
              python model/train.py
            displayName: "Train ML Model"

          - task: PublishBuildArtifacts@1
            inputs:
              pathToPublish: "model.pkl"
              artifactName: "model"
  
  - stage: Deploy_API
    jobs:
      - job: Deploy
        steps:
          - checkout: self
          - task: UsePythonVersion@0
            inputs:
              versionSpec: "3.x"

          - script: |
              pip install -r api/requirements.txt
              python api/app.py
            displayName: "Deploy Flask API"

          - task: AzureWebApp@1
            inputs:
              azureSubscription: "YOUR_AZURE_CONNECTION"
              appName: "mlops-app"
              package: "."
```

---

## **✅ Step 4: Deploy to Azure App Services**
### 🔹 `infra/deploy.sh`
```bash
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
```

Run:
```bash
bash infra/deploy.sh
```

---

## **✅ Step 5: Push Everything to Azure Repo**
```bash
git add .
git commit -m "Initial MLOps pipeline setup"
git push origin main
```

---

## **✅ Step 6: Run the Pipeline**
1. **Go to Azure DevOps → Pipelines → New Pipeline**.
2. **Choose Azure Repos → Select `mlops-azure-project`**.
3. **Select 'Existing YAML file' → Choose `.azure-pipelines/pipeline.yml`**.
4. **Click 'Run Pipeline'**.

---

## **✅ Step 7: Test API**
```bash
curl -X POST https://mlops-app.azurewebsites.net/predict -H "Content-Type: application/json" -d '{"input": [10, 20, 30]}'
```

🚀 **Now you have a full MLOps pipeline running on Azure!** 🎉
