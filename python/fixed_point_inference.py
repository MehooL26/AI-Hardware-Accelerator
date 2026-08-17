#THIS FILE IS FOR CROSS VERIFICATION FOR FPGA OUTPUTS

# ====================================================================
#   IMPORTING LIBRARIES
# ====================================================================
import numpy as np
from pathlib import Path
from tensorflow.keras.datasets import mnist

WEIGHTS_DIR = Path("outputs/weights")

# ====================================================================
#   LOADING WEIGHTS AND BIASES
# ====================================================================
w1_fixed = np.load(WEIGHTS_DIR/"w1_fixed.npy")
b1_fixed = np.load(WEIGHTS_DIR/"b1_fixed.npy")
w2_fixed = np.load(WEIGHTS_DIR/"w2_fixed.npy")
b2_fixed = np.load(WEIGHTS_DIR/"b2_fixed.npy")

# ====================================================================
#   LOADING ONE TEST IMAGE
# ====================================================================
'''i take an image from mnist data to test accuracy of the model

the image is normalized and then in the next section the weight are converted into fixed-point numbers'''
(_, _), (x_test, y_test) = mnist.load_data()
x_test = x_test.astype("float32")/255.0
x_test = x_test.reshape(-1, 784)

test_image = x_test[1]
actual_label = y_test[1]

# ====================================================================
#   CONVERTING TEST IMAGE INTO FIXED-POINT 
# ====================================================================
image_fixed = np.round(test_image*256).astype(np.int16)

# ====================================================================
#   MAC UNIT
# ====================================================================
'''MAC unit basically multiplies the weights and then keeps them adding.

but here since the weights were converted to fixed-point, 256 gets multiplied 2 times
thus we shift each output of the neuron by 8 bits to bring it back to being multiplied
only once.'''
def mac(input_vector, weight_vector, bias):
    accumulator = 0

    for i in range(len(input_vector)):
        product = int(input_vector[i]) * int(weight_vector[i])

        product = product >> 8

        accumulator += product
    
    accumulator += int(bias)
    return accumulator

# ====================================================================
#   ONE NEURON
# ====================================================================
def neuron(inputs, weights, bias):
    output = mac(inputs, weights, bias)

    if output < 0:      #ReLU
        output = 0
    
    return output

# ====================================================================
#   CREATING A LAYER TO TEST ALL 64 NEURONS
# ====================================================================
'''i just created a function to generate a loop for the output of all 64 neurons in the first layer'''
def layer(inputs, weights, biases):
    outputs = []

    for n in range(weights.shape[1]):       #weights.shape would give (784, 64) so shape[1] means 64
        neuron_output = neuron(inputs, weights[:, n], biases[n])
        
        outputs.append(neuron_output)
    
    return np.array(outputs, dtype=np.int32)

# ====================================================================
#   TESTING THE LAYER
# ====================================================================

'''hidden_output = layer(image_fixed, w1_fixed, b1_fixed)
print("hidden output : ",hidden_output[:64])
print(hidden_output.shape)

# ====================================================================
#   PASSING TO OUTPUT LAYER
# ====================================================================
final_output = layer(hidden_output, w2_fixed, b2_fixed)

print("final output shape: ", final_output.shape)
print("final output: ",final_output)

# ====================================================================
#   FINAL PREDICTION
# ====================================================================
predicted_digit = np.argmax(final_output)

print("predicted digit: ", predicted_digit)
print("actual digit: ", actual_label)'''

# ====================================================================
#   TESTING THE ACCURACY WITH A 1000 IMAGES
# ====================================================================
NUM_TEST_IMAGES = 1000
correct = 0

for i in range(NUM_TEST_IMAGES):
    test_image = x_test[i]
    actual_label = y_test[i]

    image_fixed = np.round(test_image*256).astype(np.int16)

    hidden_output = layer(image_fixed, w1_fixed, b1_fixed)

    final_output = layer(hidden_output, w2_fixed, b2_fixed)

    predicted_digit = np.argmax(final_output)

    if predicted_digit == actual_label:
        correct += 1

fixed_point_accuracy = correct / NUM_TEST_IMAGES

print("test images checked: ", NUM_TEST_IMAGES)
print("correct predictions: ", correct)
print("fixed-point accuracy: ", fixed_point_accuracy*100,"%")