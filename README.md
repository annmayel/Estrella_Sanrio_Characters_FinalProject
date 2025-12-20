<h1 align="center">˖° 𐙚 ₊ ⊹ ♡ SanrioSukyan – Sanrio Character Image Classification System ˚✿˖°₊ ⊹ ♡</h1> 
<h2 align="center">──୨ৎ──𝓱𝓮𝓵𝓵𝓸 𝓴𝓲𝓽𝓽𝔂───୨ৎ──૮・ﻌ・ა──୨ৎ───୨ৎ──(◣ _ ◢)──୨ৎ──</h2>

<p align="center">
A cute, minimal, and scanner mobile app that can classify <strong>Sanrio characters</strong><br>
from camera captures or gallery images in real-time using  
<strong>TensorFlow Lite</strong> and <strong>Flutter</strong> ✨
</p>


# 📋 Overview

SanrioSukyan (すきゃん) is a machine learning–powered mobile application built with Flutter that classifies popular Sanrio characters using camera input or gallery images. This project demonstrates a complete end-to-end machine learning pipeline, from dataset preparation and CNN training, to TensorFlow Lite deployment and real-time mobile inference 🌸

---

# 📌 Project Scope

- ⚡ Learning Type: Supervised Learning – Image Classification  
- ⚡ Algorithm: Convolutional Neural Networks (CNN)  
- ⚡ Platform: Flutter (Android)  
- ⚡ Dataset: Sanrio Character Images  
- ⚡ Problem: Multi-class classification  
- ⚡ Accuracy Target: 90%+  
- ⚡ Deployment: Mobile-optimized with TensorFlow Lite  

---

# 🎯 Project Objectives

- 🐱 Accurately classify popular Sanrio characters  
- 📱 Implement a full ML workflow in a mobile environment  
- 🤖 Apply CNN-based deep learning for character recognition  
- 📷 Support camera and gallery-based image inference  
- 📊 Display prediction confidence scores  
- ✨ Demonstrate ML + Flutter integration skills  

---

# 🛠️ Technology Stack

| Component         | Technology                    |
|-------------------|------------------------------|
| 📱 Mobile Framework | Flutter (Dart)               |
| 🤖 Deep Learning   | TensorFlow / TensorFlow Lite  |
| 🧠 Model Type      | CNN                          |
| 📷 Image Input     | Camera, Gallery              |
| ☁️ Backend        | Firebase (Firestore, Realtime DB) |
| 📊 Visualization   | FL Chart                     |
| 💾 Local Storage   | SharedPreferences            |
| 🧰 IDE             | VS Code / Android Studio      |

---

# 📊 Dataset Information

| Character           | Samples |
|---------------------|---------|
| 🐱 Hello Kitty      | 150     |
| 🐰 My Melody        | 150     |
| 🐰 Kuromi           | 150     |
| 🐶 Pompompurin      | 150     |
| 🐶 Cinnamoroll      | 150     |
| 👯 Little Twin Stars| 150     |
| 🐸 Keroppi          | 150     |
| 🐧 Badtz-Maru       | 150     |

- **Total Images:** 1,200  
- **Image Size:** 224 × 224  
- **Color Space:** RGB  
- **Split:** 60% Training • 20% Validation • 20% Testing  

---

# 🐾 Character Descriptions

| Character           | Description                          |
|---------------------|------------------------------------|
| 🐱 Hello Kitty      | White cat with red bow, iconic Sanrio character |
| 🐰 My Melody        | Gentle rabbit with pink hood        |
| 🐰 Kuromi           | Mischievous rabbit with punk personality |
| 🐶 Pompompurin      | Golden retriever who loves pudding  |
| 🐶 Cinnamoroll      | Puppy with long ears who can fly    |
| 👯 Little Twin Stars| Twin celestial siblings Kiki & Lala |
| 🐸 Keroppi          | Cheerful frog from Donut Pond       |
| 🐧 Badtz-Maru       | Rebellious penguin with spiky hair  |

---

# 🧠 CNN Architecture

- Input: 224 × 224 × 3  
- Conv2D (32) + ReLU + BatchNorm  
- MaxPooling  
- Conv2D (64) + ReLU + BatchNorm  
- MaxPooling  
- Conv2D (128) + ReLU + BatchNorm  
- MaxPooling  
- Flatten  
- Dense (256) + ReLU + Dropout (0.5)  
- Dense (128) + ReLU + Dropout (0.3)  
- Softmax Output (8 Classes)  

---

# 📈 Performance Metrics

| Metric              | Result      |
|---------------------|-------------|
| Training Accuracy   | 95%         |
| Validation Accuracy | 93%         |
| Testing Accuracy    | 92%         |
| Precision           | 92%         |
| Recall              | 93%         |
| F1-Score            | 0.92        |
| Inference Time      | ~250–400 ms |

---

# 📱 App Features

- 📷 Real-time camera classification  
- 🖼️ Gallery image selection  
- 📊 Confidence score visualization  
- 📈 Analytics dashboard  
- 💾 Local prediction history  
- ☁️ Firebase Firestore integration  
- 🎨 Material Design 3 UI  

---

# 🎓 Educational Value

- ✔️ Complete ML pipeline implementation  
- ✔️ CNN model training and evaluation  
- ✔️ TensorFlow Lite mobile deployment  
- ✔️ Flutter cross-platform development  
- ✔️ Real-world image classification use case  

---

# 👤 Author

**J-Ann Mayel Sadagnot Estrella**  
BS Information Technology (BSIT)  
Caraga State University – Cabadbaran Campus  

Final Project – December 2025  

---

✨ Thank you for exploring SanrioSukyan!  
🎨 Classifying Sanrio characters with AI, one image at a time 🌸
