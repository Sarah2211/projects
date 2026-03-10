# Hybrid Intrusion Detection System using CIC‑IDS2017 Dataset

A Machine Learning cybersecurity project that detects and classifies network intrusions using large‑scale traffic data from the CIC‑IDS2017 dataset.

This project demonstrates:

- Large‑scale data handling (2.8M+ records)
- Binary Intrusion Detection (Benign vs Attack)
- Multi‑Class Attack Classification
- Severe class imbalance handling
- Rare attack preservation
- Random Forest vs Logistic Regression comparison
- Memory optimization in Google Colab
- Production‑style IDS architecture

---

## Project Overview

This project builds a high‑performance Intrusion Detection System (IDS) using:

Two supervised machine learning models:

- Logistic Regression (baseline linear model)
- Random Forest (non‑linear ensemble model)

The system operates in two stages:

- **Stage 1:** Binary classification (Benign vs Attack)
- **Stage 2:** Multi‑class classification (Specific attack type)

The models are trained and evaluated on the CIC‑IDS2017 dataset.

---

## Dataset

**Dataset:** CIC‑IDS2017  
**Total Records:** 2,830,743  
**Total Features:** 78 network traffic features  

### Attack Categories:

- BENIGN
- DDoS
- DoS Hulk
- DoS GoldenEye
- DoS Slowloris
- DoS Slowhttptest
- PortScan
- FTP‑Patator
- SSH‑Patator
- Bot
- Web Attack – Brute Force
- Web Attack – XSS
- Web Attack – SQL Injection
- Infiltration
- Heartbleed

---

## Data Preprocessing

- Merged 8 CSV files into one dataset
- Cleaned column names
- Removed infinite values
- Dropped missing values
- Optimized memory (float64 → float32, int64 → int32)
- Addressed extreme class imbalance
- Preserved rare attack types (Heartbleed, SQL Injection, Infiltration)

---

# Stage 1 — Binary Intrusion Detection

### Objective:
Classify network traffic as:

- 0 → BENIGN  
- 1 → ATTACK  

---

## Model 1 — Logistic Regression (Baseline)

- Linear classifier
- Scaled features
- Fast training baseline

### Logistic Regression Results

| Metric | Value |
|--------|--------|
| Accuracy | 95% |
| ROC‑AUC | 0.9527 |
| Recall (Attack) | 0.98 |
| Precision (Attack) | 0.93 |

### Confusion Matrix

[[79169 5980]
[ 2078 83070]]

- False Positives: 5,980  
- False Negatives: 2,078  

### Observation

Logistic Regression performs strongly, achieving high recall for attacks (98%), but produces more false positives compared to Random Forest.

---

## Model 2 — Random Forest (Final Binary Model)

- 100 decision trees
- Parallelized training
- No max depth restriction

### Random Forest Results

| Metric | Value |
|--------|--------|
| Accuracy | 99.88% |
| ROC‑AUC | 0.9988 |
| Recall (Attack) | 0.9988 |
| Precision (Attack) | 1.00 |

### Confusion Matrix

[[85048 101]
[ 98 85050]]


- False Positives: 101  
- False Negatives: 98  

### Security Interpretation

Random Forest dramatically reduces both false positives and false negatives, achieving near‑perfect attack detection.

This level of performance is considered production‑grade for supervised IDS systems.

---

# Stage 2 — Multi‑Class Attack Classification

### Objective:
Classify malicious traffic into specific attack categories.

### Approach:

- Preserved all attack classes (including rare attacks)
- Used `class_weight="balanced"`
- Trained Random Forest on full dataset

---

## Multi‑Class Results (Selected Highlights)

### Major Attack Classes

| Class | F1‑Score |
|-------|----------|
| BENIGN | 1.00 |
| DDoS | 1.00 |
| DoS Hulk | 1.00 |
| PortScan | 1.00 |
| FTP‑Patator | 1.00 |
| SSH‑Patator | 1.00 |

### Rare Attack Performance

| Class | Recall | Support |
|--------|--------|---------|
| Infiltration | 0.57 | 7 |
| SQL Injection | 0.50 | 4 |
| XSS | 0.30 | 130 |

Despite extremely small sample sizes, the model successfully detected rare attacks with non‑zero recall — demonstrating effective imbalance handling.

---

# Architecture Overview

Network Traffic
↓
Stage 1: Binary Random Forest
↓
If Attack →
↓
Stage 2: Multi‑Class Random Forest

This layered design mirrors real‑world intrusion detection pipelines.

---

# Evaluation Methods

- Accuracy
- Precision
- Recall
- F1‑Score
- ROC‑AUC
- Confusion Matrix
- Macro & Weighted averages

Special emphasis was placed on **Recall for Attack classes**, as missing malicious traffic poses higher risk than false alarms.

---

# Project Structure

hybrid-intrusion-detection-system/
└── Project_IDS_ML.ipynb
└── README.md

---

# Tech Stack

- Python
- Pandas
- NumPy
- Scikit‑Learn
- KaggleHub
- Google Colab

---

# Key Concepts Demonstrated

- Large‑Scale Data Processing
- Class Imbalance Handling
- Binary vs Multi‑Class Classification
- Random Forest vs Logistic Regression Comparison
- Feature Engineering & Cleaning
- Memory Optimization
- Cybersecurity Modeling
- Evaluation of Rare Attack Detection
- End‑to‑End ML Workflow

---

# Future Improvements

- SMOTE for rare attack boosting
- Isolation Forest for anomaly detection
- Deep Learning (MLP / LSTM)
- SHAP feature importance analysis
- Real‑time deployment API
- Cost‑sensitive learning

---

