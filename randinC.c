# include <stdint.h>
# include <stdio.h>
uint32_t lsfr(uint32_t num)
{
	
    uint32_t start = num;  
    uint32_t lfsr = start;
                
    unsigned p = 0;

    do{
           unsigned least = lfsr & 1;  
        lfsr >>= 1;                
        lfsr ^= (-least) & 0xB4000000;  
		//if(lfsr < 1000000000)
			//lfsr = lfsr + 1000000000;
		
	}while(lfsr < 1000000000);	

    return lfsr;
}