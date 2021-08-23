# AES-GCM
## Project description:
This AES-GCM can run with 128/256bit key length
- source:
  * Working source code
  * Using source from this folder in working project
- source_v1:       
  * Archive source version 1
  * In this version, the AES-GCM and AES can both be used.
  * The GF multiplication (2^128) is a big combinational circuit.
  * The in/out interface requires FIFOs to input data and receive output data.
- source_v1_mod:
  * Archive modified source version 1
  * In this version, only AES-GCM is supported.
  * The interface is more friendly to used from software as the output control signals are kept until new input is available from software.
- source_v2:
  * Archive source version 2
  * In this version, only AES-GCM is supported.
  * The GF multiplication (2^128) takes 128 clock cycles to compute (area optimized).
  * The interface is also friendly to used from software.
- source_v2_optim: 
  * Archive optimized source version 2
  * The source code is optimized from source version 2 for synthesizing at ASIC level.
