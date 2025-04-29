#include <iostream>
#include <math.h>
#include <stdio.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

using namespace std;

__global__ void prefix_sum(int* A, int n, int* output_arr) {
	 
	int tidx = threadIdx.x;
	extern __shared__ int shared_mem[];

	if (tidx < n) {

	shared_mem[tidx] = A[tidx];

	/*
	else {
		shared_mem[tidx] = 0;
	}*/
		//__syncthreads();


		// round = 1,...,log2(n)
		 // step = 2^(round - 1)
		for (int step = 1; step < blockDim.x; step *= 2) {
			int x = 0;

			if (tidx >= step) {
				x = shared_mem[tidx - step];
			}
			__syncthreads();

			if (tidx >= step) {
				shared_mem[tidx] += x;
			}
			__syncthreads();
		}

	}

		// copy elements back to original array
		if (tidx < n) {
			output_arr[tidx] = shared_mem[tidx];
		}
	
}

void init_arr(int* A, int n) {

	for (int i = 0; i < n; i++) {
		A[i] = rand() % 10;
	}
}

void print(int* arr, int n) {

	for (int i = 0; i < n; i++) {

		cout << arr[i] << " ";
	} cout << "" << endl;
	
}

int main() {

	int n = 10;
	size_t bytes = n * sizeof(int);

	int* A;
	int* output_arr;

	cudaMallocManaged(&A, bytes);
	cudaMallocManaged(&output_arr, bytes);

	int block_size = 256;
	//int grid_size = ceil((float) n / block_size);
	int shared_mem_size = block_size * sizeof(int);

	init_arr(A, n);

	prefix_sum <<<1, block_size, shared_mem_size>>> (A, n, output_arr);
	cudaDeviceSynchronize();

	cudaError_t e = cudaGetLastError();

	if (e != cudaSuccess) {

		cout << "kernel failed: " << cudaGetErrorString(e) << endl;
	}

	print(A, n);
	print(output_arr, n);

	cudaFree(A);

	return 0;
}
