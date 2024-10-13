#include<stdio.h>

void compute(int*a,int*b,int c,int d){
    for(int i=0;i<10;i++){
            b[i]=a[i]*d+c;
        }
}

void printArray(int *array,int length){
    for(int i=0;i<length;i++){
            printf("%d ",array[i]);
        }
}

int main(){
    int a[10]={1,2,3,4,5,6,7,8,9,0};
    int b[10]={0};
    int c=5,d=3;
    compute(a,b,c,d);
    printArray(b,10);
    return 0;
}