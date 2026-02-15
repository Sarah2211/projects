# 🎬 Hybrid Movie Recommendation System 

A Machine Learning project that combines:

-  Collaborative Filtering (Matrix Factorization - SVD)
-  Content-Based Filtering (Genre Similarity)
-  Hybrid Weighted Blending Model
-  Top‑N Movie Recommendations
-  Model Persistence (Save & Reload)

Built using the MovieLens 100K dataset.

---

##  Project Overview

Modern recommendation engines (Netflix, Amazon, Spotify) use **hybrid systems** to improve recommendation accuracy.

This project combines:

1. **Collaborative Filtering**
   - Learns user preferences from rating behavior
   - Implemented using SVD (Matrix Factorization)

2. **Content-Based Filtering**
   - Uses movie genre similarity
   - Implemented using cosine similarity

3. **Hybrid Model**
   - Combines both models using weighted blending
   - Scores normalized before combining

---

##  Dataset

**Dataset:** MovieLens 100K  
**Users:** 943  
**Movies:** 1,682  
**Ratings:** 100,000  

Each rating ranges from 1 to 5.

---

##  Model Architecture

### 1️ Collaborative Filtering

- Algorithm: SVD (Singular Value Decomposition)
- Learns latent user/movie features
- Evaluated using RMSE and MAE

Performance:

```
RMSE ≈ 0.93 – 0.95
MAE  ≈ 0.73 – 0.75
```

---

### 2️⃣ Content-Based Filtering

- Uses movie genre one-hot vectors
- Computes cosine similarity between movies
- Builds full similarity matrix

---

### 3️⃣ Hybrid Model

Final score:

```
Hybrid Score =
α × Normalized Collaborative Score
+
(1 - α) × Normalized Content Score
```

Where:

- α = 0.7 (collaborative weight)
- Scores normalized using MinMaxScaler

This improves ranking stability and recommendation diversity.

---

##  Example Output

### Top 10 Hybrid Recommendations for User 196

```
Shall We Dance? (1996)                      0.93
Wrong Trousers, The (1993)                  0.92
Rear Window (1954)                          0.92
Braveheart (1995)                           0.90
Boot, Das (1981)                            0.89
Raging Bull (1980)                          0.88
Vertigo (1958)                              0.88
Dr. Strangelove (1964)                      0.87
Raise the Red Lantern (1991)                0.87
Nikita (1990)                               0.87
```

Scores are normalized between 0 and 1.

---

## 🛠 Tech Stack

- Python
- NumPy
- Pandas
- Scikit-learn
- Scikit-Surprise
- Cosine Similarity
- Matrix Factorization (SVD)
- Joblib

---

##  Model Saving

The system saves:

- Trained SVD model
- Content similarity matrix
- Movie metadata
- Hybrid weight parameter

Models can be reloaded for inference without retraining.

---

## This project demonstrates:

- Matrix Factorization
- Collaborative Filtering
- Content-Based Filtering
- Hybrid Recommender Design
- Score Normalization
- Model Persistence
- Real-world dataset usage
- End-to-end ML pipeline

This reflects real-world production recommender systems.

---

##  Future Improvements

- Hyperparameter tuning for α
- User-specific content weighting
- Evaluate hybrid RMSE formally
- Add cold-start handling
- Build Streamlit web interface
- Deploy as REST API
- Upgrade to Neural Collaborative Filtering

---

##  Author

Sarah Zahir
GitHub: https://github.com/Sarah2211

---

