/*
 * text_mode_vga_color.c
 * Minimal driver for text mode VGA support
 * This is for Week 2, with color support
 *
 *  Created on: Oct 25, 2021
 *      Author: zuofu
 */

#include <system.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <alt_types.h>
#include "text_mode_vga_color.h"


void testFunction() {
	vga_ctrl->SPRITE_DATA[0] = 0x85014;
}


//void textVGAColorClr()
//{
//	for (int i = 0; i<(ROWS*COLUMNS) * 2; i++)
//	{
//		vga_ctrl->VRAM[i] = 0x85014;
//	}
//}
//
//void textVGADrawColorText(char* str, int x, int y, alt_u8 background, alt_u8 foreground)
//{
//	int i = 0;
//	while (str[i]!=0)
//	{
//		vga_ctrl->VRAM[(y*COLUMNS + x + i) * 2] = foreground << 4 | background;
//		vga_ctrl->VRAM[(y*COLUMNS + x + i) * 2 + 1] = str[i];
//		i++;
//	}
//}
//
//void setColorPalette (alt_u8 color, alt_u8 red, alt_u8 green, alt_u8 blue)
//{
//	// Color refers to the index of which color to be filled. (for loop index)
//	//fill in this function to set the color palette starting at offset 0x0000 2000 (from base)
//	alt_u32 toWrite, prevData, colorData;
//	alt_u32 shift_r, shift_g, shift_b;
//	alt_u32 topMask = 0xFFFFE000;
//	alt_u32 bottomMask = 0x00001FFF;
//
//	// shift RGB values according to given color palette address organization
//	shift_r = red<<8;
//	shift_g = green<<4;
//	shift_b = blue;
//
//	// to write 12 bit contains RGB values - 12 bottom bits
//	colorData = shift_r + shift_g + shift_b;
//
//	// if color (index) is even, bottom half to be written. If odd, top half to be written
//	prevData = vga_ctrl->palette[color/2]; // contains old color data (both colors)
//
//	if (color%2==0) { // overwrite bottom
//		toWrite = (prevData & topMask) + (colorData << 1);
//	} else { // overwrite top
//		toWrite = (prevData & bottomMask) + (colorData << 13);
//	}
//	printf("toWrite for color reg %d = %x\n", color, toWrite);
//	vga_ctrl->palette[color/2] = toWrite; // write to palette
//}
/*void setColorPalette (alt_u8 color, alt_u8 red, alt_u8 green, alt_u8 blue)
{
	// Color refers to the index of which color to be filled. (for loop index)
	//fill in this function to set the color palette starting at offset 0x0000 2000 (from base)
	alt_u32 toWrite, tempBottom, prevData, colorData;
	alt_u32 shift_r, shift_g, shift_b;
	alt_u32 bottomMask = 0xFFFFE000;
	alt_u32 topMask = 0x00001FFF; // these names are swapped i think but don't feel like changing it

	// shift RGB values according to given color palette address organization
	shift_r = red<<8;
	shift_g = green<<4;
	shift_b = blue;

	// to write 12 bit contains RGB values - 12 bottom bits
	colorData = shift_r + shift_g + shift_b;

	// if color (index) is even, bottom half to be written. If odd, top half to be written
	prevData = vga_ctrl->palette[color/2]; // contains old color data (both colors)

	if (color%2==0) {// overwrite bottom
		toWrite = (prevData&bottomMask); // clear out the bottom bits
		colorData = colorData << 1;
		toWrite = colorData+toWrite;
	} else { // overwrite top
		toWrite = (prevData&topMask); // clear out the top bits
		colorData = colorData << 13;
		toWrite = toWrite + colorData;
	}
	printf("toWrite for color %d = %x\n", color, toWrite);
	vga_ctrl->palette[color/2] = toWrite; // write to palette
}*/


//void textVGAColorScreenSaver()
//{
//	//This is the function you call for your week 2 demo
//	char color_string[80];
//    int fg, bg, x, y;
//	textVGAColorClr();
//	//initialize palette
//	for (int i = 0; i < 16; i++)
//	{
//		setColorPalette (i, colors[i].red, colors[i].green, colors[i].blue);
//	}
//	while (1)
//	{
//		fg = rand() % 16;
//		bg = rand() % 16;
//		while (fg == bg)
//		{
//			fg = rand() % 16;
//			bg = rand() % 16;
//		}
//		sprintf(color_string, "Drawing %s text with %s background", colors[fg].name, colors[bg].name);
//		x = rand() % (80-strlen(color_string));
//		y = rand() % 30;
//		textVGADrawColorText (color_string, x, y, bg, fg);
//		usleep (100000);
//	}
//}
