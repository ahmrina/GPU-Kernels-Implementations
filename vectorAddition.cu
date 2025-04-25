#include <iostream>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <math.h>

using namespace std;

__global__ void vectorAdd(int* a, int* b, int* c, int n) {

	int tid = (blockIdx.x * blockDim.x) + threadIdx.x;
	if (tid < n) {
		c[tid] = a[tid] + b[tid];
	}

}
void print_results(int* a, int* b, int* c, int n) {

	for (int i = 0; i < n; i++) {
		cout << "a " << a[i] <<" + " << " b " << b[i] << " = " << c[i] << " = c" << endl;
	}
}

int main() {
	int id = cudaGetDevice(&id);
	int n = 10;
	size_t bytes = n * sizeof(int);
	int* a, * b, * c;

	cudaMallocManaged(&a, bytes);
	cudaMallocManaged(&b, bytes);
	cudaMallocManaged(&c, bytes);

	//fill vectors with values before addition
	for (int i = 0; i < n; i++) {
		a[i] = rand() % 10;
		b[i] = rand() % 10;
	}

	int block_size = 256;
	int grid_size = ceil((float) n / block_size);

	vectorAdd <<<grid_size, block_size>>> (a, b, c, n);
	cudaDeviceSynchronize();

	print_results(a, b, c, n);
	return 0;
}