#include<stdio.h>

int main(){
	int n,i=1,soma=1;

	scanf("%d",&n);

	while(i<=n){
		soma=soma*i;
		i++;
	}
	printf("Resultado: %d\n",soma);
	return 0;
}