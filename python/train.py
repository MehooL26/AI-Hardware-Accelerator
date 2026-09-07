# ====================================================================
#  1. IMPORTING LIBRARIES
# ====================================================================
import numpy as np
from pathlib import Path
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.datasets import mnist

# ====================================================================
# 2. LOADING THE DATASET
# ====================================================================

'''x_train contains 60000 images with 28*28 size i.e. 28 rows and columns
y_train contains the labels for each image i.e. what number is in the image
x_test contains 10000 images for testing, used only after training
y_test contains the correct answers for the unseen images'''
(x_train, y_train), (x_test, y_test) = mnist.load_data()
'''image size i.e. 28*28 is just numbers for each pixel
0 -> black and 255 -> white, everything in between is grey,
so an image is just a matrix of numbers'''

print("------ORIGINAL DATASET--------")
print("Training images :", x_train.shape)
print("Training labels :", y_train.shape)
print("Testing images  :", x_test.shape)
print("Testing labels  :", y_test.shape)
# ====================================================================
# 3. PREPROCESSING / NORMALIZATION
# ====================================================================
'''a pixel is stored in 8 bits and 2^8 = 256 so every pixel lies between 0-255.
But these large numbers can cause unstable learning so we scale it down between 0 and 1,
by dividing it by 255. This is called NORMALIZATION OF DATA

and we need to convert these numbers datatype into float otherwise each number will be either 0 or 1'''

x_train = x_train.astype("float32") / 255.0
x_test = x_test.astype("float32") / 255.0

'''by default python stores in uint8 : unsigned integer in 8 bits, which can only store whole numbers,
and float32 is used instead of float64 because float64 uses double the memory compared to float32.'''

print("------AFTER NORMALIZATION--------")
print("Training images :", x_train.dtype)
print("Testing images  :", x_test.dtype)

# ====================================================================
# 4. FLATTENING 
# ====================================================================
'''in this project, we need to implement this model on a hardware too, hardware cannot understand
images as they are, it can understand numbers in 1D. So, since there are 28*28 numbers in a 2D format, we flatten 
then numbers, this way no information is lost, and I am building a dense network which requires flattening '''

x_train = x_train.reshape(-1, 784)
x_test = x_test.reshape(-1, 784)

# -1 means let numpy automatically calculate number of images

print("------AFTER FLATTENING--------")
print("Training images :", x_train.shape)
print("Training labels :", y_train.shape)
print("Testing images  :", x_test.shape)
print("Testing labels  :", y_test.shape)

# ====================================================================
# 5. BUILDING DENSE NEURAL NETWORK
# ====================================================================
'''now this part is the brain of the project which learns each pattern.
we give 784 inputs and we use 64 neurons, each neuron has 784 weights and each neuron
learns different features like curves, loops, corners etc.

this model is called a dense neural network because each input is connected to every neuron.

the neurons themselves learn the necessary patterns.'''

'''next we take 10 output neurons because mnist data has exactly 10 digits 0-9.
the neuron with largest score is the predicted output value.'''

model = keras.Sequential([
    layers.Input(shape=(784,)),
    layers.Dense(64, activation='relu'),
    layers.Dense(10, activation='softmax')
])

'''ReLU : Rectified Linear Unit, what relu does is it eliminates any quality learned by the neuron which
is not confident in its learning. Low confidence gives a negative value, so relu filters out all the negative 
values and change them to 0. It just takes positive values (learning with high confidence)'''

'''SoftMax : what softmax does is, it changes the scores in the output layer into probabilities so the final output
is shown such that, "I am 95% sure the digit is 3."'''

print("------model summary------")
model.summary()

# ====================================================================
# 6. COMPILING THE MODEL
# ====================================================================
#now this part tells the model on how to learn things

'''1. loss function : measures how far is the prediction from the correct answer.
In digit recognition we need multi-class classification so we use cross entropy
sparse : stores the digit 3 as 3 and not in binary digits, which saves memory.'''

'''2. optimizer : the model does not correct by itself, optimizer adjusts the weights

3. metrics : gives us the accuracy'''

model.compile(
    optimizer = "adam",
    loss = "sparse_categorical_crossentropy",
    metrics = ["accuracy"]
)

'''model.compile(
    loss = keras.losses.SparseCategoricalCrossentropy(from_logits=True),
    optimizer = keras.optimizers.Adam(learning_rate=0.001),
    metrics = ["accuracy"],
)'''

'''an important concept here is backpropagation, consider it as the coach which tells what is 
wrong with the weights and where is it wrong, and adam is the player which makes the changes and
loss function tells that it was wrong.
loss function -> backpropagation -> adam'''

# ====================================================================
# 7. TRAINING THE MODEL
# ====================================================================
'''epochs mean the number of times the model goes through the dataset to adjust its weights

batchsize is the number after which the weights will be updated'''

history = model.fit(
    x_train,
    y_train,
    epochs = 5,
    batch_size = 32,
    validation_data = (x_test, y_test),
    verbose = 2
)

MODEL_DIR = Path("outputs/model")
MODEL_DIR.mkdir(parents=True, exist_ok=True)
model.save(MODEL_DIR/"mnist_dense_model.keras")  

