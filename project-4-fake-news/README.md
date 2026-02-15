# Fake News Detection System 

An end-to-end Natural Language Processing project that detects whether a news article is **Fake or Real** using machine learning.

Built using:

- TF-IDF with N-grams
- Linear Support Vector Machine (LinearSVC)
- Real Kaggle dataset
- Full evaluation pipeline
- Model persistence

---

## Project Overview

Fake news detection is a real-world NLP classification problem.

This project builds a high-performance text classification system that:

- Cleans and preprocesses news articles
- Converts text into numerical features using TF-IDF
- Trains a Linear SVM classifier
- Evaluates using accuracy, precision, recall, and F1-score
- Saves the trained model for later inference

---

## Dataset

**Dataset:** Fake and Real News Dataset (Kaggle)  
**Link:** https://www.kaggle.com/datasets/clmentbisaillon/fake-and-real-news-dataset
**Total Articles:** 44,898  

### Labels:
- `0` → Fake News  
- `1` → Real News  

### Columns:
- `title`
- `text`
- `subject`
- `date`
- `label` (added manually)

---

## Dataset Split

- Training Set: 35,918 articles  
- Test Set: 8,980 articles  
- Stratified 80/20 split  

---

## Model Architecture

### 1️⃣ Text Preprocessing

- Lowercasing
- URL removal
- Special character removal
- Whitespace normalization

---

### 2️⃣ Feature Engineering

TF-IDF Vectorization with:

- Stopword removal
- 1–2 grams (unigrams + bigrams)
- 30,000 maximum features

---

### 3️⃣ Classification Model

Algorithm:

```
Linear Support Vector Classifier (LinearSVC)
```

Why LinearSVC?

- Extremely effective for high-dimensional text data
- Fast training
- Strong generalization performance

---

## Model Performance

```
Accuracy: 99.59%
```

### Classification Report:

| Class | Precision | Recall | F1-Score |
|-------|-----------|--------|----------|
| Fake  | 1.00      | 0.99   | 1.00     |
| Real  | 0.99      | 1.00   | 1.00     |

- Balanced performance
- Very low false positives
- Very low false negatives

---

## Example Prediction

```
Input:
"Breaking: Government announces new economic reform..."

Output:
FAKE News
```

The model can classify custom input text after cleaning.

---

## Model Persistence

The trained model is saved using Joblib:

```
fake_news_detector.pkl
```

It can be reloaded without retraining for inference or deployment.

---

## 🛠 Tech Stack

- Python
- Pandas
- NumPy
- Scikit-learn
- TF-IDF Vectorizer
- LinearSVC
- Seaborn & Matplotlib
- Joblib

---

## This project demonstrates:

- Real-world dataset handling
- Advanced NLP preprocessing
- N-gram feature engineering
- High-dimensional text classification
- Stratified splitting
- Confusion matrix evaluation
- Model persistence
- Reproducible ML pipeline

It reflects real-world misinformation detection systems.

---

## Important Insight

The dataset contains stylistic differences between fake and real news sources.  
This contributes to high model accuracy when using linear models with TF-IDF.

---

## Future Improvements

- Hyperparameter tuning (GridSearchCV)
- Cross-validation
- ROC curve analysis
- SHAP explainability
- Fine-tune BERT for deep learning approach
- Build Streamlit web application
- Deploy as REST API

---

## Author

Sarah Zahir
GitHub: https://github.com/Sarah2211  

---

