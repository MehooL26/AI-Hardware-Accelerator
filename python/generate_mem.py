import numpy as np
from pathlib import Path
# ====================================================================
# 11. SAVING FIXED_POINT WEIGHTS IN MEM FILES
# ====================================================================

WEIGHTS_DIR = Path("outputs/weights")
w1_fixed = np.load(WEIGHTS_DIR/"w1_fixed.npy")
b1_fixed = np.load(WEIGHTS_DIR/"b1_fixed.npy")
w2_fixed = np.load(WEIGHTS_DIR/"w2_fixed.npy")
b2_fixed = np.load(WEIGHTS_DIR/"b2_fixed.npy")
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