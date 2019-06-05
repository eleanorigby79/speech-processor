 
 // local includes
#include <dsp.h>

// arm cmsis library includes
#define ARM_MATH_CM4
#define MAX_BUF_SIZE 64000
#include "stm32f4xx.h"
#include <arm_math.h>

// arm c library includes
#include <stdbool.h>

/* Length of the overall data in the test */ 
#define TESTLENGTH 320


/* Total number of blocks to run */
#define NUMBLOCKS (TESTLENGTH/BLOCKSIZE)

/* Number of 2nd order Biquad stages per filter */
#define NUMSTAGES 2

#define SNR_THRESHOLD_F32  98

#define NUM_FIR_TAPS 56
#define BLOCKSIZE    1024
int del;
extern float32_t testInput_f32[TESTLENGTH]; 
static float32_t testOutput[TESTLENGTH]; 

extern float32_t testRefOutput_f32[TESTLENGTH];
/* ----------------------------------------------------------------------  
** Q31 state buffers for Band1, Band2, Band3, Band4, Band5  
** ------------------------------------------------------------------- */  
   
static q31_t biquadStateBand1Q31[4 * 2];   
static q31_t biquadStateBand2Q31[4 * 2];   
static q31_t biquadStateBand3Q31[4 * 2];   
static q31_t biquadStateBand4Q31[4 * 2];   
static q31_t biquadStateBand5Q31[4 * 2];   
static q31_t biquadStateBand6Q31[4 * 2];   
static q31_t biquadStateBand7Q31[4 * 2];   
static q31_t biquadStateBand8Q31[4 * 2];   
static q31_t biquadStateBand9Q31[4 * 2];   
static q31_t biquadStateBand10Q31[4 * 2];
static q31_t biquadStateBand11Q31[4 * 2];   
static q31_t biquadStateBand12Q31[4 * 2];   
static q31_t biquadStateBand13Q31[4 * 2];   
static q31_t biquadStateBand14Q31[4 * 2];   
static q31_t biquadStateBand15Q31[4 * 2];
static q31_t biquadStateBand16Q31[4 * 2];   
static q31_t biquadStateBand17Q31[4 * 2];   
static q31_t biquadStateBand18Q31[4 * 2];   
static q31_t biquadStateBand19Q31[4 * 2];  
static q31_t biquadStateBand20Q31[4 * 2];  
static q31_t biquadStateBand21Q31[4 * 2];  
 
/* ----------------------------------------------------------------------  
** Q31 input and output buffers  
** ------------------------------------------------------------------- */  

