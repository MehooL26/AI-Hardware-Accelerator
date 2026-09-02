# AI Hardware Accelerator for Neural Network Inference 
A custom FPGA-based AI accelerator designed to perform neural network inference using dedicated hardware logic. This project focuses on bridging the gap between **Artificial Intelligence algorithms and VLSI hardware design** by converting a trained neural network model into an optimized RTL implementation using **Verilog HDL**.

# Introduction
A Verilog-based neural network accelerator for MNIST inference, designed from a trained TensorFlow model and implemented using fixed-point arithmetic.

This project focuses on designing a custom **AI Hardware Accelerator** using **Verilog HDL and FPGA technology**. The accelerator implements the mathematical operations required for neural network inference, including:

- Multiplication
- Addition
- Multiply-Accumulate (MAC) operations
- Activation functions
- Layer computation

The project follows a complete AI to hardware design flow:

AI Model Training <br>
↓<br>
Weight Extraction<br>
↓<br>
Fixed-Point Quantization<br>
↓<br>
Hardware Architecture Design<br>
↓<br>
RTL Implementation<br>
↓<br>
Simulation & Verification<br>
↓<br>
FPGA Deployment

[python] [TensorFlow] [Verilog] [Vivado] [MNIST]

The goal is to understand how high-level AI algorithms are transformed into low-level digital hardware architectures used in modern AI chips.

# Project Objective
The objective of this project is to build a hardware accelerator capable of performing handwritten digit classification using the MNIST dataset.

Instead of running inference through software, the neural network computation is converted into dedicated hardware blocks implemented using Verilog.

The accelerator is designed using a bottom-up approach:

Arithmetic Units<br>
↓<br>
Mac Engine<br>
↓<br>
Neuron<br>
↓<br>
Neural Network Layers<br>
↓<br>
Complete AI Accelerator<br>
↓<br>
FPGA Implementation

# Neural Network Architecture
The implemented neural network is a fully connected neural network trained on the MNIST dataset.

Architecture:
Input Layer <br>
784 Pixels<br>
↓<br>
Hidden Layer<br>
64 Neurons<br>
Activation : ReLU<br>
↓<br>
Output Layer<br>
10 Neurons<br>
↓<br>
Predicted Digit (0-9)

## Training Pipeline
MNIST Dataset<br>
↓<br>
Image Normalization<br>
↓<br>
Neural Network Training <br>
↓<br>
Weight Extraction<br>
↓<br>
Hardware Conversion

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
