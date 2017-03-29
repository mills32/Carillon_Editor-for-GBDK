
#include <gb/gb.h>
#include <gb/drawing.h>

//Carillon functions

//bank = rom bank where the song is stored
//sbank = rom bank where the samples are stored (0 = no sample)
//song = song number
void CP_LoadMusic(UINT8 bank,UINT8 sbank,int song);
void CP_UpdateMusic();
void CP_StopMusic();

//Colors for GBC
UWORD colours[]={32733,31440,32256,25920};

void main() {

	if (_cpu == 0x11){       //Set palettes only if GBC
		set_bkg_palette(0, 1, colours);
	}
    DISPLAY_ON;
	SHOW_BKG;
	
	//Carillon functions  
	CP_LoadMusic(2,0);
	//Draw Text
	gotogxy(0,1);
	gprint("  CARILLON  PLAYER  ");
	gotogxy(0,2);
	gprint("      FOR GBDK      ");	
	gotogxy(0,4);
	gprint("PRESS A TO LOAD     ");	
	gotogxy(0,5);
	gprint(" Song 0 from Bank 2 ");	
	gotogxy(0,7);
	gprint("PRESS B TO LOAD     ");	
	gotogxy(0,8);
	gprint(" Song 1 from Bank 2 ");	
	gotogxy(0,10);
	gprint("PRESS START TO LOAD ");	
	gotogxy(0,11);
	gprint(" Song 0 from Bank 4 ");	
	gotogxy(0,12);
	gprint(" Samples from Bank 5");
	gotogxy(0,14);
	gprint("PRESS SELECT TO STOP");	
	gotogxy(0,16);
	gprint("see readme  for help");	
	
	//Main Loop
    while (1) {	
	
		//Your program here
		if (joypad() & J_A) CP_LoadMusic(2,0,0);
		if (joypad() & J_B) CP_LoadMusic(2,0,1);
		if (joypad() & J_START) CP_LoadMusic(4,5,0);  
		if (joypad() & J_SELECT) CP_StopMusic();
		
		CP_UpdateMusic();
		
		//Wait screen
		wait_vbl_done();
		SCX_REG++;
	}	
}
