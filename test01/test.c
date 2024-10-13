#include <stdio.h>

// Function declarations
double calculateAverage(int arr[], int n);
int findMinimum(int arr[], int n);
int findMaximum(int arr[], int n);
void swap(int *a, int *b);
void sortArray(int arr[], int n);
void printArray(int arr[], int size);

// Main function
int main() {
    int numbers[] = {34, 12, 89, 5, 67, 3, 18};
    int n = sizeof(numbers) / sizeof(numbers[0]);

    printf("Original array:\n");
    printArray(numbers, n);

    // Sort the array
    sortArray(numbers, n);

    printf("\nSorted array:\n");
    printArray(numbers, n);

    // Calculate average
    double avg = calculateAverage(numbers, n);
    printf("\nAverage = %.2f\n", avg);

    // Find minimum value
    int min = findMinimum(numbers, n);
    printf("Minimum value = %d\n", min);

    // Find maximum value
    int max = findMaximum(numbers, n);
    printf("Maximum value = %d\n", max);

    return 0;
}

// Calculate average of an array
double calculateAverage(int arr[], int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += arr[i];
    }
    return (double)sum / n;
}

// Find minimum value in an array
int findMinimum(int arr[], int n) {
    int min = arr[0];
    for (int i = 1; i < n; i++) {
        if (arr[i] < min)
            min = arr[i];
    }
    return min;
}

// Find maximum value in an array
int findMaximum(int arr[], int n) {
    int max = arr[0];
    for (int i = 1; i < n; i++) {
        if (arr[i] > max)
            max = arr[i];
    }
    return max;
}

// Swap two integers
void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

// Sort an array using bubble sort algorithm
void sortArray(int arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1])
                swap(&arr[j], &arr[j + 1]);
        }
    }
}

// Print elements of an array
void printArray(int arr[], int size) {
    for (int i = 0; i < size; i++)
        printf("%d ", arr[i]);
    printf("\n");
}