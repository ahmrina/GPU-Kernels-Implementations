#include <iostream>
#include <math.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

using namespace std;

//kernel that adds two matrices together
__global__ void addMatrices(int* A, int* B, int* C, int n) {

	int row = blockIdx.y * blockDim.y + threadIdx.y;
	int col = blockIdx.x * blockDim.x + threadIdx.x;

	if (row < n && col < n) {
		 
		C[row * n + col] = A[row * n + col] + B[row * n + col];
	}

}

// method that fills in matrices A & B with values before performing addition in the kernel
void init_matrices(int* A, int* B, int n) {

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			A[i * n + j] = rand() % 20;
			B[i * n + j] = rand() % 10;
		}
	}
}

//printing out the resulting (C) matrix
void print_results(int* A, int* B, int* C, int n) {

	for (int row = 0; row < n; row++) {
		for (int col = 0; col < n; col++) {

			/*
			cout << A[row * n + col] << " " << endl;
			cout << B[row * n + col] << " " << endl;*/
			cout << C[row * n + col] << " ";
		}
		cout << ""<<endl;
	}

}

int main() {

	int n = 10;
	int block_dim = 16;
	size_t bytes = n * n * sizeof(int);
	int* A, * B, * C;


	cudaMallocManaged(&A, bytes);
	cudaMallocManaged(&B, bytes);
	cudaMallocManaged(&C, bytes);

	init_matrices(A, B, n);
    
	dim3 block_size(block_dim, block_dim);

	dim3 grid_size((n + block_dim - 1) / block_dim, (n + block_dim - 1) / block_dim);

	addMatrices<<<grid_size, block_size>>>(A, B, C, n);
	cudaDeviceSynchronize();

	cudaError_t err = cudaGetLastError();

	if (err != cudaSuccess) {
		printf("CUDA error encountered: %s\n", cudaGetErrorString(err));
		return -1;
	}

	print_results(A, B, C, n);

	cudaFree(A);
	cudaFree(B);
	cudaFree(C);

 return 0;
}



