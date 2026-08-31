import numpy as np
from pathlib import Path
from tensorflow.keras.datasets import mnist

OUTPUT_DIR = Path("outputs/mem")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

(x_train, y_train), (x_test, y_test) = mnist.load_data()

with open (OUTPUT_DIR / "test_1000_images.mem","w") as images_file,\
     open (OUTPUT_DIR / "test_1000_labels.mem","w") as labels_file:

    for i in range(1000):
        test_image = x_test[i]
        actual_label = y_test[i]
        test_image = test_image.astype("float32") / 255.0
        test_image = test_image.reshape(784)
        image_fixed = np.round(test_image*256).astype(np.int16)

        for pixel in image_fixed:
            images_file.write(f"{pixel & 0xFFFF:04X}\n")

        labels_file.write(f"{actual_label:X}\n")
        print(f"Image {i}: label = {actual_label}")