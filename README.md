🎨 SanrioScan – Sanrio Character Image Classification System

[![Build Status](https://img.shields.io/github/actions/workflow/status/J-AnnMayel/Estrella_Sanrio_Characters_FinalProject/flutter.yml?branch=master)](https://github.com/J-AnnMayel/Estrella_Sanrio_Characters_FinalProject/actions)  
[![Stars](https://img.shields.io/github/stars/J-AnnMayel/Estrella_Sanrio_Characters_FinalProject?style=social)](https://github.com/J-AnnMayel/Estrella_Sanrio_Characters_FinalProject/stargazers)  
[![Forks](https://img.shields.io/github/forks/J-AnnMayel/Estrella_Sanrio_Characters_FinalProject?style=social)](https://github.com/J-AnnMayel/Estrella_Sanrio_Characters_FinalProject/network)  
[![License](https://img.shields.io/github/license/J-AnnMayel/Estrella_Sanrio_Characters_FinalProject)](LICENSE)  
[![Flutter](https://img.shields.io/badge/Flutter-v3.13-blue)](https://flutter.dev/)  
[![TensorFlow Lite](https://img.shields.io/badge/TFLite-2.14-orange)](https://www.tensorflow.org/lite)  
[![Last Commit](https://img.shields.io/github/last-commit/J-AnnMayel/Estrella_Sanrio_Characters_FinalProject/master)](https://github.com/J-AnnMayel/Estrella_Sanrio_Characters_FinalProject/commits/master)



📋 Overview

SanrioScan is a  machine learning-powered mobile app built with Flutter that classifies popular Sanrio characters using  camera captures or gallery uploads.  
It demonstrates a **complete end-to-end ML pipeline**, from **data preprocessing**, **model training**, and **evaluation**, to **mobile deployment** using TensorFlow Lite for real-time inference.

---

📌 Project Scope

- **Type:** Supervised Learning – Image Classification  
- **Algorithm:** Convolutional Neural Networks (CNN)  
- **Platform:** Flutter (Android, iOS, Web, Desktop)  
- **Dataset:** Sanrio Character Images  
- **Problem:** Multi-class classification  
- **Accuracy Target:** 90%+  
- **Deployment:** Mobile-optimized with TensorFlow Lite  

---

## 🎯 Project Objectives

- Accurately classify popular Sanrio characters  
- Implement a complete ML workflow in a mobile context  
- Apply deep learning to real-world character recognition  
- Integrate **camera and gallery-based inference**  
- Visualize confidence scores and analytics  
- Demonstrate practical ML + Flutter development skills  

---

## 🛠️ Technology Stack

| Component        | Technology                  |
|-----------------|-----------------------------|
| Mobile Framework | Flutter (Dart)             |
| Deep Learning    | TensorFlow / TensorFlow Lite|
| Model Type       | CNN                         |
| Image Input      | Camera, Gallery             |
| Backend          | Firebase (Firestore)        |
| Visualization    | FL Chart                    |
| Local Storage    | SharedPreferences           |
| IDE              | VS Code / Android Studio    |

---

## 📂 Project Structure
Estrella_Sanrio_Characters_FinalProject/
│
├── android/
├── ios/
├── web/
├── windows/
├── macos/
├── linux/
│
├── assets/
│ ├── models/
│ │ ├── sanrio_model.tflite # Trained & quantized TFLite model
│ │ └── labels.txt # Character class labels
│ │
│ └── images/
│ ├── hello_kitty.jpg
│ ├── my_melody.jpg
│ ├── kuromi.jpg
│ ├── pompom_purin.jpg
│ ├── cinnamoroll.jpg
│ ├── little_twin_stars.jpg
│ ├── keroppi.jpg
│ ├── badtz_maru.jpg
│ └── sample_test.jpg
│
├── lib/
│ ├── main.dart
│ ├── screens/
│ │ ├── home_screen.dart
│ │ ├── classification_screen.dart
│ │ ├── analytics_screen.dart
│ │ └── get_started_screen.dart
│ │
│ ├── services/
│ │ ├── classifier.dart
│ │ ├── model_diagnostic.dart
│ │ └── preprocessing_config.dart
│ │
│ └── widgets/
│
├── test/
│ └── widget_test.dart
│
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
└── .gitignore


---

📊 Dataset Information

| Character          | Samples |
|-------------------|---------|
| Hello Kitty        | 150     |
| My Melody          | 150     |
| Kuromi             | 150     |
| Pompompurin        | 150     |
| Cinnamoroll        | 150     |
| Little Twin Stars  | 150     |
| Keroppi            | 150     |
| Badtz-Maru         | 150     |

- Total:       1,200 images  
- Image Size:  224×224  
- **Color Space:** RGB  
- **Split:** 60% Train • 20% Validation • 20% Test  

---
🐾 Character Descriptions & History

Here is a brief description of each class in the dataset, which can also be referenced in your **encoded labels**:

| Character         | Description | Encoded Label |
|------------------|-------------|---------------|
| Hello Kitty       | A cute white cat with a red bow. Born in 1974, she is known worldwide as the iconic symbol of Sanrio. | `0` |
| My Melody         | A kind-hearted white rabbit with a pink hood. Introduced in 1975, she loves baking and has a gentle personality. | `1` |
| Kuromi            | A mischievous white rabbit with a black jester hat. She is part of the My Melody universe but has a punk personality. | `2` |
| Pompompurin       | A golden retriever dog with a brown beret. Loves pudding and is friendly and cheerful. First appeared in 1996. | `3` |
| Cinnamoroll       | A white puppy with long ears, blue eyes, and a curled tail. Loves flying and cinnamon rolls; debuted in 2001. | `4` |
| Little Twin Stars | Twin siblings Kiki (blue hair) and Lala (pink hair). They are celestial beings who love to play and travel in the stars; introduced in 1975. | `5` |
| Keroppi           | A cheerful frog with big eyes, lives in Donut Pond. Known for being energetic and friendly, debuted in 1988. | `6` |
| Badtz-Maru        | A mischievous black penguin with a spiky hairdo. Born in 1993, he has a cheeky and rebellious personality. | `7` |

> **Note:** The `Encoded Label` column corresponds to how each class is represented numerically in the dataset and used for **model training**.

---

🧠 CNN Architecture

Input (224×224×3)
↓ Conv2D (32) + ReLU + BatchNorm
↓ MaxPooling
↓ Conv2D (64) + ReLU + BatchNorm
↓ MaxPooling
↓ Conv2D (128) + ReLU + BatchNorm
↓ MaxPooling
↓ Flatten
↓ Dense (256) + ReLU + Dropout(0.5)
↓ Dense (128) + ReLU + Dropout(0.3)
↓ Softmax Output (8 Classes)


---

📈 Performance Metrics

| Metric             | Result       |
|-------------------|-------------|
| Training Accuracy  | 95%         |
| Validation Accuracy| 93%         |
| Testing Accuracy   | 92%         |
| Precision          | 92%         |
| Recall             | 93%         |
| F1-Score           | 0.92        |
| Inference Time     | ~250–400 ms |

---

📱 App Features

- 📷 Real-time camera character classification  
- 🖼️ Gallery image selection  
- 📊 Confidence score visualization  
- 📈 Analytics dashboard  
- 💾 Local classification history  
- ☁️ Firebase Firestore integration  
- 🎨 Material Design 3 UI  

---
🎓 Educational Value

Complete ML pipeline implementation

CNN training and evaluation

Mobile AI deployment using TensorFlow Lite

Flutter cross-platform development

Real-world Sanrio character recognition use case

👤 Author

J-Ann Mayel Sadagnot Estrella 
BS Information Technology (BSIT)
Caraga State University – Cabadbaran Campus
Final Project • December 2025

✨ Thank you for exploring the SanrioScan project!
🎨 Classifying Sanrio characters with AI, one image at a time.
