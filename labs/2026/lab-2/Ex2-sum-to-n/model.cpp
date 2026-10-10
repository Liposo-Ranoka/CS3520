#include <iostream>
using namespace std;

int main(){
	int num1 = 5;
	int sum = 0;
	
	for(int i = 1; i<=num1; i++){
		sum += i;
	}
	cout <<"the sum of the first "<<num1<<" integers is "<< sum<<endl;
	return 0;
}
