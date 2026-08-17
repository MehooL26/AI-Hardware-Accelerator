# 🚀 AI Hardware Accelerator for Neural Network Inference 
A custom FPGA-based AI accelerator designed to perform neural network inference using dedicated hardware logic. This project focuses on bridging the gap between **Artificial Intelligence algorithms and VLSI hardware design** by converting a trained neural network model into an optimized RTL implementation using **Verilog HDL**.

# 📌 Introduction
AI models are traditionally executed on CPUs and GPUs using software frameworks such as TensorFlow and PyTorch. While these platforms provide flexibility, they introduce computational overhead and consume significant power for repetitive mathematical operations.

Modern AI applications require specialized hardware architectures capable of performing neural network computations efficiently with low latency and high energy efficiency.

This project focuses on designing a custom **AI Hardware Accelerator** using **Verilog HDL and FPGA technology**. The accelerator implements the mathematical operations required for neural network inference, including:

- Multiplication
- Addition
- Multiply-Accumulate (MAC) operations
- Activation functions
- Layer computation

The project follows a complete AI-tohardware design flow:

AI Model Training
↓
Weight Extraction
↓
Fixed-Point Quantization
↓
Hardware Architecture Design
↓
RTL Implementation
↓
Simulation & Verification
↓
FPGA Deployment

The goal is to understand how high-level AI algorithms are transformed into low-level digital hardware architectures used in modern AI chips.

# 🎯 Project Objective
The objective of this project is to build a hardware accelerator capable of performing handwritten digit classification using the MNIST dataset.

Instead of running inference through software, the neural network computation is converted into dedicated hardware blocks implemented using Verilog.

The accelerator is designed using a bottom-up approach:

Arithmetic Units
↓
Mac Engine
↓
Neuron
↓
Neural Network Layers
↓
Complete AI Accelerator
↓
FPGA Implementation

# Neural Network Architecture
The implemented neural network is a fully connected neural network trained on the MNIST dataset.

Architecture:
Input Layer
784 Pixels
↓
Hidden Layer
64 Neurons
Activation : ReLU
↓
Output Layer
10 Neurons
↓
Predicted Digit (0-9)

## Training Pipeline
MNIST Dataset <br>
↓<br>
Image Normalization<br>
↓<br>
Neural Network Training <br>
↓<br>
Weight Extraction<br>
↓<br>
Hardware Conversion<br>

## Training Details
- Dataset: MNIST handwritten digits
- Input size: 784 pixels
- Hidden neurons: 64
- Output classes: 10
- Framework: TensorFlow / Keras

# Fixed-Point Quantization
FPGA hardware does not efficiently support floating-point calculations.

Therefore, all neural network parameters were converted from floating-point values into fixed-point integers.

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

# Completed RTL Modules
## 1. Fixed-point Multiplier 
A custom multiplier designed for Q8.8 fixed-point arithmetic.

Function:
Output = (Input A * Input B) >> 8

Features:
- 16-bit signed inputs 
- Fixed-point scaling
- Synthesizable RTL

## 2. Multiply-Accumulate (MAC) Unit
The MAC unit is the fundamental computational block of neural network hardware.

Operation:
Accumulator = Previous Value + (Input * Weight)

Architecture:
Input
|
|
Multiplier
|
|
Adder
|
|
Accumulator

Features:
- Clocked Simulation
- Reset Support
- Enable control
- Signed arithmetic

Verification:
✅ Testbench created
✅ Simulation completed

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

This project is actively under development and aims to implement a complete neural netowrk accelerator on FPGA hardware.
