//ECE 385 USB Host Shield code
//based on Circuits-at-home USB Host code 1.x
//to be used for ECE 385 course materials
//Revised October 2020 - Zuofu Cheng

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "system.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_spi_regs.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"
#include "usb_kb/GenericMacros.h"
#include "usb_kb/GenericTypeDefs.h"
#include "usb_kb/HID.h"
#include "usb_kb/MAX3421E.h"
#include "usb_kb/transfer.h"
#include "usb_kb/usb_ch9.h"
#include "usb_kb/USB.h"
#include "main_helper.h"

extern HID_DEVICE hid_device;

static BYTE addr = 1; 				//hard-wired USB address
const char* const devclasses[] = { " Uninitialized", " HID Keyboard", " HID Mouse", " Mass storage" };

BYTE GetDriverandReport() {
	BYTE i;
	BYTE rcode;
	BYTE device = 0xFF;
	BYTE tmpbyte;

	DEV_RECORD* tpl_ptr;
	printf("Reached USB_STATE_RUNNING (0x40)\n");
	for (i = 1; i < USB_NUMDEVICES; i++) {
		tpl_ptr = GetDevtable(i);
		if (tpl_ptr->epinfo != NULL) {
			printf("Device: %d", i);
			printf("%s \n", devclasses[tpl_ptr->devclass]);
			device = tpl_ptr->devclass;
		}
	}
	//Query rate and protocol
	rcode = XferGetIdle(addr, 0, hid_device.interface, 0, &tmpbyte);
	if (rcode) {   //error handling
		printf("GetIdle Error. Error code: ");
		printf("%x \n", rcode);
	} else {
		printf("Update rate: ");
		printf("%x \n", tmpbyte);
	}
	printf("Protocol: ");
	rcode = XferGetProto(addr, 0, hid_device.interface, &tmpbyte);
	if (rcode) {   //error handling
		printf("GetProto Error. Error code ");
		printf("%x \n", rcode);
	} else {
		printf("%d \n", tmpbyte);
	}
	return device;
}

void setLED(int LED) {
	IOWR_ALTERA_AVALON_PIO_DATA(LEDS_PIO_BASE,
			(IORD_ALTERA_AVALON_PIO_DATA(LEDS_PIO_BASE) | (0x001 << LED)));
}

void clearLED(int LED) {
	IOWR_ALTERA_AVALON_PIO_DATA(LEDS_PIO_BASE,
			(IORD_ALTERA_AVALON_PIO_DATA(LEDS_PIO_BASE) & ~(0x001 << LED)));

}

void setKeycode(WORD keycode)
{
	IOWR_ALTERA_AVALON_PIO_DATA(KEYCODE_BASE, keycode);
}

