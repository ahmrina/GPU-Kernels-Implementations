#include <iostream>
#include <math.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

using namespace std;

__global__ void multiplication(int *A, int *b, int *c, int n) {

	int row = blockIdx.x * blockDim.x + threadIdx.x;
	//	int column = blockIdx.x * blockDim.x + threadIdx.x;

	if (row < n) {

		int sum = 0;
		
		for (int i = 0; i < n; i++) {
			sum += A[row * n + i] * b[i];
		}
		c[row] = sum;
	}

}


// expects a 2D array and a 1D array
void fill_values(int *A, int *b, int n) {

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {

			A[i * n + j] = rand() % 20;
		} 
		b[i] = rand() % 5;
	}
}


void print_results(int *A, int * b, int * c, int n) {

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			cout << A[i * n + j] << " ";
		}
		cout << endl;
	}

	cout << endl;

	for (int i = 0; i < n; i++) {
		cout << b[i] << endl;
	}

	cout << endl;

	for (int i = 0; i < n; i++) {
		cout << c[i]<< endl;
	}


}

int main() {

	int n = 10;
	size_t bytes = n * n * sizeof(int);

	int* A, * b, * c;

	cudaMallocManaged(&A, bytes);
	cudaMallocManaged(&b, bytes);
	cudaMallocManaged(&c, bytes);


	fill_values(A, b, n);

	int block_size = 256;
	int grid_size = ceil((float)n/ block_size);

	multiplication <<<grid_size, block_size>>> (A, b, c, n);

	cudaDeviceSynchronize();

	cudaError_t e = cudaGetLastError();

	if (e != cudaSuccess) {
		cout << "kernel failed: " << cudaGetErrorString(e) << endl;
		return -1;
	}

	print_results(A, b, c, n);

	
	cudaFree(A);
	cudaFree(b);
	cudaFree(c);
	
	return 0;
}