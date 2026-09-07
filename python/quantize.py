'''currently the weights are stored in floating-point numbers but for the hardware it is difficult and
expensive to operate on these decimal (floating-point) numbers so we have to convert them into fixed-point
integers.

operating on floating-point numbers means adding more logic which results in more LUTs, more Flip-Flops,
more power, lower speed etc.'''

import numpy as np
from pathlib import Path
# ====================================================================
#  CONVERSION TO FIXED-POINT INTEGERS
# ====================================================================
WEIGHTS_DIR = Path("outputs/weights")
w1 = np.load(WEIGHTS_DIR/"w1.npy")
b1 = np.load(WEIGHTS_DIR/"b1.npy")
w2 = np.load(WEIGHTS_DIR/"w2.npy")
b2 = np.load(WEIGHTS_DIR/"b2.npy")


w1_fixed = np.round(w1*256).astype(np.int16)
b1_fixed = np.round(b1*256).astype(np.int16)
w2_fixed = np.round(w2*256).astype(np.int16)
b2_fixed = np.round(b2*256).astype(np.int16)

'''this section is called QUANTIZATION
quantization : process of converting high-precision numbers into lower-precision numbers while trying to 
preserve as much information as possible.'''

'''each number changes very slightly which is called quantization error thus the accuracy is not affected much'''

# ====================================================================
#  SAVING EXTRACTED WEIGHTS
# ====================================================================
'''we will be using ROM for this project as we just need to store the weights and not edit them, verilog MAC unit 
will only need to access those weights for its calculations.

it reads one weight and multiplies it in one clock cycle.'''

MODEL_DIR = Path("outputs/model")
WEIGHTS_DIR = Path("outputs/weights")

MODEL_DIR.mkdir(parents=True, exist_ok=True)
WEIGHTS_DIR.mkdir(parents=True, exist_ok=True)   

np.save(WEIGHTS_DIR/"w1_fixed.npy",w1_fixed)
np.save(WEIGHTS_DIR/"b1_fixed.npy",b1_fixed)
np.save(WEIGHTS_DIR/"w2_fixed.npy",w2_fixed)
np.save(WEIGHTS_DIR/"b2_fixed.npy",b2_fixed)

print("weights saved successfully")