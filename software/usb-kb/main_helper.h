
#ifndef MAIN_HELPER_H_
#define MAIN_HELPER_H_

//#define COLUMNS 80
//#define ROWS 30
//#define NUMCOLORREGS 8

#include <system.h>
#include <alt_types.h>

struct TEXT_VGA_STRUCT {
	alt_u32 PLAYER;
	alt_u32 ENEMIES [12];
	alt_u32 BULLETS [38];
	alt_u32 reserved [5];
	alt_u32 SCOREBOARD;
	alt_u32 LIFE_SPELLS;
	alt_u32 DIRECTION;
	alt_u32 VSYNC;
};

static volatile struct TEXT_VGA_STRUCT* sprite_ctrl = VGA_TEXT_MODE_CONTROLLER_0_BASE;

int playerVsBullet(int playerDat, int bulletDat) {
   int player_xpos = (playerDat >> 9) & 0x3FF;
   int player_ypos = playerDat & 0x1FF;

   int bulletCenterX = ((bulletDat >> 9) & 0x3FF) + 16;
   int bulletCenterY = (bulletDat & 0x1FF) + 24;

   if (bulletCenterX >= player_xpos && bulletCenterX <= (player_xpos + 32)
           && bulletCenterY >= player_ypos && bulletCenterY <= (player_ypos + 48))
       return 1;
   else return 0;
}

int enemyVsLaser(int enemyDat, int playerDat) {
   int enemy_xpos = (enemyDat >> 9) & 0x3FF;
   int enemy_ypos = enemyDat & 0x1FF;

   int player_xpos = (playerDat >> 9) & 0x3FF;
   int player_ypos = playerDat & 0x1FF;

   int playerXCenter = player_xpos + 16;

   if (enemy_ypos < player_ypos // enemy is above player
           && playerXCenter >= enemy_xpos && playerXCenter <= (enemy_xpos + 32))
       return 1;
   else return 0;
}

int bulletRangefinder(int playerDat, int bulletDat) {
	/*int playerCenterX = ((playerDat >> 9) & 0x3FF) + 16;
	int playerCenterY = (playerDat & 0x1FF) + 24;

	int bulletCenterX = ((bulletDat >> 9) & 0x3FF) + 16;
	int bulletCenterY = (bulletDat & 0x1FF) + 24;

	int yDiff = playerCenterY - bulletCenterY;
	int xDiff = playerCenterX - bulletCenterX;

	float slope = playerCenterY / playerCenterX;
	if (slope < 0.5f) {
		int yDiff = 4;
		int xDiff = 2;
	}
	else if (slope < 1f) {
		int yDiff = 4;
		int xDiff = 4;
	}
	else if (slope < 2.0f) {
		int yDiff = 4;
		int xDiff = 2;
	}
	else if (slope < 2.0f) {
		int yDiff = 4;
		int xDiff = 2;
	}*/

	int xDiff = 0;
	int yDiff = 4;

	return (xDiff << 9) + yDiff;
}

#endif /* MAIN_HELPER_H_ */
