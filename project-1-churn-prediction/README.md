# Customer Churn Prediction using Machine Learning

Predict customer churn using machine learning. This project builds an end-to-end ML pipeline to identify customers likely to leave a telecom service.

---

## Project Overview

Customer churn prediction helps businesses retain customers by identifying those at risk of leaving. This project uses the Telco Customer Churn dataset and applies machine learning to predict churn probability.

The project includes:

* Data preprocessing
* Feature engineering
* Machine learning model training
* Model evaluation
* Model saving for deployment

---

## Dataset

Dataset: Telco Customer Churn
Source: IBM Sample Dataset
Link: https://raw.githubusercontent.com/IBM/telco-customer-churn-on-icp4d/master/data/Telco-Customer-Churn.csv

Features include:

* Customer demographics
* Account information
* Service usage
* Billing information

Target variable:

* `Churn`

  * 1 → Customer churned
  * 0 → Customer stayed

Dataset size:

* 7043 rows
* 20 features

---

## Tech Stack

* Python
* Pandas
* NumPy
* Scikit-learn
* Joblib
* Google Colab

---

## Project Structure

```
churn-prediction/

│
├── data/
│   └── telco_churn.csv
│
├── models/
│   └── churn_model.pkl
│
├── train.py
├── download_data.py
├── requirements.txt
└── README.md
```

---

## Machine Learning Pipeline

Steps performed:

1. Data loading
2. Data cleaning
3. Handling missing values
4. Encoding categorical features
5. Train-test split
6. Model training using Logistic Regression
7. Model evaluation using ROC-AUC
8. Model saving

---

## Model Performance

ROC-AUC Score:

```
~0.84 (may vary slightly)
```

This indicates good prediction capability.

---

## How to Run the Project

### Option 1 — Google Colab

Run cells in order:

1. Install dependencies
2. Download dataset
3. Train model
4. Save model

## Example Prediction

```
Prediction: 1
Churn probability: 0.78
```

Meaning customer is likely to churn.

---

## Skills Demonstrated

* Machine Learning
* Data preprocessing
* Feature engineering
* Classification models
* Pipeline building
* Model evaluation
* Model saving and loading

---

## Future Improvements

* Use XGBoost for higher accuracy
* Add Streamlit web app
* Deploy using Docker
* Add feature importance visualization

---

## Author

Sarah Zahir 
GitHub: https://github.com/Sarah2211

---

## Why this project is valuable

This project demonstrates real-world ML workflow used in industry:

* End-to-end pipeline
* Clean code structure
* Reproducible results
* Deployment-ready model
