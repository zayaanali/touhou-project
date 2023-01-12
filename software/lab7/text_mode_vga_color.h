
#ifndef TEXT_MODE_VGA_COLOR_H_
#define TEXT_MODE_VGA_COLOR_H_

//#define COLUMNS 80
//#define ROWS 30
//#define NUMCOLORREGS 8

#include <system.h>
#include <alt_types.h>

struct TEXT_VGA_STRUCT {
	alt_u32 SPRITE_DATA [10];
};

static volatile struct TEXT_VGA_STRUCT* vga_ctrl = VGA_TEXT_MODE_CONTROLLER_0_BASE;


#endif /* TEXT_MODE_VGA_COLOR_H_ */
