#include<stdio.h>

int main(){
	int x,y,i,j,primo;

	scanf("%d",&x);
	scanf("%d",&y);
	i=x;
	while(i<=y){
		j=1;
		primo=0;
		while(j<i){
			if(i%j==0){
				primo++;
			}
			j++;
		}
		if(primo==2){
			printf("primo\n");
		}
		i++;
	}

	return 0;
}