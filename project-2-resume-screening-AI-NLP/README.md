#  Resume Screening & Classification System (NLP)

An end-to-end Natural Language Processing project that:

-  Ranks resumes based on job description similarity  
-  Classifies resumes into 25 job categories  
-  Saves trained models for reuse  
-  It achived ~99% classification accuracy  

Built using TF‑IDF, Cosine Similarity, and Logistic Regression.

---

##  Project Overview

Modern Applicant Tracking Systems (ATS) automatically filter and rank resumes.

This project simulates a real-world ATS system by:

1. Ranking resumes against a job description using cosine similarity
2. Predicting the job category of resumes using supervised ML

The system uses a real-world dataset of 962 resumes across 25 job roles.

---

##  Dataset

**Dataset:** Updated Resume Dataset (Kaggle)  
**Records:** 962 resumes  
**link:** https://www.kaggle.com/datasets/jillanisofttech/updated-resume-dataset 

### Features:
- `Category` → Job role label  
- `Resume` → Raw resume text  

### Number of Job Categories: 25

Examples:
- Data Science  
- Java Developer  
- Python Developer  
- DevOps Engineer  
- Civil Engineer  
- HR  
- Blockchain  
- Web Designing  

---

##  Project Components

###  Resume Ranking System

Uses:
- Text cleaning
- TF-IDF Vectorization
- Cosine Similarity

### Workflow:

```
Job Description → TF-IDF → Cosine Similarity → Ranked Resumes
```

### Output:
- Top matching resumes
- Similarity score
- Resume snippets

---

###  Resume Category Classification

Uses:
- TF-IDF (1-2 grams)
- Logistic Regression
- Stratified Train-Test Split

### Model Performance:

```
Accuracy: ~99.48%
Macro F1-score: ~0.99
```

The classifier predicts the correct job role with high precision and recall.

---

## 🛠 Tech Stack

- Python
- Pandas
- Scikit-learn
- TF-IDF Vectorizer
- Cosine Similarity
- Logistic Regression
- Joblib
- Google Colab

---

## 📁 Project Structure

```
proj-2/

├── data/
│   └── UpdatedResumeDataSet.csv
│
├── models/
│   ├── tfidf_vectorizer.joblib
│   └── resume_category_classifier.joblib
│
├── outputs/
│   └── ranked_resumes.csv
│
├── resume_screening.ipynb
└── README.md
```

---

## How to Run (Google Colab)

1. Mount Google Drive
2. Load dataset from:

```
drive/MyDrive/project-2026/proj-2/data/UpdatedResumeDataSet.csv
```

3. Run notebook cells in order:
   - Data cleaning
   - TF-IDF ranking
   - Classifier training
   - Model saving

---

## 🧪 Example Output

### Resume Ranking

```
Category         Similarity Score
----------------------------------
Data Science     0.4049
Data Science     0.4012
...
```

### Classification Example

```
Predicted category: Data Science
Accuracy: 0.9948
```

---

## What this project demonstrates:

- NLP preprocessing
- Feature engineering
- Text similarity search
- Multi-class classification
- Model persistence
- Real dataset usage
- Clean ML pipeline design

It reflects real-world HR automation systems used in recruitment platforms.

---

## Future Improvements

- Upgrade to BERT / Sentence Transformers embeddings
- Add resume PDF parsing
- Build Streamlit web interface
- Deploy as REST API using FastAPI
- Add confusion matrix visualization
- Add cross-validation metrics

---

## Author

Your Name  
GitHub: https://github.com/Sarah1122 

---

