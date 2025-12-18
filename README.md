
<!-- 🌸 SanrioScan GitHub README 🌸 -->

<h1 align="center">🎨 SanrioScan – Sanrio Character Image Classification System</h1>

<p align="center">
A cute, minimal, and scanner mobile app that can classify <strong>Sanrio characters</> from 
camera captures or  gallery images in real-time using <strong>TensorFlow Lite</strong> and <strong>Flutter</strong> ✨
</p>

---

# 📋 Overview

SanrioScan is a **machine learning-powered mobile app** built with **Flutter** that classifies popular Sanrio characters using **camera captures or gallery uploads**.  It demonstrates a **complete end-to-end ML pipeline**, 
from **data preprocessing**, **model training**, and **evaluation**, to **mobile deployment** using **TensorFlow Lite** for **real-time inference** 🌸

---

# 📌 Project Scope

- ⚡ **Type:** Supervised Learning – Image Classification  
- ⚡ **Algorithm:** Convolutional Neural Networks (**CNN**)  
- ⚡ **Platform:** Flutter (Android, iOS, Web, Desktop)  
- ⚡ **Dataset:** Sanrio Character Images  
- ⚡ **Problem:** Multi-class classification  
- ⚡ **Accuracy Target:** 90%+  
- ⚡ **Deployment:** Mobile-optimized with TensorFlow Lite  

---

# 🎯 Project Objectives

- 🐱 Accurately classify popular Sanrio characters  
- 📱 Implement a complete ML workflow in a mobile context  
- 🤖 Apply deep learning to real-world character recognition  
- 📷 Integrate **camera and gallery-based inference**  
- 📊 Visualize confidence scores and analytics  
- ✨ Demonstrate practical ML + Flutter development skills  

---

# 🛠️ Technology Stack

| Component        | Technology                  |
|-----------------|-----------------------------|
| ⚡ Mobile Framework | Flutter (Dart)             |
| ⚡ Deep Learning    | TensorFlow / TensorFlow Lite|
| ⚡ Model Type       | CNN                         |
| ⚡ Image Input      | Camera, Gallery             |
| ⚡ Backend          | Firebase (Firestore)        |
| ⚡ Visualization    | FL Chart                    |
| ⚡ Local Storage    | SharedPreferences           |
| ⚡ IDE              | VS Code / Android Studio    |

---

# 📂 Project Structure

```

Estrella_Sanrio_Characters_FinalProject/
├── android/
├── ios/
├── web/
├── windows/
├── macos/
├── linux/
├── assets/
│   ├── models/
│   │   ├── sanrio_model.tflite
│   │   └── labels.txt
│   └── images/
│       ├── hello_kitty.jpg
│       ├── my_melody.jpg
│       ├── kuromi.jpg
│       ├── pompom_purin.jpg
│       ├── cinnamoroll.jpg
│       ├── little_twin_stars.jpg
│       ├── keroppi.jpg
│       ├── badtz_maru.jpg
│       └── sample_test.jpg
├── lib/
├── test/
├── pubspec.yaml
├── analysis_options.yaml
└── README.md

```

---

# 📊 Dataset Information

| Character          | Samples |
|-------------------|--------|
| 🐱 Hello Kitty     | 150    |
| 🐰 My Melody       | 150    |
| 🐰 Kuromi          | 150    |
| 🐶 Pompompurin     | 150    |
| 🐶 Cinnamoroll     | 150    |
| 👯 Little Twin Stars | 150 |
| 🐸 Keroppi         | 150    |
| 🐧 Badtz-Maru      | 150    |

- **Total Images:** 1,200  
- **Image Size:** 224×224  
- **Color Space:** RGB  
- **Split:** 60% Train • 20% Validation • 20% Test  

---

# 🐾 Character Descriptions & History

| Character         | Description |
|------------------|-------------|
| 🐱 Hello Kitty     | A **cute white cat** with a **red bow**, iconic **Sanrio symbol**, born 1974. |
| 🐰 My Melody       | White rabbit with **pink hood**, loves baking, **gentle personality**, debuted 1975. |
| 🐰 Kuromi          | **Mischievous rabbit** with black jester hat, punk personality. |
| 🐶 Pompompurin     | Golden retriever with brown beret, loves **pudding**, cheerful. |
| 🐶 Cinnamoroll     | White puppy, long ears, blue eyes, loves flying & cinnamon rolls. |
| 👯 Little Twin Stars | Twin siblings Kiki (blue) & Lala (pink), **celestial beings**, playful. |
| 🐸 Keroppi         | Cheerful frog from Donut Pond, energetic & friendly. |
| 🐧 Badtz-Maru      | Black penguin, spiky hair, mischievous & rebellious. |

---

# 🧠 CNN Architecture

- **Input:** 224×224×3  
- **Conv2D (32) + ReLU + BatchNorm**  
- **MaxPooling**  
- **Conv2D (64) + ReLU + BatchNorm**  
- **MaxPooling**  
- **Conv2D (128) + ReLU + BatchNorm**  
- **MaxPooling**  
- **Flatten**  
- **Dense (256) + ReLU + Dropout(0.5)**  
- **Dense (128) + ReLU + Dropout(0.3)**  
- **Softmax Output (8 Classes)**  

---

# 📈 Performance Metrics

| Metric               | Result      |
|---------------------|------------|
| Training Accuracy    | 95%        |
| Validation Accuracy  | 93%        |
| Testing Accuracy     | 92%        |
| Precision            | 92%        |
| Recall               | 93%        |
| F1-Score             | 0.92       |
| Inference Time       | ~250–400 ms |

---

# 📱 App Features

- 📷 **Real-time camera classification**  
- 🖼️ **Gallery image selection**  
- 📊 **Confidence score visualization**  
- 📈 **Analytics dashboard**  
- 💾 **Local classification history**  
- ☁️ **Firebase Firestore integration**  
- 🎨 **Material Design 3 UI**  

---

# 🎓 Educational Value

- ✨ **Complete ML pipeline implementation**  
- 🤖 **CNN training & evaluation**  
- 📱 **Mobile AI deployment using TensorFlow Lite**  
- 🌐 **Flutter cross-platform development**  
- 🐾 **Real-world Sanrio character recognition**  

---

# 👤 Author

**J-Ann Mayel Sadagnot Estrella**  
BS Information Technology (BSIT) 

Caraga State University – Cabadbaran Campus  
Final Project • December 2025  

---

✨ Thank you for exploring **SanrioScan**!  
🎨 Classifying Sanrio characters with AI, one image at a time. 🌸
```
