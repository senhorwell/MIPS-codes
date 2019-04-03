#include<stdio.h>

int main(){
	int n,i=0;
	int soma=0;

	scanf("%d",&n);
	int vetor[n];

	while(i<n){
		scanf("%d",vetor[i]);
		i++;
	}
	
	i=0;

	while(i<n){
		soma+=vetor[i];
		i++;
	}
	return 0;
}