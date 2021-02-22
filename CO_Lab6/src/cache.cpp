#include <iostream>
#include <cmath>
#include <utility> 
#include <vector>

using namespace std;

struct Block{
  bool v;
	unsigned int reference;
	unsigned int tag;
};

void stimulate(int cache_size, int block_size, int associativity){
  int block_num = (cache_size / block_size);
	int index_num = (block_num / associativity);
    
  Block *cache = new Block[block_num];
    
  for(int i = 0; i < block_num; i++){
    cache[i].v = false;
		cache[i].reference = 0;
  }
    
  int offset_bit = (int) log2(block_size);
  int index_bit = (int) log2(index_num);
	
	vector<int> hits;
	vector<int> misses;
    
	FILE *f = fopen("Trace1.txt", "r");
	int instr = 0;
	unsigned int address, index, tag;
	
    while(fscanf(f,"%x",&address) != EOF){
		instr++;
        index = (address >> offset_bit) & (index_num - 1);
        tag = address >> (offset_bit + index_bit);
		
		//cout << dec << instr << " " <<  hex << "tag: " << tag << " index: " << index << endl;
		
		bool hit = false;
		pair<int,int> LRU(0,cache[index * associativity].reference);
		for(int i = 0; i < associativity; i++){
			if(LRU.second > cache[index * associativity + i].reference){
				LRU = make_pair(i,cache[index * associativity + i].reference);
			}
			if(cache[index * associativity + i].v && cache[index * associativity + i].tag == tag){
				cache[index * associativity + i].reference++;
				hit = true;
				hits.push_back(instr);
				break;
			}
		}
		
		if(!hit){
			cache[index * associativity + LRU.first].v = true;
			cache[index * associativity + LRU.first].tag = tag;
			cache[index * associativity + LRU.first].reference = 1;
			misses.push_back(instr);
		}
  }
    
	
	cout << "Hit instructions: ";
	for(int i = 0; i < hits.size(); i++){
		cout << hits[i];
		if(i != hits.size() - 1){
			 cout << ", ";
		}
	}
	cout << endl;
	cout << "Miss instructions: ";
	for(int i = 0; i < misses.size(); i++){
		cout << misses[i];
		if(i != misses.size() - 1){
			 cout << ", ";
		}
	}
	cout << endl;
	
	
	float missRate = (misses.size() / (float)instr) * 100;
	cout << "Miss Rate: " << missRate << '%' << endl;
	delete [] cache;
}

int main()
{
	cout << "Please input cache_size(byte), block_size(byte), and associativity seperated by space." << endl;
	int cache_size, block_size, associativity;
	while(cin >> cache_size >> block_size >> associativity){
		stimulate(cache_size, block_size, associativity);
	}

    return 0;
}
