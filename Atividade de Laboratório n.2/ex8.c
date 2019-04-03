#include<stdio.h>

int main(){
	int n,i=1,soma=1;

	scanf("%d",&n);

	while(i*(i+1)*(i+2)<=n){
		if(i*(i+1)*(i+2)==n){
			soma=1;
		}
		i++;
	}
	printf("Resultado: %d\n",soma);
	return 0;
}