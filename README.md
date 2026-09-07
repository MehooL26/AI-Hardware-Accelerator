# AI Hardware Accelerator for Neural Network Inference

A Verilog-based neural network accelerator for MNIST inference, developed from a trained TensorFlow model and implemented using fixed-point arithmetic on FPGA hardware.

**Objective:** Build a hardware accelerator for handwritten digit classification using the MNIST dataset.

**Pipeline:**  
**Train → Quantize → Design → Implement → Verify → Deploy**  
*TensorFlow → Fixed-Point → RTL/Verilog → Simulation → FPGA*

**Hardware Flow:**  
**Arithmetic Units → MAC Engine → Neuron → Neural Network Layers → AI Accelerator → FPGA**

## Repository Structure

```text
AI-Hardware-Accelerator/
│
├── python/
│   ├── train.py
│   ├── extract_weights.py
│   ├── quantize.py
│   ├── generate_mem.py
│   ├── evaluate.py
│   ├── fixed_point_inference.py
│   └── generate_test_image.py
│
├── verilog/
│   ├── fixed_point_multiplier.v
│   ├── mac_unit.v
│   ├── neuron.v
│   ├── hidden_layer.v
│   ├── output_multiplier.v
│   ├── output_mac.v
│   ├── output_layer.v
│   ├── argmax.v
│   └── ai_accelerator.v
│
├── testbenches/
│   ├── mac_tb.v
│   ├── hidden_layer_tb.v
│   └── ai_accelerator_tb.v
│
├── outputs/
│   ├── model/
│   ├── weights/
│   └── mem/
│
├── README.md
├── requirements.txt
├── .gitignore 
```


# Neural Network Architecture

**MNIST → 784 Inputs → 64 Hidden (ReLU) → 10 Outputs → Digit (0–9)**

## Training Pipeline

**MNIST → Normalize → Train Model → Extract Weights → Hardware Conversion**

# Fixed-Point Quantization

Neural network weights and biases were converted to **16-bit Q8.8 fixed-point format** for hardware implementation.

### Q8.8 Fixed Point

**16-bit signed:** 8-bit integer + 8-bit fraction  
**Conversion:** `Hardware Value = Float × 256`

# Python Hardware Simulator

A Python-based simulator was developed to verify fixed-point hardware behavior before Verilog implementation.

**Implemented:** Fixed-Point Multiplication · MAC · Neuron · Layer Execution

The simulator verified that the quantized hardware representation maintained model accuracy.

## Result

**Fixed-Point Inference Accuracy: `97.3%`**

# RTL Hardware Design

The neural network accelerator is implemented in **Verilog HDL** for FPGA deployment.

## Tools Used

**Verilog HDL · Xilinx Vivado · FPGA**

# Verification & Results

## 1. Python Fixed-Point Inference

| Test | Images Tested | Accuracy | Status |
|------|---------------|----------|--------|
| Fixed-Point Inference | 1000 | 97.3% | ✅ |
| Test 2 | — | — | — |
| Test 3 | — | — | — |

## 2. Verilog Module Verification

| Module | Test Cases | Passed | Failed | Status |
|--------|------------|--------|--------|--------|
| Fixed-Point Multiplier | — | — | — | — |
| MAC Unit | — | — | — | — |
| Neuron | — | — | — | — |
| Hidden Layer | — | — | — | — |
| Output Layer | — | — | — | — |
| Argmax | — | — | — | — |

## 3. End-to-End Accelerator

| Test | Images Tested | Correct Predictions | Accuracy | Status |
|------|---------------|---------------------|----------|--------|
| MNIST Test Set | — | — | — | — |
| 1000 Image Test | — | — | — | — |

## 4. FPGA Results

| Parameter | Result |
|-----------|--------|
| FPGA Board | — |
| Clock Frequency | — |
| LUTs | — |
| Flip-Flops | — |
| BRAM | — |
| DSPs | — |
| Power | — |
| Inference Latency | — |
| Throughput | — |

## How to Run

### Python Pipeline

From the project root:

```bash
python python/train.py
python python/evaluate.py
python python/export_weights.py
python python/quantize.py
python python/generate_mem.py
```

### Fixed-Point Inference

```bash
python python/fixed_point_inference.py
```

Current Q8.8 fixed-point accuracy: **97.3% on 1,000 MNIST test images.**

### Test Data Generation

For a single-image RTL test:

```bash
python python/generate_test_image.py
```

For multi-image accuracy testing:

```bash
python python/generate_test_data.py
```

### Verilog Simulation

Compile the RTL and testbench using Icarus Verilog:

```bash
iverilog -g2012 -o output_sim verilog/*.v testbenches/ai_accelerator_tb.v
```

Run the simulation:

```bash
vvp output_sim
```

### FPGA Implementation

The RTL design can be imported into **Xilinx Vivado** for synthesis and implementation. Resource utilization, timing, frequency, and power results will be added after FPGA analysis.


# Future Improvements

- Parallel MAC architecture
- Pipeline optimization
- Systolic array implementation
- INT8 quantization
- CNN accelerator support
- AXI interface integration
- DMA-based data transfer

# Skills Demonstrated

### Artificial Intelligence
- Neural networks
- Model training
- Quantization
- Inference optimization

### Digital Design
- RTL coding
- Fixed-point arithmetic
- Hardware architecture
- Simulation

### FPGA Development
- Vivado workflow
- Synthesis
- Implementation
- Hardware acceleration

---

**Status:** Actively under development — working toward a complete neural network accelerator on FPGA hardware.