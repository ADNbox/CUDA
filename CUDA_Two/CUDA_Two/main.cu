#include <iostream>
#include <cuda.h>

using namespace std;

__global__  void AddInts(int* a, int* b)
{
//This could be any operation that takes more than 2 seconds
//Here I've rather pointlessly asked a single CUDA thread to
//add b to a 10,000,005 times.
for(int i=0;i<10000005;i++)
	a[0] += b[0];

}

int main()
{
int h_a = 0, h_b = 1; //Two integer variables
int *d_a, * d_b;	//GPU versions of the same

//Allocate space for copies of the integers on the GPU
if(cudaMalloc((void**)&d_a, sizeof(int)) != cudaSuccess) //We'll look errors later
{
	cout <<"Error allocating memory!"<<endl;
	return 0;

}
if(cudaMalloc(&d_b, sizeof(int)) != cudaSuccess)
{
	cout<<"Error allocating memory"<<endl;
	free(d_a);
	return 0;

}
//Copy the integer's values from the CPU to the GPU
if(cudaMemcpy(d_a, &h_a, sizeof(int),cudaMemcpyHostToDevice) != cudaSuccess)
{
	cout<<"Error copying memory!"<<endl;
	cudaFree(d_a);
	cudaFree(d_b);
	return 0;
}

AddInts<<<1, 1>>>(d_a, d_b);

if(cudaMemcpy(&h_a, d_a, sizeof(int), cudaMemcpyDeviceToHost) != cudaSuccess)
{
cout<<"Error copying memory!"<<endl;
cudaFree(d_a);
cudaFree(d_b);
return 0;
}

cout<<"Adding 1 to 0 10,000,005 times gives"<<h_a<<endl;

cudaFree(d_a);
cudaFree(d_b);

cudaDeviceReset();

return 0;
}