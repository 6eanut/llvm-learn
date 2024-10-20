#include<stdio.h>

#define LENGTH 10

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
    int a[LENGTH]={1,2,3,4,5,6,7,8,9,0};
    int b[LENGTH]={0};
    int c=5,d=3;
    compute(a,b,c,d);
    goto foo;
    printArray(b,LENGTH);

foo:
    printf("hello foo\n");

    return 0;
}