q15_t inputQ31[BLOCKSIZE];   
q31_t outputQ31[BLOCKSIZE*21];
// the user button switch
extern volatile int user_mode;
int old_user_mode;
int length = 0;
int dp = 0;
int16_t coeffs[7*19];
float32_t snr;
// definicija filtarskih koeficjenata
arm_fir_instance_q15 FIR;
q15_t outSignal[BLOCKSIZE];
int16_t buf[BLOCKSIZE];
q31_t coeffs_iir[604] = {0,0,0,0,-64013,31267,32767,0,65534,32767,-64883,32137,32767,0,-65534,32767,-65534,32767,32767,0,-65534,32767,-65534,32767,0,0,0,0,-65299,32560,32767,0,65534,32767,-65321,32578,32767,0,-65534,32767,-65410,32676,32767,0,-65534,32767,-65439,32694,0,0,0,0,-65228,32507,32767,0,65534,32767,-65257,32529,32767,0,-65534,32767,-65368,32653,32767,0,-65534,32767,-65408,32675,0,0,0,0,-65134,32440,32767,0,65534,32767,-65174,32467,32767,0,-65534,32767,-65308,32623,32767,0,-65534,32767,-65364,32651,0,0,0,0,-65008,32355,32767,0,65534,32767,-65061,32390,32767,0,-65534,32767,-65222,32586,32767,0,-65534,32767,-65302,32620,0,0,0,0,-64839,32253,32767,0,65534,32767,-64911,32296,32767,0,-65534,32767,-65102,32541,32767,0,-65534,32767,-65216,32584,0,0,0,0,-64597,32116,32767,0,65534,32767,-64698,32171,32767,0,-65534,32767,-64921,32480,32767,0,-65534,32767,-65089,32535,0,0,0,0,-64268,31953,32767,0,65534,32767,-64409,32021,32767,0,-65534,32767,-64659,32408,32767,0,-65534,32767,-64905,32476,0,0,0,0,-63806,31752,32767,0,65534,32767,-64005,31836,32767,0,-65534,32767,-64272,32318,32767,0,-65534,32767,-64636,32403,0,0,0,0,-63131,31487,32767,0,65534,32767,-63418,31592,32767,0,-65534,32767,-63682,32200,32767,0,-65534,32767,-64233,32307,0,0,0,0,-62136,31142,32767,0,65534,32767,-62557,31276,32767,0,-65534,32767,-62774,32045,32767,0,-65534,32767,-63619,32181,0,0,0,0,-60738,30760,32767,0,65534,32767,-61344,30922,32767,0,-65534,32767,-61431,31873,32767,0,-65534,32767,-62697,32038,0,0,0,0,-58658,30258,32767,0,65534,32767,-59548,30455,32767,0,-65534,32767,-59370,31646,32767,0,-65534,32767,-61297,31850,0,0,0,0,-55602,29643,32767,0,65534,32767,-56908,29880,32767,0,-65534,32767,-56237,31367,32767,0,-65534,32767,-59166,31614,1,0,1,1,-51099,28883,32767,0,65534,32767,-53015,29163,32767,0,-65534,32767,-51486,31020,32767,0,-65534,32767,-55920,31315,1,0,2,1,-44577,27995,32767,0,65534,32767,-47340,28307,32767,0,-65534,32767,-44429,30615,32767,0,-65534,32767,-51014,30949,3,0,6,3,-35095,26845,32767,0,65534,32767,-39072,27179,32767,0,-65534,32767,-33942,30090,32767,0,-65534,32767,-43690,30455,7,0,14,7,-21875,25555,32767,0,65534,32767,-27361,25851,32767,0,-65534,32767,-19091,29515,32767,0,-65534,32767,-32885,29844,16,0,31,16,-4324,24080,32767,0,-65534,32767,-11513,24214,32767,0,65534,32767,786,28891,32767,0,-65534,32767,-17655,29043,37,0,-73,37,8415,22022,32767,0,-65534,32767,17213,22370,32767,0,65534,32767,2446,27866,32767,0,65534,32767,25115,28267,1088,0,-2177,1088,15278,2956,32767,0,-65534,32767,20699,15958,32767,0,65534,32767,65343,32577,32767,0,65534,32767,65455,32689,};

q15_t fir_state[NUM_FIR_TAPS + BLOCKSIZE];
bool firstStart = false;
																				 

// DSP funkcija

