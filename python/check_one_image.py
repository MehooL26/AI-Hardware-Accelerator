import numpy as np
from pathlib import Path
from tensorflow.keras.datasets import mnist

WEIGHTS_DIR = Path("outputs/weights")

w1_fixed = np.load(WEIGHTS_DIR / "w1_fixed.npy")
b1_fixed = np.load(WEIGHTS_DIR / "b1_fixed.npy")
w2_fixed = np.load(WEIGHTS_DIR / "w2_fixed.npy")
b2_fixed = np.load(WEIGHTS_DIR / "b2_fixed.npy")

(_, _), (x_test, y_test) = mnist.load_data()

x_test = x_test.astype("float32") / 255.0
x_test = x_test.reshape(-1, 784)

test_image = x_test[1]
actual_label = y_test[1]

image_fixed = np.round(test_image * 256).astype(np.int16)


def mac(input_vector, weight_vector, bias):
    accumulator = 0

    for i in range(len(input_vector)):
        product = int(input_vector[i]) * int(weight_vector[i])
        product = product >> 8
        accumulator += product

    accumulator += int(bias)

    return accumulator


def neuron(inputs, weights, bias):
    output = mac(inputs, weights, bias)

    if output < 0:
        output = 0

    return output


def layer(inputs, weights, biases):
    outputs = []

    for n in range(weights.shape[1]):
        neuron_output = neuron(
            inputs,
            weights[:, n],
            biases[n]
        )

        outputs.append(neuron_output)

    return np.array(outputs, dtype=np.int32)


# Hidden layer
hidden_output = layer(
    image_fixed,
    w1_fixed,
    b1_fixed
)

# Output layer
final_output = layer(
    hidden_output,
    w2_fixed,
    b2_fixed
)

prediction = np.argmax(final_output)

print("------------------------------------------")
print("PYTHON FIXED-POINT TEST")
print("------------------------------------------")

print("Actual label =", actual_label)
print("Prediction    =", prediction)

print("------------------------------------------")
print("HIDDEN OUTPUTS")
print("------------------------------------------")

for i, value in enumerate(hidden_output):
    print(f"Hidden[{i}] = {value}")

print("------------------------------------------")
print("OUTPUT SCORES")
print("------------------------------------------")

for i, value in enumerate(final_output):
    print(f"Output[{i}] = {value}")

print("------------------------------------------")