int main() {
	BYTE rcode;
	BOOT_MOUSE_REPORT buf;		//USB mouse report
	BOOT_KBD_REPORT kbdbuf;

	BYTE runningdebugflag = 0;//flag to dump out a bunch of information when we first get to USB_STATE_RUNNING
	BYTE errorflag = 0; //flag once we get an error device so we don't keep dumping out state info
	BYTE device;
	WORD keycode;

	// seed rng
	time_t t;
	srand((unsigned) time(&t));

	// Default setting for character pos
	sprite_ctrl->PLAYER = (1 << 19) + (214 << 9) + 320;

	// clear everything from last game
	for (int i = 0; i < 12; i++) {
		sprite_ctrl->ENEMIES[i] = (sprite_ctrl->ENEMIES[i] & (~(1 << 19)));
	}
	for (int i = 0; i < 38; i++) {
		sprite_ctrl->BULLETS[i] = (sprite_ctrl->BULLETS[i] & (~(1 << 19)));
	}

	// score, lives and spellcards
	int score = 0;
	int lives = 2;
	int spellcards = 3;

	int XHeldDown = 0;

	printf("initializing MAX3421E...\n");
	MAX3421E_init();
	printf("initializing USB...\n");
	USB_init();
	while (1) {
		if (sprite_ctrl->VSYNC != 0) continue;

		int playerXVelocity = 0;
		int playerYVelocity = 0;
		int playerShooting = 0;
		int playerSpellcarding = 0;

		int currentlyHoldingX = 0;

		int movementSpeed = 4;
		int shiftPressed = (kbdbuf.mod >> 1) & 1;
		if (shiftPressed) movementSpeed = movementSpeed >> 1;

		for (int i = 0; i < 6; i++) {
			BYTE kc = kbdbuf.keycode[i];
			// left = 0x50, right = 0x4f, up = 0x52, down = 0x51
			if (kc == 0x50)
				playerXVelocity -= movementSpeed;
			else if (kc == 0x4f)
				playerXVelocity += movementSpeed;
			else if (kc == 0x52)
				playerYVelocity -= movementSpeed;
			else if (kc == 0x51)
				playerYVelocity += movementSpeed;

			else if (kc == 0x1d)
				playerShooting = 1;

			else if (kc == 0x1b) {
				currentlyHoldingX = 1;
				if (XHeldDown == 0) playerSpellcarding = 1;
				XHeldDown = 1;
			}
		}

		int canBomb = 0;
		// Latch the spellcard key
		if (currentlyHoldingX == 0) XHeldDown = 0;
		if (playerSpellcarding && spellcards > 0) {
			spellcards--;
			canBomb = 1;
		}

		// Set sprite direction
		int dirReg = 0;
		if (playerXVelocity < 0) dirReg = 0x2;
		else if (playerXVelocity > 0) dirReg = 0x1;
		else dirReg = 0x0;
		// Set laser visualization on or off
		dirReg += (playerShooting << 2);

		sprite_ctrl->DIRECTION = dirReg;

		int playerdat = sprite_ctrl->PLAYER;
		// Move character by x and y
		int xpos = (playerdat >> 9) & 0x3FF;
		int ypos = playerdat & 0x1FF;
		xpos += playerXVelocity;
		ypos += playerYVelocity;
		// Bounds check
		if (xpos < 50) xpos -= playerXVelocity;
		if (ypos < 36) ypos -= playerYVelocity;
		if (xpos > 384) xpos -= playerXVelocity;
		if (ypos > 396) ypos -= playerYVelocity;

		sprite_ctrl->PLAYER = (1 << 19) + (xpos << 9) + ypos;
		playerdat = (1 << 19) + (xpos << 9) + ypos;


		// Update all enemy positions
		for (int i = 0; i < 12; i++) {
			int val = sprite_ctrl->ENEMIES[i];

			// If sprite is disabled, skip over it
			if ((val & (1 << 19)) == 0) continue;

			// Update position and save
			val += 2;

			// disable sprite if offscreen or shot
			if ((val & 0x1FF) > 420) {
				val = (val & (~(1 << 19)));
			}

			int gotShot = (playerShooting && enemyVsLaser(val, playerdat) == 1);
			if (gotShot) {
				val = (val & (~(1 << 19)));
				score++; // increment score
			}

			sprite_ctrl->ENEMIES[i] = val;
		}

		// Maybe spawn a random enemy in a random location
		int shouldSpawn = rand() % 45;

		if (shouldSpawn < 2) {
			int randIdx = 0;
			int timeout = 5; // Implement a timeout to stop infinite loops
			while ((sprite_ctrl->ENEMIES[randIdx] & (1 << 19)) != 0) {
				randIdx = rand() % 12;
				timeout--;
				if (timeout == 0) break;
			}

			// spawn an enemy at randIdx
			int randXCoord = (rand() % 300) + 75;
			sprite_ctrl->ENEMIES[randIdx] = (1 << 19) + (randXCoord << 9) + 70;
		}

		// Generate bullets randomly aimed at player
		int bullet_velocities[38];

		for (int i = 0; i < 12; i++) {
			int eval = sprite_ctrl->ENEMIES[i];

			// If sprite is disabled, skip over it
			if ((eval & (1 << 19)) == 0) continue;

			// Found a valid sprite to make shoot a bullet
			int toShootRand = (rand() % 80);

			// If this sprite is going to shoot...
			if (toShootRand == 0) {
				// ...find first empty bullet slot...
				int b;
				for (b = 0; b < 38; b++) {
					int bval = sprite_ctrl->BULLETS[b];

					// If sprite is disabled, we found one
					if ((bval & (1 << 19)) == 0) break;
				}
				// ...and spawn a bullet from the center of the enemy aimed roughly at the player
				int newBulletPos = eval + (16 << 9) + 24;
				sprite_ctrl->BULLETS[b] = newBulletPos;
				// Also update corresponding bullet velocity
				bullet_velocities[b] = bulletRangefinder(sprite_ctrl->PLAYER, newBulletPos);
			}
		}

		int wasHit = 0;

		// Update bullet positions with velocities
		for (int b = 0; b < 38; b++) {
			int bval = sprite_ctrl->BULLETS[b];

			// If bullet is disabled, skip over it
			if ((bval & (1 << 19)) == 0) continue;

			bval += bullet_velocities[b];

			// disable bullets that go offscreen
			if ((bval & 0x1FF) > 420) {
				bval = (bval & (~(1 << 19)));
			}

			sprite_ctrl->BULLETS[b] = bval;

			// Check if was hit (bullet enabled and player made contact)
			if (((bval & (1 << 19)) != 0) && playerVsBullet(sprite_ctrl->PLAYER, bval) == 1)
				wasHit = 1;
		}

		// Penalty for getting hit
		if (wasHit) {
			if (lives == 0) exit(0); // Game over condition
			// Lose a life and replenish spellcards
			lives--;
			spellcards = 3;
			// Clear the screen and reset the character
			canBomb = 1;
			sprite_ctrl->PLAYER = (1 << 19) + (214 << 9) + 320;
		}


		// Clear all enemies and bullets if canBomb
		if (canBomb) {
			for (int i = 0; i < 12; i++) {
				sprite_ctrl->ENEMIES[i] = (sprite_ctrl->ENEMIES[i] & (~(1 << 19)));
			}
			for (int i = 0; i < 38; i++) {
				sprite_ctrl->BULLETS[i] = (sprite_ctrl->BULLETS[i] & (~(1 << 19)));
			}
		}


		// Update score register
		int score_new, digit1, digit2, digit3, digit4;
		score_new = score;
		digit4 = score_new % 10;
		score_new /= 10;
		digit3 = score_new % 10;
		score_new /= 10;
		digit2 = score_new % 10;
		score_new /= 10;
		digit1 = score_new;
		sprite_ctrl->SCOREBOARD = (digit1 << 12) + (digit2 << 8) + (digit3 << 4) + digit4;

		// Update life and spellcard registers
		sprite_ctrl->LIFE_SPELLS = (lives << 4) + spellcards;



		MAX3421E_Task();
		USB_Task();
		//usleep (500000);
		if (GetUsbTaskState() == USB_STATE_RUNNING) {
			if (!runningdebugflag) {
				runningdebugflag = 1;
				setLED(9);
				device = GetDriverandReport();
			} else if (device == 1) {
				//run keyboard debug polling
				rcode = kbdPoll(&kbdbuf);
				if (rcode == hrNAK) {
					continue; //NAK means no new data
				} else if (rcode) {
					printf("Rcode: ");
					printf("%x \n", rcode);
					continue;
				}

				printf("keycodes: ");
				for (int i = 0; i < 6; i++) {
					printf("%x ", kbdbuf.keycode[i]);
				}
				//setKeycode(kbdbuf.keycode[0]);
				printf("\n");
			}
			else if (device == 2) {
				rcode = mousePoll(&buf);
				if (rcode == hrNAK) {
					//NAK means no new data
					continue;
				} else if (rcode) {
					printf("Rcode: ");
					printf("%x \n", rcode);
					continue;
				}
				printf("X displacement: ");
				printf("%d ", (signed char) buf.Xdispl);
				printf("Y displacement: ");
				printf("%d ", (signed char) buf.Ydispl);
				printf("Buttons: ");
				printf("%x\n", buf.button);
				if (buf.button & 0x04)
					setLED(2);
				else
					clearLED(2);
				if (buf.button & 0x02)
					setLED(1);
				else
					clearLED(1);
				if (buf.button & 0x01)
					setLED(0);
				else
					clearLED(0);
			}
		} else if (GetUsbTaskState() == USB_STATE_ERROR) {
			if (!errorflag) {
				errorflag = 1;
				clearLED(9);
				printf("USB Error State\n");
				//print out string descriptor here
			}
		} else //not in USB running state
		{

			printf("USB task state: ");
			printf("%x\n", GetUsbTaskState());
			if (runningdebugflag) {	//previously running, reset USB hardware just to clear out any funky state, HS/FS etc
				runningdebugflag = 0;
				MAX3421E_init();
				USB_init();
			}
			errorflag = 0;
			clearLED(9);
		}
	}
	return 0;
}
