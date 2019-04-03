#include<stdio.h>

int main(){
	int x,y,i,j,primo=-1,primo2=-1,maior=0,menor=100000;
	int vetor[10];

	i=0;
	while(i<10){
		scanf("%d",vetor[i]);
		i++;
	}

	i=0;
	
	while(i<10){
		j=1;
		primo=0;
		while(j<i){
			if(i%j==0){
				primo++;
			}
			j++;
		}
		if(primo==2){
			if(primo<0){
				primo=i;
			}
			else{
				primo2=i;
			}
		}
		if(i>maior){
			maior=i;
		}
		if(i<menor){
			menor=i;
		}
		i++;
	}

	return 0;
}