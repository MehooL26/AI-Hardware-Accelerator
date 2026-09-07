# AI Hardware Accelerator for Neural Network Inference

A Verilog-based neural network accelerator for MNIST inference, developed from a trained TensorFlow model and implemented using fixed-point arithmetic on FPGA hardware.

**Objective:** Build a hardware accelerator for handwritten digit classification using the MNIST dataset.

**Pipeline:**
**Train → Quantize → Design → Implement → Verify → Deploy**
*TensorFlow → Fixed-Point → RTL/Verilog → Simulation → FPGA*

**Hardware Flow:**
**Arithmetic Units → MAC Engine → Neuron → Neural Network Layers → AI Accelerator → FPGA**

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
Fixed-point inference accuracy:
`= 97.3%`

# RTL Hardware Design
The neural network accelerator is implemented in **Verilog HDL** for FPGA deployment.

## Tools Used
**Verilog HDL · Xilinx Vivado · FPGA**

# Future Improvement
possible improvements:

- Parallel MAC architecture 
- Pipeline optimizaiton
- Systolic array implementation
- INT8 quantization
- CNN accelerator support 
- AXI interface integration
- DMA-based data transfer

# Skills Demonstrated
This project demonstrates practical experience in:

## Artificial Intelligence
- Neural netowrks
- Model training 
- Quantization
- Inference optimization

## Digital Design
- RTL coding
- Fixed-point arithmetic
- Hardware architecture
- Simulation

## FPGA Development 
- Vivado Workflow
- Synthesis
- Implementation
- Hardware acceleration

This project is actively under development and aims to implement a complete neural network accelerator on FPGA hardware.
