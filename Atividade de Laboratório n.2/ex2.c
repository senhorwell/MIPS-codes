#include<stdio.h>

int main(){
	int n,i=1;
	int soma=0; 
	int resultado;

	scanf("%d",&n);

	while(i<n){

		if(n%i==0){
			soma+=i;
		}
		i++;
	}
	if(soma==n){
		resultado=1;
	}
	return 0;
}