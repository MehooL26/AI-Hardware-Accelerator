import numpy as np
from tensorflow.keras.datasets import mnist
from pathlib import Path

# Load MNIST
(_, _), (x_test, y_test) = mnist.load_data()

# Select the SAME image used in fixed_point_inference.py
test_image = x_test[1]
actual_label = y_test[1]

# Normalize
test_image = test_image.astype("float32") / 255.0

# Flatten 28x28 -> 784
test_image = test_image.reshape(784)

# Convert to Q8.8
image_fixed = np.round(test_image * 256).astype(np.int16)

# Create output directory
output_dir = Path("outputs/mem")
output_dir.mkdir(parents=True, exist_ok=True)

# Write values in hexadecimal format
with open(output_dir / "test_image.mem", "w") as f:

    for value in image_fixed:

        # Convert signed int16 to 16-bit two's complement
        hex_value = int(value) & 0xFFFF

        f.write(f"{hex_value:04X}\n")

print("Test image generated successfully.")
print("Actual MNIST label:", actual_label)
print("Number of pixels:", len(image_fixed))
print("First 10 fixed-point values:", image_fixed[:10])