void filter(int16_t* in, int Ns) { 
  q31_t  *input, *output;  
  arm_biquad_casd_df1_inst_q31 S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20,S21;

  int i;
  int32_t status;
	 
  input = (int32_t*) &in[0];	  
	 
  /* Initialize the state and coefficient buffers for all Biquad sections */

  arm_biquad_cascade_df1_init_q31(&S1, NUMSTAGES, 
				    (q31_t *) &coeffs_iir[7*0],
				    &biquadStateBand1Q31[0], 2);

    arm_biquad_cascade_df1_init_q31(&S2, NUMSTAGES, 
				    (q31_t *) &coeffs_iir[7*1],
				    &biquadStateBand2Q31[0], 2);
	 
    arm_biquad_cascade_df1_init_q31(&S3, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*2],
				  &biquadStateBand3Q31[0], 2);

    arm_biquad_cascade_df1_init_q31(&S4, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*3],
				  &biquadStateBand4Q31[0], 2); 
	 
    arm_biquad_cascade_df1_init_q31(&S5, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*4],
				  &biquadStateBand5Q31[0], 2); 
					
	  arm_biquad_cascade_df1_init_q31(&S6, NUMSTAGES, 
				    (q31_t *) &coeffs_iir[7*5],
				    &biquadStateBand6Q31[0], 2);

    arm_biquad_cascade_df1_init_q31(&S7, NUMSTAGES, 
				    (q31_t *) &coeffs_iir[7*6],
				    &biquadStateBand7Q31[0], 2);
	 
    arm_biquad_cascade_df1_init_q31(&S8, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*7],
				  &biquadStateBand8Q31[0], 2);

    arm_biquad_cascade_df1_init_q31(&S9, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*8],
				  &biquadStateBand9Q31[0], 2); 
	 
    arm_biquad_cascade_df1_init_q31(&S10, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*9],
				  &biquadStateBand10Q31[0], 2); 
					
					  arm_biquad_cascade_df1_init_q31(&S11, NUMSTAGES, 
				    (q31_t *) &coeffs_iir[7*10],
				    &biquadStateBand11Q31[0], 2);

    arm_biquad_cascade_df1_init_q31(&S12, NUMSTAGES, 
				    (q31_t *) &coeffs_iir[7*11],
				    &biquadStateBand12Q31[0], 2);
	 
  arm_biquad_cascade_df1_init_q31(&S13, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*12],
				  &biquadStateBand13Q31[0], 2);

  arm_biquad_cascade_df1_init_q31(&S14, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*13],
				  &biquadStateBand14Q31[0], 2); 
	 
  arm_biquad_cascade_df1_init_q31(&S15, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*14],
				  &biquadStateBand15Q31[0], 2); 
	
	  arm_biquad_cascade_df1_init_q31(&S16, NUMSTAGES, 
				    (q31_t *) &coeffs_iir[7*15],
				    &biquadStateBand16Q31[0], 2);
	 
  arm_biquad_cascade_df1_init_q31(&S17, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*16],
				  &biquadStateBand17Q31[0], 2);

  arm_biquad_cascade_df1_init_q31(&S18, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*17],
				  &biquadStateBand18Q31[0], 2); 
	 
  arm_biquad_cascade_df1_init_q31(&S19, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*18],
				  &biquadStateBand19Q31[0], 2); 
					
					arm_biquad_cascade_df1_init_q31(&S20, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*19],
				  &biquadStateBand19Q31[0], 2); 
					
					arm_biquad_cascade_df1_init_q31(&S21, NUMSTAGES, 
				  (q31_t *) &coeffs_iir[7*20],
				  &biquadStateBand19Q31[0], 2); 
	 
// 
//  /* Call the process functions and needs to change filter coefficients  
//     for varying the gain of each band */ 
// 
//  for(i=0; i < NUMBLOCKS; i++) 
//    {	 

//      /* ---------------------------------------------------------------------- 
//      ** Convert block of input data from float to Q31 
//      ** ------------------------------------------------------------------- */ 

//      arm_float_to_q31(inputF32 + (i*BLOCKSIZE), inputQ31, BLOCKSIZE);	   
//	  	 
//      /* ----------------------------------------------------------------------
//      ** Scale down by 1/8.  This provides additional headroom so that the
//      ** graphic EQ can apply gain.
//      ** ------------------------------------------------------------------- */

//      arm_scale_q31(inputQ31, 0x7FFFFFFF, -3, inputQ31, BLOCKSIZE);

//    

