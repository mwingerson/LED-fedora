//LED Fedora demo

#include <PICxel.h>

#define led_num 210
#define g_val 30
#define num_patterns 5

PICxel strip(251, 3, HSV);

typedef struct hsv_data{
	uint16_t hue;
	uint8_t sat;
	uint8_t val;
}HSV_DATA;
	
HSV_DATA running_sun[5] = {
	{  0, 255,   0},	//black
	{  0,   0, g_val},	//white
	{255, 255, g_val},	//yellow
	{100, 255, g_val},	//orange
	{  0, 255, g_val}	//red
};

HSV_DATA running_digi[15] = {
	{510, 255, 180},	//green
	{510, 255,  50},	//whi
	{510, 255,  45},	//yellow
	{510, 255,  40},	//orange
	{510, 255,  35},	//light-green
	{510, 255,  30},	//white
	{510, 255,  25},	//white
	{510, 255,  20},	//white
	{510, 255,  15},	//white
	{510, 255,  10},	//white
	{510, 255,   5},	//white
	{510, 255,   5},	//white
	{510, 255,   0},	//white
	{510, 255,   0},	//white
	{510, 255,   0},	//white
};

int color_index = 0;
short rot_index = 0;
short case_ID = 4;
char initialized = 0;
char prev_btn_st = 0;
int fader = 0;
char count_up;

void setup(){
	strip.begin();	
	pinMode(42, INPUT);
}

void loop(){
	if(!digitalRead(41)&& !prev_btn_st){
		prev_btn_st = 1;
		initialized = 0;
		if(case_ID < num_patterns-1)
			case_ID++;
		else
			case_ID = 0;
	}
	
	else if(!digitalRead(41) && prev_btn_st){
		strip.clear();
		strip.refreshLEDs();
	}
	
	else{
		prev_btn_st = 0;
		if(case_ID == 0)
			running_sun_pattern();
		else if(case_ID == 1)
			running_digilent();
		else if(case_ID == 2)
			sparkle_muffin();
		else if(case_ID == 3)
			rando_twinkle();
		else if(case_ID == 4)
			merica();
	}
}

void merica(void){
	
	if(count_up){
		if(fader < 80)
			fader += 1;
		else{
			fader = 80;
			count_up = 0;
		}
	}
	
	else{
		if(fader > 20)
			fader -= 1;
		else{
			fader = 20;
			count_up = 1;
		}
	}
	
	for(int i=0; i<led_num; i++){
		if(i<74)
			strip.HSVsetLEDColor(i, 1020, 255, fader);
		else if(i<143)
			strip.HSVsetLEDColor(i, 0, 0, fader);
		else
			strip.HSVsetLEDColor(i, 1, 255, fader);
	}
	
	delay(20);
	strip.refreshLEDs();
}

void rando_twinkle(void){
	HSV_DATA* arrayPtr;
	
	if(!initialized){
		strip.clear();
		strip.refreshLEDs();
		initialized = 1;
	}
	
	arrayPtr = (HSV_DATA*)strip.getColorArray();
	
	for(int i=0; i<led_num; i++){
		
		//led is on
		if(arrayPtr[i].val > 0){
			if(arrayPtr[i].val < 3)
				arrayPtr[i].val = 0;
			else
				arrayPtr[i].val -= 3;
		}

		//led is off
		else if(random(300) == 0){
			arrayPtr[i].hue = (uint16_t)random(1535);
			arrayPtr[i].sat = 255;
			arrayPtr[i].val = 100;
		}
	}
	
	strip.refreshLEDs();
	delay(10);
}

void sparkle_muffin(void){
	HSV_DATA* arrayPtr;

	strip.clear();
	strip.refreshLEDs();
	
	arrayPtr = (HSV_DATA*)strip.getColorArray();
	
	for(int i=0; i<led_num; i++){
		//led is on
		if(arrayPtr[i].sat > 0){
			arrayPtr[i].sat -= 1;
		}

		//led is off
		else if(random(5) == 0){
			arrayPtr[i].hue = (uint16_t)random(1535);
			arrayPtr[i].sat = 255;
			arrayPtr[i].val = 50;
		}
	}
	
	strip.refreshLEDs();
}

void running_digilent(void){
	for(int i=0; i<led_num; i++){
		if(color_index == 15)
			color_index = 0;
		
		strip.HSVsetLEDColor(i, 
			running_digi[(color_index+rot_index)%15].hue, 
			running_digi[(color_index+rot_index)%15].sat, 
			running_digi[(color_index+rot_index)%15].val
		);
		
		color_index++;
		
	}
			
	if(rot_index == 15)
		rot_index = 0;
	
	rot_index++;
	delay(50);
	strip.refreshLEDs();
}

void running_sun_pattern(void){
	for(int i=0; i<led_num; i++){
		if(color_index == 5)
			color_index = 0;
		
		strip.HSVsetLEDColor(i, 
			running_sun[(color_index+rot_index)%5].hue, 
			running_sun[(color_index+rot_index)%5].sat, 
			running_sun[(color_index+rot_index)%5].val
		);
		
		color_index++;
		
	}
			
	if(rot_index == 5)
		rot_index = 0;
	
	rot_index++;
	delay(200);
	strip.refreshLEDs();
}

