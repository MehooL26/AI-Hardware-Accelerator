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

## Format Used
### Q8.8 Fixed Point
Total Bits : 16, integer -> 8 bits, fraction -> 8 bits

Conversion: 
Hardware Value = Floating Point Value * 256

The converted weights and biases were stored as 16-bit signed integers.

# Hardware Weight Generation
The trained model parameters were exported into memory initialization files.

These files will later be loaded into FPGA memory blocks.

# Python Hardware Simulator 
Before implementing the design in Verilog, a Python-based hardware simulator was created to verify the fixed-point behavior.

Implemented: 
- Fixed-point multiplication 
- MAC operation
- Neuron computation
- Layer execution

The simulator verified that the quantized hardware representation maintained model accuracy.

## Result
Fixed-point inference accuracy:
= 97.3%

# RTL Hardware Design
The hardware accelerator is being developed using Verilog HDL.

## Tools Used
- Verilog HDL
- Xilinx Vivado
- FPGA

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