//      /* ---------------------------------------------------------------------- 
//      ** Call the Q31 Biquad Cascade DF1 process function for band3, band4, band5
//      ** ------------------------------------------------------------------- */	

			arm_biquad_cascade_df1_fast_q31(&S1,input, &outputQ31[0], BLOCKSIZE); 
      arm_biquad_cascade_df1_fast_q31(&S2, input, &outputQ31[BLOCKSIZE*1], BLOCKSIZE);
      arm_biquad_cascade_df1_fast_q31(&S3, input, &outputQ31[BLOCKSIZE*2], BLOCKSIZE); 
      arm_biquad_cascade_df1_fast_q31(&S4, input, &outputQ31[BLOCKSIZE*3], BLOCKSIZE);	 
      arm_biquad_cascade_df1_fast_q31(&S5, input, &outputQ31[BLOCKSIZE*4], BLOCKSIZE); 
			arm_biquad_cascade_df1_fast_q31(&S6, input, &outputQ31[BLOCKSIZE*5], BLOCKSIZE); 
      arm_biquad_cascade_df1_fast_q31(&S7, input, &outputQ31[BLOCKSIZE*6], BLOCKSIZE);
      arm_biquad_cascade_df1_fast_q31(&S8, input, &outputQ31[BLOCKSIZE*7], BLOCKSIZE); 
      arm_biquad_cascade_df1_fast_q31(&S9, input, &outputQ31[BLOCKSIZE*8], BLOCKSIZE);	 
      arm_biquad_cascade_df1_fast_q31(&S10, input,&outputQ31[BLOCKSIZE*9], BLOCKSIZE);
			arm_biquad_cascade_df1_fast_q31(&S11, input, &outputQ31[BLOCKSIZE*10], BLOCKSIZE); 
      arm_biquad_cascade_df1_fast_q31(&S12, input, &outputQ31[BLOCKSIZE*11], BLOCKSIZE);
      arm_biquad_cascade_df1_fast_q31(&S13, input, &outputQ31[BLOCKSIZE*12], BLOCKSIZE); 
      arm_biquad_cascade_df1_fast_q31(&S14, input, &outputQ31[BLOCKSIZE*13], BLOCKSIZE);	 
      arm_biquad_cascade_df1_fast_q31(&S15, input, &outputQ31[BLOCKSIZE*14], BLOCKSIZE);
			arm_biquad_cascade_df1_fast_q31(&S16, input, &outputQ31[BLOCKSIZE*15], BLOCKSIZE); 
      arm_biquad_cascade_df1_fast_q31(&S17, input, &outputQ31[BLOCKSIZE*16], BLOCKSIZE);
      arm_biquad_cascade_df1_fast_q31(&S18, input, &outputQ31[BLOCKSIZE*17], BLOCKSIZE);
			arm_biquad_cascade_df1_fast_q31(&S19, input, &outputQ31[BLOCKSIZE*18], BLOCKSIZE); 
			arm_biquad_cascade_df1_fast_q31(&S20, input, &outputQ31[BLOCKSIZE*19], BLOCKSIZE); 
			arm_biquad_cascade_df1_fast_q31(&S21, input, &outputQ31[BLOCKSIZE*20], BLOCKSIZE); 
			
			int32_t out = 0;
			for(int i=0; i<21; i++) {
				out += outputQ31[i*BLOCKSIZE];
			}

		arm_copy_q15((int16_t*)outputQ31, in, Ns);
//      /* ---------------------------------------------------------------------- 
//      ** Convert Q31 result back to float 
//      ** ------------------------------------------------------------------- */ 

//      arm_q31_to_float(outputQ31, outputF32 + (i * BLOCKSIZE), BLOCKSIZE);

//      /* ---------------------------------------------------------------------- 
//      ** Scale back up
//      ** ------------------------------------------------------------------- */ 

//      arm_scale_f32(outputF32 + (i * BLOCKSIZE), 8.0f, outputF32 + (i * BLOCKSIZE), BLOCKSIZE);
//    }; 

//		 
//  /* ---------------------------------------------------------------------- 
//  ** Loop here if the signal does not match the reference output.
//  ** ------------------------------------------------------------------- */ 
//	 


}

void delay(int16_t* in,int16_t * out, int Ns){
//"w"contains the delay samples obtained by FIFO read 
	// After computation, the updated "w" will be transferred to circular buffer // by FIFO write.
	static double g = 0.5;
	static double fb = 0.7;


		for(int i = 0; i < Ns; i++) { 
			out[i+ci]=in[i]; //spremaj signal u circ buffer	
				if(del > 0)
						del--;
				
		} 
		ci = (ci + Ns)%32000;	

		
		
	
	if(del == 0) {
		for(int i = 0; i < Ns; i++) {
			buf[i] = out[cd+i];
				
		}
		cd = (cd + Ns)%32000;
		memcpy(in, buf, Ns*sizeof(int16_t));
	}
				//*in = *buf;
}

// inicijalizacija 
void initFilter()
{
//  // apply the low pass filter
//  if (user_mode & 1)
//    arm_fir_init_q15(&FIR, NUM_FIR_TAPS, fir_coeffs_lp, fir_state, BLOCKSIZE);
//  // or applay the high pass filter depending on the user button switch mode
//  if (user_mode & 2)
//    arm_fir_init_q15(&FIR, NUM_FIR_TAPS, fir_coeffs_hp, fir_state, BLOCKSIZE);
}

