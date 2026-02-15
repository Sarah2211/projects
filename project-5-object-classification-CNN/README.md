#  Image Classification with CNN (ResNet + Transfer Learning)

An intermediate–advanced Deep Learning project that classifies images from the CIFAR‑10 dataset using a fine‑tuned ResNet34 model.

This project demonstrates:

- Transfer Learning
- Full network fine‑tuning
- Data augmentation
- Learning rate scheduling
- Confusion matrix evaluation
- Per‑class accuracy analysis
- Model persistence

---

##  Project Overview

This project builds a high‑performance image classification system using:

two deep convolutional neural networks:
- ResNet18 (lighter architecture)
- ResNet34 (deeper architecture)
  
- Full fine‑tuning of all layers
- Advanced augmentation techniques
- Learning rate scheduling

The model is trained and evaluated on the CIFAR‑10 dataset.

---

## Dataset

**Dataset:** CIFAR‑10  
**Total Images:** 60,000  
- 50,000 training images  
- 10,000 test images  

**Image Size:** 32×32 RGB  

### Classes:
- Airplane
- Automobile
- Bird
- Cat
- Deer
- Dog
- Frog
- Horse
- Ship
- Truck

---

## Model Architectures

### ResNet18
- 18 layers
- Faster training
- Lower computational cost
- Good baseline performance

### ResNet34
- 34 layers
- Deeper residual blocks
- Higher representational capacity
- Better feature extraction


## Data Augmentation

- Random Horizontal Flip
- Random Crop (with padding)
- Random Rotation
- Color Jitter
- Normalization

These techniques improve generalization and reduce overfitting.

---

## Training Configuration

- Loss: CrossEntropyLoss
- Optimizer: Adam
- Learning Rate: 0.001
- Scheduler: StepLR (step_size=5, gamma=0.1)
- Epochs:
  - ResNet18 → 5 epochs
  - ResNet34 → 15 epochs
- GPU training enabled
---

## Per‑Class Accuracy Comparison

### ResNet18 vs ResNet34

| Class       | ResNet18 | ResNet34 |
|------------|----------|----------|
| Airplane   | ~84%     | 88.80%   |
| Automobile | ~86%     | 92.30%   |
| Bird       | ~72–75%  | 83.00%   |
| Cat        | ~65%     | 67.80%   |
| Deer       | ~81%     | 83.40%   |
| Dog        | ~74%     | 78.10%   |
| Frog       | ~86%     | 89.60%   |
| Horse      | ~68%     | 89.20%   |
| Ship       | ~86%     | 91.10%   |
| Truck      | ~81%     | 88.30%   |

---

## Observations

- ResNet34 significantly improves performance across most classes.
- Largest improvements observed in:
  - **Horse**
  - **Bird**
  - **Automobile**
- Animal classes remain more challenging due to low resolution and visual similarity.
- Deeper architecture enables better feature extraction and generalization.

---

## Final Model Performance

- **ResNet18 Accuracy:** ~78–79%
- **ResNet34 Accuracy:** 85.16%
- Improvement: **+6–7%**

This demonstrates the impact of deeper residual architectures in image classification tasks.


## Evaluation Methods

- Test Accuracy
- Confusion Matrix
- Per-Class Accuracy
- Sample Prediction Visualization

---

##  Model Saving

The trained model is saved as:

```
resnet34_cifar10_advanced.pth, cnn_cifar10.pth
```

It can be reloaded for inference without retraining.

---

## 📁 Project Structure

```
image-classification-cnn/

├── models/
│   └── cnn_cifar10.pth
│   └── resnet34_cifar10_advanced.pth
├── Project5.ipynb
└── README.md
```

---

## 🛠 Tech Stack

- Python
- PyTorch
- Torchvision
- NumPy
- Matplotlib
- Seaborn

---

## Key Concepts Demonstrated

- Transfer Learning
- Fine-Tuning Pretrained Networks
- CNN Architecture (ResNet)
- Learning Rate Scheduling
- Data Augmentation
- Model Evaluation
- GPU Training
- Deep Learning Workflow

---

## Future Improvements

- Early Stopping
- Cosine Annealing Scheduler
- Label Smoothing
- Grad-CAM Visualization
- Compare ResNet18 vs ResNet34 vs ResNet50
- Deploy using Streamlit
- Train on real-world datasets (Medical / Plant Disease / Waste Classification)

---

## Author

Sarah Zahir
GitHub: https://github.com/YOUR_USERNAME  

---
