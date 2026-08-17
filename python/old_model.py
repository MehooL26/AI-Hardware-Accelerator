import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras import regularizers
from tensorflow.keras.datasets import mnist

(x_train, y_train), (x_test, y_test) = mnist.load_data() 

x_train = x_train.reshape(-1,28,28,1).astype("float32") / 255.0   #NORMALIZING THE DATA
x_test = x_test.reshape(-1,28,28,1).astype("float32") / 255.0

#BUILDING THE MODEL
model = keras.Sequential(
    [
        keras.Input(shape=(28,28,1)),
        layers.Conv2D(32,3, padding='valid', activation='relu'),
        layers.MaxPooling2D(pool_size=(2,2)),
        layers.Flatten(),
        layers.Dense(10)
    ]
)

#TRAINING THE MODEL
model.compile(
    loss = keras.losses.SparseCategoricalCrossentropy(from_logits=True),
    optimizer = keras.optimizers.Adam(learning_rate=0.001),
    metrics = ["accuracy"],
)

model.fit(x_train, y_train, epochs=10, batch_size=32, verbose=2)

model.evaluate(x_test, y_test)

# SAVING THE WEIGHTS WE GET FROM THE MODEL
w1,b1 = model.layers[0].get_weights()
w2,b2 = model.layers[3].get_weights()

print(w1.shape)
print(b1.shape)
print(w2.shape)
print(b2.shape)

np.save("w1.npy", w1)
np.save("b1.npy", b1)
np.save("w2.npy", w2)
np.save("b2.npy", b2)

#LOADING THE WEIGHTS
w1 = np.load("w1.npy")
b1 = np.load("w1.npy")
w2 = np.load("w1.npy")
b2 = np.load("w1.npy")

#FIXED POINT CONVERSION
w1_fixed = np.round(w1*256).astype(np.int16)    #round used to round down the integer values, and int16 used to store those values as signed bits
b1_fixed = np.round(b1*256).astype(np.int16)
w2_fixed = np.round(w2*256).astype(np.int16)
b2_fixed = np.round(b2*256).astype(np.int16)

#SAVING THESE WEIGHTS
np.save("w1_fixed.npy",w1_fixed)
np.save("b1_fixed.npy",b1_fixed)
np.save("w2_fixed.npy",w2_fixed)
np.save("b2_fixed.npy",b2_fixed)
# --------------------------------------------
#   MAC unit
# --------------------------------------------
def mac(inputs, weights):
    acc = 0
    for i in range(len(inputs)):
        acc += inputs[i]*weights[i]
    return acc

# --------------------------------------------
#   NEURON LAYER
# --------------------------------------------
def neuron(inputs, weights, bias):
    output = mac(inputs, weights)
    output += bias      #bias is used so that the output is always non-zero

    if output<0:
        output = 0

    return output


# --------------------------------------------
#   LAYER
# --------------------------------------------
def layer(inputs, weights, biases):
    outputs = []

    for n in range(weights.shape[1]):
        outputs.append(
            neuron(inputs, weights[:, n], biases[n])
        )

        return np.array(outputs, dtype=np.int32)
