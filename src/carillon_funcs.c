/*---------------------------------------------------------------------------------
CARILLON PLAYER FOR GBDK
; 
; (c)2000-2001 Aleksi Eeben (email: aleksi@cncd.fi)
; Ported to GBDK by nitro2k01 (http://gbdev.gg8.se/forums/)
;---------------------------------------------------------------------------
*/
#include <gb/gb.h>

//Carillon Player Functions
UINT8 CP_MusBank = 0;
UINT8 CP_SamBank = 0;
UINT8 CP_ON = 0;
void CP_Init(); 
void CP_LoadSong(); 
void CP_SelectSong(UINT8 song); 
void CP_UpdateSong();  
void CP_UpdateSamp(); 
void CP_StopSong(); 
void CP_Mute_Chan(UINT8 chan);
void CP_Reset_Chan(UINT8 chan);


//bank = rom bank where the song is stored
//sbank = rom bank where the samples are stored (0 = no sample)
//song = song number
void CP_LoadMusic(UINT8 bank,UINT8 sbank,int song){
	CP_MusBank = bank;
	CP_SamBank = sbank;
	SWITCH_ROM_MBC1(bank);
	CP_Init();
	CP_LoadSong();
	CP_SelectSong(song); 
	CP_ON = 1;
}
void CP_UpdateMusic(){
	if (CP_ON == 1){
		SWITCH_ROM_MBC1(CP_MusBank);
		CP_UpdateSong();
		if (CP_SamBank !=0){
			SWITCH_ROM_MBC1(CP_SamBank);
			CP_UpdateSamp();
		}
	}
}

void CP_StopMusic(){
	if (CP_ON == 1){
		SWITCH_ROM_MBC1(CP_MusBank);
		CP_MusBank = 0;
		CP_SamBank = 0;
		CP_ON = 0;
		CP_StopSong();
		*(UBYTE*)0xFF26 = 0;
	}
}