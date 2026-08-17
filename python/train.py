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

# ====================================================================
# 8. EXTRACTING WEIGHTS AND BIASES
# ====================================================================
'''weights are basically a quantity that defines which factor is the most important

bias is basically a fixed number which shifts the final output'''

w1, b1 = model.layers[0].get_weights()   #extracting weights from layer 1, i.e. 64 neurons layer
w2, b2 = model.layers[1].get_weights()   #extracting weights from layer 2, i.e. 10 neurons output layer

'''these 4 variables contain all the learning data of the model, now if we delete the dataset,
it will still be able to give the right predictions'''

print("----shapes of extracted weights and biases----")
print(w1.shape)     #output : (784,64) every neuron has 784 weights and there are 64 neurons
print(b1.shape)     #output : (64,) one neuron has 1 bias 
print(w2.shape)     #output : (64,10) 64 inputs and 10 outputs
print(b2.shape)     #output : (10,) 10 bias for 10 neurons

print(w1[:10, 0])

# ====================================================================
# 9. CONVERSION TO FIXED-POINT INTEGERS
# ====================================================================
'''currently the weights are stored in floating-point numbers but for the hardware it is difficult and
expensive to operate on these decimal (floating-point) numbers so we have to convert them into fixed-point
integers.

operating on floating-point numbers means adding more logic which results in more LUTs, more Flip-Flops,
more power, lower speed etc.'''

w1_fixed = np.round(w1*256).astype(np.int16)
b1_fixed = np.round(b1*256).astype(np.int16)
w2_fixed = np.round(w2*256).astype(np.int16)
b2_fixed = np.round(b2*256).astype(np.int16)

'''this section is called QUANTIZATION
quantization : process of converting high-precision numbers into lower-precision numbers while trying to 
preserve as much information as possible.'''

'''each number changes very slightly which is called quantization error thus the accuracy is not affected much'''

# ====================================================================
# 10. SAVING EXTRACTED WEIGHTS
# ====================================================================
'''we will be using ROM for this project as we just need to store the weights and not edit them, verilog MAC unit 
will only need to access those weights for its calculations.

it reads one weight and multiplies it in one clock cycle.'''

MODEL_DIR = Path("outputs/model")
WEIGHTS_DIR = Path("outputs/weights")

MODEL_DIR.mkdir(parents=True, exist_ok=True)
WEIGHTS_DIR.mkdir(parents=True, exist_ok=True)

model.save(MODEL_DIR/"mnist_dense_model.keras")     #saving complete model for making changes in future

np.save(WEIGHTS_DIR/"w1.npy",w1)
np.save(WEIGHTS_DIR/"b1.npy",b1)
np.save(WEIGHTS_DIR/"w2.npy",w2)
np.save(WEIGHTS_DIR/"b2.npy",b2)

np.save(WEIGHTS_DIR/"w1_fixed.npy",w1_fixed)
np.save(WEIGHTS_DIR/"b1_fixed.npy",b1_fixed)
np.save(WEIGHTS_DIR/"w2_fixed.npy",w2_fixed)
np.save(WEIGHTS_DIR/"b2_fixed.npy",b2_fixed)

print("weights saved successfully")

# ====================================================================
# 11. SAVING FIXED_POINT WEIGHTS IN MEM FILES
# ====================================================================
'''verilog cannot directly read these numpy arrays so we save them in a memory file which contains only text,
then verilog has a built-in function $readmemh or $readmemb

we also need to convert these decimal values to hexadecimal for the hardware to read'''

MEM_DIR = Path("outputs/mem")
MEM_DIR.mkdir(parents=True, exist_ok=True)

def save_mem_file(filename, array):
    flat_array = array.flatten()

    with open(filename,"w") as f:
        for value in flat_array:
            value = int(value)

            value = value & 0xFFFF 
            f.write(f"{value:04X}\n")

save_mem_file(MEM_DIR / "w1_fixed.mem", w1_fixed)
save_mem_file(MEM_DIR / "b1_fixed.mem", b1_fixed)
save_mem_file(MEM_DIR / "w2_fixed.mem", w2_fixed)
save_mem_file(MEM_DIR / "b2_fixed.mem", b2_fixed)

print("----memory files saved------")