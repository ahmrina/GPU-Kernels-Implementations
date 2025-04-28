# GPU-Kernels-Implementations
---

The tasks for completing these challenges along with resources used are from repo: https://github.com/a-hamdi/GPU
This document is used to note tasks completed along with what was larned during that process.

# Day 1

## Filename: `vectorAddition.cu`

#### Summarization of Day 1

- Got familiarized with using `cudaGetDevice()`, `cudaMallocManaged()`, `cudaDeviceSynchronize()` and learned when to use them. `vectorAddition.cu` adds two vectors and prints out the results.
---

# Day 2

## Filename: `matrixAddition.cu`

#### Summarization of Day 2
- Learned how to utilize `cudaError_t` and working and using dim3 for setting size for `block_size` and `grid_size`.
- Resources used: CUDA by Example by Jason Sanders & Edward Kandrot. 

---

# Day 3

## Filename: `matrix_vector_mult`
#### Summarization of Day 3
- Focused on reading Chapter 4 of PMPP book.
- Learned how to calculate the dot product through multiple threads. 
