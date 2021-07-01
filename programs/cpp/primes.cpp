#include <iostream>
#include <cstdio>
#include <cmath>
#include <assert.h>
#include <stdlib.h>
#include <unordered_map>
#include <chrono>
#include <string>
using namespace std::chrono;
using namespace std;

typedef unordered_map<long, long long> umap;

void generate_key_array(long long key_array[], long long n, long half_size){
  // generation of a key array which serves for the dictionary all_sums
  long long value;

  for(long index = 0; index <= half_size+1; index++){
    value = (long long) n / (index + 1);
    key_array[index] = value;
  }

  for(long index = half_size + 1; index < 2 * half_size + 1; index++){
    value = key_array[index - 1] - 1;
    key_array[index] = value;
  }
}

void generate_all_sums(umap& all_sums, long long key_array[], long size){
  // generation of dictionary all_sums
  long long value;

  for(long index = 0; index < size; index++){
    value = key_array[index];
    // storing sum of numbers for 1 to key
    all_sums[value] = ((long long) (value*(value + 1))/2) - 1;
  }
}


void calculate_new_sums(umap& all_sums, long long key_array[], long long square_root){
  // core of the program for calculate the sum of prime numbers
  long long current_sum;
  long long p_square;
  long index;
  long long key;
  long long second_key;

  for(long p = 2; p <= square_root; p++){
    current_sum = all_sums[p - 1];
    if(all_sums[p] > current_sum){ //if p is prime
      p_square = p * p;
      index = 0;
      key = key_array[index];

      // while the key is lower than p * p
      while(key >= p_square){
        second_key = key / p;
        // updating the sum of the key 'key'
        all_sums[key] -= p * (all_sums[second_key] - current_sum);
        index++;
        key = key_array[index];
      }
    }
  }
}

long long P10(long long n){
  long long square_root = (long long) sqrt(n);
  //check if the program will work
  assert ((square_root*square_root <= n) && ((square_root + 1) * (square_root + 1) > n));

  long long final_sum;
  long half_size = square_root - 1;

  long long* key_array = new long long [half_size * 2 + 1];
  generate_key_array(key_array, n, half_size);

  long size = 2 * half_size + 1;
  // dictionary of sums
  umap all_sums;
  generate_all_sums(all_sums, key_array, size);
  calculate_new_sums(all_sums, key_array, square_root);

  final_sum = all_sums[n];
  delete key_array;
  all_sums.clear();

  return final_sum;
}

string format(int dist, string value){
  string hole = "";
  for(int _=0; _<=(dist-(int)(value).size()); _++){
    hole+=" ";
  }
  return value + hole;
}


int main(){
  // Goal: 100 000 000 000
  // Awaited result: 201 467 077 743 744 681 014
  auto start = high_resolution_clock::now();
  long long value;
  cout << "Power | Time (µs) | Result" << endl;
  cout << "========================================" << endl;
  for(int i=1; i<=8; i++){
    // cout << "Power: " << i << endl;
    value = P10(pow(10,i));
    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<microseconds>(stop - start);
    // cout << value << endl;
    // cout << "Time taken by function: " << duration.count() << " x 10e(-3) seconds" << endl;
    cout << format(4, std::to_string(i)) << " | " << format(8, to_string(duration.count())) << " | " << value << endl;
  }
  return 0;
}
