CARILLON PLAYER FOR GBDK
------------------------

This was ported thanks to nitro2k01 (http://gbdev.gg8.se/forums/).

To use it:
1- Download Carillon Editor.
2- Create a music with Carillon Editor and save music.
3- build!

A modified bin2s will convert the carillon sav to asm code 
If the sav file is called "music.b3.sav":
		music will fill bank 3	
		samples will fill bank 4	
Still no way to remove the samples if the song is not using them.


FROM CARILLON EDITOD DOC
------------------------
Multiple Songs in One Music Bank

In the current version the starting positions for songs are fixed:

 Song 0 - Starting at $00
 
 Song 1 - Starting at $80
 
 Song 2 - Starting at $40
 
 Song 3 - Starting at $c0
 
 Song 4 - Starting at $20
 
 Song 5 - Starting at $60
 
 Song 6 - Starting at $a0
 
 Song 7 - Starting at $e0
 

