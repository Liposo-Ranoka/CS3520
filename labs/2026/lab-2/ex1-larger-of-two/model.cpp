#include <iostream>
using namespace std;

int main(){
	int num1 = 23;
	int num2 = 13;
	
	if(num1==num2){
		cout << "equal";
	}
	else if(num1 < num2){
		cout << num2 << " is larger"<<endl;
	}
	else{
		cout << num1 << " is larger"<<endl;
	}
	return 0;
}
