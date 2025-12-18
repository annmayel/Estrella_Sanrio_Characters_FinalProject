
<!-- 🌸 SanrioScan GitHub README 🌸 -->

<h1 align="center">🎨 SanrioScan – Sanrio Character Image Classification System</h1>

<p align="center">
  A **cute, minimal, and scanner mobile app** that can **classify Sanrio characters** from **camera captures or gallery images** in real-time using **TensorFlow Lite** and **Flutter**.
</p>

---

# 📋 Overview

SanrioScan is a **machine learning-powered mobile app** built with Flutter that classifies popular Sanrio characters using **camera captures or gallery uploads**.  
It demonstrates a **complete end-to-end ML pipeline**, from **data preprocessing**, **model training**, and **evaluation**, to **mobile deployment** using TensorFlow Lite for real-time inference.


---

## 📌 Project Scope

- **Type:** Supervised Learning – Image Classification  
- **Algorithm:** Convolutional Neural Networks (CNN)  
- **Platform:** Flutter (Android, iOS, Web, Desktop)  
- **Dataset:** Sanrio Character Images  
- **Problem:** Multi-class classification  
- **Accuracy Target:** 90%+  
- **Deployment:** Mobile-optimized with TensorFlow Lite  



---

# 🎯 Project Objectives

- Accurately classify popular Sanrio characters  
- Implement a complete ML workflow in a mobile context  
- Apply deep learning to real-world character recognition  
- Integrate **camera and gallery-based inference**  
- Visualize confidence scores and analytics  
- Demonstrate practical ML + Flutter development skills  



---

# 🛠️ Technology Stack

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

# 📂 Project Structure

```text
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
│ │ ├── sanrio_model.tflite
│ │ └── labels.txt
│ └── images/
│   ├── hello_kitty.jpg
│   ├── my_melody.jpg
│   ├── kuromi.jpg
│   ├── pompom_purin.jpg
│   ├── cinnamoroll.jpg
│   ├── little_twin_stars.jpg
│   ├── keroppi.jpg
│   ├── badtz_maru.jpg
│   └── sample_test.jpg
│
├── lib/
│ ├── main.dart
│ ├── screens/
│ │ ├── home_screen.dart
│ │ ├── classification_screen.dart
│ │ ├── analytics_screen.dart
│ │ └── get_started_screen.dart
│ ├── services/
│ │ ├── classifier.dart
│ │ ├── model_diagnostic.dart
│ │ └── preprocessing_config.dart
│ └── widgets/
├── test/
│ └── widget_test.dart
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
└── .gitignore
````

---



## 📊 Dataset Information

| Character         | Samples |
| ----------------- | ------- |
| Hello Kitty       | 150     |
| My Melody         | 150     |
| Kuromi            | 150     |
| Pompompurin       | 150     |
| Cinnamoroll       | 150     |
| Little Twin Stars | 150     |
| Keroppi           | 150     |
| Badtz-Maru        | 150     |

* **Total Images:** 1,200
* **Image Size:** 224×224
* **Color Space:** RGB
* **Split:** 60% Train • 20% Validation • 20% Test

---

# 🐾 Character Descriptions & History

| Character         | Description                                                           | Encoded Label |
| ----------------- | --------------------------------------------------------------------- | ------------- |
| Hello Kitty       | A cute white cat with a red bow. Born in 1974, iconic Sanrio symbol.  | `0`           |
| My Melody         | White rabbit with pink hood. Loves baking; gentle personality.        | `1`           |
| Kuromi            | Mischievous rabbit with black jester hat; punk personality.           | `2`           |
| Pompompurin       | Golden retriever dog with brown beret; loves pudding, cheerful.       | `3`           |
| Cinnamoroll       | White puppy with long ears, blue eyes; loves flying & cinnamon rolls. | `4`           |
| Little Twin Stars | Twins Kiki (blue) & Lala (pink); celestial beings, playful.           | `5`           |
| Keroppi           | Cheerful frog from Donut Pond; energetic & friendly.                  | `6`           |
| Badtz-Maru        | Black penguin with spiky hair; mischievous & rebellious.              | `7`           |

> `Encoded Label` = numeric label for model training.



---

# 🧠 CNN Architecture

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

# 📈 Performance Metrics

| Metric              | Result      |
| ------------------- | ----------- |
| Training Accuracy   | 95%         |
| Validation Accuracy | 93%         |
| Testing Accuracy    | 92%         |
| Precision           | 92%         |
| Recall              | 93%         |
| F1-Score            | 0.92        |
| Inference Time      | ~250–400 ms |

---

# 📱 App Features

* 📷 Real-time camera classification
* 🖼️ Gallery image selection
* 📊 Confidence score visualization
* 📈 Analytics dashboard
* 💾 Local classification history
* ☁️ Firebase Firestore integration
* 🎨 Material Design 3 UI



---

# 🎓 Educational Value

* Complete ML pipeline implementation
* CNN training & evaluation
* Mobile AI deployment using TensorFlow Lite
* Flutter cross-platform development
* Real-world Sanrio character recognition



---

# 👤 Author

**J-Ann Mayel Sadagnot Estrella**
BS Information Technology (BSIT)
Caraga State University – Cabadbaran Campus
Final Project • December 2025

---

✨ Thank you for exploring **SanrioScan**!
🎨 Classifying Sanrio characters with AI, one image at a time.



