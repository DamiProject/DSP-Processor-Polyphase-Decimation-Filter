# DSP-Processor-Polyphase-Decimation-Filter

**Status: Under Active Development**

## Overview

This repository houses the codebase for a modular, object-oriented digital signal processing (DSP) decimation filter in MATLAB. Designed to organize and contain the underlying implementation rather than serve as a demonstration or activity suite, it includes both a floating-point **"Golden Reference"** polyphase decimation filter and its fixed-point counterpart. It explores two main areas:

**1. Digital Signal Processing (DSP) Paradigms:** Multi-rate signal processing, polyphase filter banks, decimation filtering, anti-aliasing, Noble identities, Kaiser window & FIR design, floating-point arithmetic and representation, fixed-point arithmetic and representation (quantization & word length), frame-based processing, Multiply-Accumulate (MAC) hardware modelling.

**2. Software Engineering Paradigms:** Object-oriented programming (OOP), unit testing, integration testing, code reusability, and modularity.

### Prerequisites & Dependencies

This block requires MATLAB and the standard toolboxes used for digital signal processing and filter design:

* **MATLAB** (Recommended: R2023a or newer)
  
* **Signal Processing Toolbox** 

---

## Module Implementations

### 1. Floating-Point "Golden Reference" Filter

This module implements the ideal, double-precision polyphase decimation filter. It serves as the algorithmic baseline to validate the filter's frequency response, multi-rate commutation, and alias suppression before introducing hardware quantization constraints.

#### Key Implementation Features

**- Kaiser Window FIR Design & Bessel Approximation:** The prototype low-pass filter is mathematically derived using a Kaiser window. To compute the window coefficients precisely, the zero-order modified Bessel function of the first kind ($I_0$) is approximated using a power series expansion. This allows for rigorous, manual tuning of the shape factor ($\beta$) to ensure strict stopband attenuation without relying on black-box functions.

**- Type I FIR Design:** The prototype low-pass filter is mathematically derived as a Type I (odd-length, symmetric) FIR filter using the aforementioned Kaiser window. This symmetry guarantees strictly linear phase and an integer group delay, preventing phase distortion during downsampling.

**- Polyphase Decomposition & Noble Identities:** Rather than brute-force filtering at the high input sample rate and immediately discarding samples, the architecture applies the Noble Identities. The prototype filter is decomposed into $M$ parallel sub-filters, proving that all arithmetic operations can theoretically run at the lower, decimated clock rate ($F_s/M$).

**- Commutator-Based Routing:** A software-level input commutator is modeled to distribute the incoming signal stream into the parallel polyphase branches. This explicitly verifies the time-division multiplexing logic that the downstream hardware will eventually rely on.

**- Floating-Point MAC Processing:** The core filtering operation evaluates a continuous stream of floating-point Multiply-Accumulate (MAC) operations. This establishes the ideal sum-of-products arithmetic baseline, ensuring the underlying convolution logic is flawlessly verified before introducing quantization and bit-width constraints.


### 2. Fixed-Point MAC Architecture

Building on the floating-point baseline, this module simulates the physical realities of an FPGA or ASIC DSP slice. It applies finite word-length constraints and explicit Multiply-Accumulate (MAC) modeling to bridge the gap between theoretical algorithms and actual silicon implementation.

#### Key Implementation Features

**- Algorithmic Word Length Optimization:** Rather than arbitrarily assigning bit-widths, the design features an automated search algorithm to find the absolute minimum word length required to satisfy the target stopband attenuation. This ensures the hardware footprint is optimized without wasting logic resources.

**- Dynamic Scaling & Fractional Bit Allocation:** To complement the word-length search, the system mathematically determines the optimal integer and fractional bit boundaries for both coefficients and signal data. This maximizes precision and dynamic range while strictly preventing overflow.

**- Hardware-Equivalent MAC Processing:** High-level filtering functions are replaced with a discrete, explicit sequence of quantized multiplications and additions. This sum-of-products engine directly mirrors the behavior of physical hardware multipliers and DSP blocks.

**- Accumulator Bit-Growth Management:** To prevent numerical overflow during convolution, the architecture models the necessary bit-width expansion within the MAC accumulator register, ensuring the datapath can safely process the maximum possible sum without catastrophic wrap-around or clipping.

**- Quantization Degradation Analysis:** By running the fixed-point logic side-by-side with the "golden reference," this stage directly evaluates the resulting quantization noise floor and SNR degradation, proving the optimized bit-widths still satisfy the system's strict frequency response requirements.

---

## Author

**Damilola Ibukun Awotunde**

MEng, Communications & Signal Processing - Western University | [LinkedIn](https://www.linkedin.com/in/damilola-awotunde) 
