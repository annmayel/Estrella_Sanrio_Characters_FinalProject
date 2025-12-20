import cv2
import os

# 🔹 Automatically find your 'hello kitty' folder
input_folder = os.path.join(os.getcwd(), "hello kitty")

# 🔹 Output folder for resized images
output_folder = "resized_hello_kitty"
if not os.path.exists(output_folder):
    os.makedirs(output_folder)
    print(f"✅ Created output folder: {output_folder}")

# 🔹 If the espasol folder doesn’t exist yet
if not os.path.exists(input_folder):
    os.makedirs(input_folder)
    print(f"⚠️ Created folder {input_folder}. Please add your espasol images and run again.")
    exit()

# 🔹 Set image size for Teachable Machine
target_size = (224, 224)

# 🔹 List image files
files = os.listdir(input_folder)
image_files = [f for f in files if f.lower().endswith(('.jpg', '.jpeg', '.png'))]
image_files = image_files[:250]  # limit to 250 images

# 🔹 Check if folder has images
if not image_files:
    print("⚠️ No image files found in the 'espasol' folder.")
    exit()

# 🔹 Process and resize
for img_name in image_files:
    img_path = os.path.join(input_folder, img_name)
    img = cv2.imread(img_path)
    if img is not None:
        resized = cv2.resize(img, target_size)
        output_path = os.path.join(output_folder, img_name)
        cv2.imwrite(output_path, resized)
    else:
        print(f"⚠️ Skipped unreadable image: {img_name}")

print(f"✅ Done! {len(image_files)} espasol images resized and saved to '{output_folder}' folder.")