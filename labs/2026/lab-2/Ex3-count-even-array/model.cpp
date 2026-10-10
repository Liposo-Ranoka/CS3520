#include <iostream>
using namespace std;

int main(){
	int nums[8] = {12,3,6,13,45,23,7,9};
	int count = 0;
	
	for (int i = 0; i < 8 ; i++){
		if(nums[i]%2 == 0){
			count += 1;
		}
	}
	cout <<"Even count = " << count <<endl;
	return 0;
}
