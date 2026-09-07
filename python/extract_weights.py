import numpy as np
from pathlib import Path
from tensorflow import keras

MODEL_PATH = Path("outputs/model/mnist_dense_model.keras")
model = keras.models.load_model(MODEL_PATH)

'''weights are basically a quantity that defines which factor is the most important

bias is basically a fixed number which shifts the final output'''

w1, b1 = model.layers[0].get_weights()   #extracting weights from layer 1, i.e. 64 neurons layer
w2, b2 = model.layers[1].get_weights()   #extracting weights from layer 2, i.e. 10 neurons output layer

'''these 4 variables contain all the learning data of the model, now if we delete the dataset,
it will still be able to give the right predictions'''

'''print("----shapes of extracted weights and biases----")
print(w1.shape)     #output : (784,64) every neuron has 784 weights and there are 64 neurons
print(b1.shape)     #output : (64,) one neuron has 1 bias 
print(w2.shape)     #output : (64,10) 64 inputs and 10 outputs
print(b2.shape)     #output : (10,) 10 bias for 10 neurons

print(w1[:10, 0])'''

WEIGHTS_DIR = Path("outputs/weights")
WEIGHTS_DIR.mkdir(parents=True, exist_ok=True)

np.save(WEIGHTS_DIR/"w1.npy",w1)
np.save(WEIGHTS_DIR/"b1.npy",b1)
np.save(WEIGHTS_DIR/"w2.npy",w2)
np.save(WEIGHTS_DIR/"b2.npy",b2)

print("weights saved successfully")