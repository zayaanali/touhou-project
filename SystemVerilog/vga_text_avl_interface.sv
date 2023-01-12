
`define NUM_SPRITEREGS 60 // Number of sprites we can have on screen

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ, AVL_WRITE,		// Avalon-MM Read/Write
	input  logic AVL_CS,							// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [11:0] AVL_ADDR,				// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

	

	/*-- some variables --*/ 
	logic [9:0] DrawX, DrawY;
	logic [11:0] regIndex;
	logic pixel_clk, blank;

	/*-- VGA Controller Module Instantiation --*/
	vga_controller ctrl(.Clk(CLK), .Reset(RESET), .hs(hs), .pixel_clk(pixel_clk), .blank(blank), .vs(vs), .DrawX(DrawX), .DrawY(DrawY));



	/*-- Allow sprite list registers to be edited from software (using AVL signals) --*/
	// Final register is a control register to hold direction of character, etc.
	// Lowest 2 bits contain the character's direction: 00 = center, 10 = left, 01 = right
	logic [19:0] SPRITE_REGS    [`NUM_SPRITEREGS]; // Registers
	
	
//	always_ff @(posedge pixel_clk) begin
//		SPRITE_REGS[10] <= 1;
//	end
	
	always_ff @(posedge CLK) begin
		
		playerX <= SPRITE_REGS[0][18:9];
		playerY <= SPRITE_REGS[0][8:0];
		
		SPRITE_REGS[59] <= {20{vs}};
		
		// READ FROM REGISTERS
		if (AVL_READ & AVL_CS) begin
			AVL_READDATA[19:0] <= SPRITE_REGS[AVL_ADDR]; // Access the AVL_ADDR register and send it out
		end
		else if (AVL_WRITE & AVL_CS) begin // WRITE TO REGISTERS
			SPRITE_REGS[AVL_ADDR] <= AVL_WRITEDATA[19:0];
		end 
	end

	/*-- Get the color palette code that we want to use--*/
	logic [3:0] palette_out;	
	
	/*-- color data for each sprite. Need to process to choose which to use --*/
   logic [3:0] playerColor, digit1Color, digit2Color, digit3Color, digit4Color;
	logic [3:0] wEye1Color, wEye2Color, wEye3Color, wEye4Color;
	logic [3:0] fairy1Color, fairy2Color, fairy3Color, fairy4Color;
	logic [3:0] ghost1Color, ghost2Color, ghost3Color, ghost4Color; 
	
	logic [3:0] bullet1Color, bullet2Color, bullet3Color, bullet4Color, bullet5Color, bullet6Color, bullet7Color, bullet8Color;
	logic [3:0] bullet9Color, bullet10Color, bullet11Color, bullet12Color, bullet13Color, bullet14Color, bullet15Color, bullet16Color;
	logic [3:0] bullet18Color, bullet19Color, bullet20Color, bullet21Color, bullet22Color, bullet23Color, bullet24Color, bullet25Color;
	logic [3:0] bullet26Color, bullet27Color, bullet28Color, bullet29Color, bullet30Color, bullet31Color, bullet32Color, bullet33Color;
	logic [3:0] bullet34Color, bullet35Color, bullet36Color, bullet37Color, bullet38Color;
	
	logic [3:0] lifeColor, spellColor;
	
	player_mapper		player (.sprite_info(SPRITE_REGS[0]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .direction(SPRITE_REGS[58][1:0]), .palette_out(playerColor));
	
	winged_eye_mapper	eye1 (.sprite_info(SPRITE_REGS[1]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(wEye1Color));
	winged_eye_mapper	eye2 (.sprite_info(SPRITE_REGS[2]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(wEye2Color));
	winged_eye_mapper	eye3 (.sprite_info(SPRITE_REGS[3]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(wEye3Color));
	winged_eye_mapper	eye4 (.sprite_info(SPRITE_REGS[4]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(wEye4Color));
	
	enemy_fairy_mapper fairy1 (.sprite_info(SPRITE_REGS[5]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(fairy1Color));
	enemy_fairy_mapper fairy2 (.sprite_info(SPRITE_REGS[6]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(fairy2Color));
	enemy_fairy_mapper fairy3 (.sprite_info(SPRITE_REGS[7]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(fairy3Color));
	enemy_fairy_mapper fairy4 (.sprite_info(SPRITE_REGS[8]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(fairy4Color));
	
	enemy_ghost_mapper	ghost1 (.sprite_info(SPRITE_REGS[9]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(ghost1Color));
	enemy_ghost_mapper	ghost2 (.sprite_info(SPRITE_REGS[10]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(ghost2Color));
	enemy_ghost_mapper	ghost3 (.sprite_info(SPRITE_REGS[11]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(ghost3Color));
	enemy_ghost_mapper	ghost4 (.sprite_info(SPRITE_REGS[12]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(ghost4Color));
	
	bullet_mapper	bullet1 (.sprite_info(SPRITE_REGS[13]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet1Color));
	bullet_mapper	bullet2 (.sprite_info(SPRITE_REGS[14]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet2Color));
	bullet_mapper	bullet3 (.sprite_info(SPRITE_REGS[15]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet3Color));
	bullet_mapper	bullet4 (.sprite_info(SPRITE_REGS[16]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet4Color));
	bullet_mapper	bullet5 (.sprite_info(SPRITE_REGS[17]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet5Color));
	bullet_mapper	bullet6 (.sprite_info(SPRITE_REGS[18]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet6Color));
	bullet_mapper	bullet7 (.sprite_info(SPRITE_REGS[19]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet7Color));
	bullet_mapper	bullet8 (.sprite_info(SPRITE_REGS[20]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet8Color));
	bullet_mapper	bullet9 (.sprite_info(SPRITE_REGS[21]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet9Color));
	bullet_mapper	bullet10 (.sprite_info(SPRITE_REGS[22]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet10Color));
	bullet_mapper	bullet11 (.sprite_info(SPRITE_REGS[23]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet11Color));
	bullet_mapper	bullet12 (.sprite_info(SPRITE_REGS[24]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet12Color));
	bullet_mapper	bullet13 (.sprite_info(SPRITE_REGS[25]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet13Color));
	bullet_mapper	bullet14 (.sprite_info(SPRITE_REGS[26]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet14Color));
	bullet_mapper	bullet15 (.sprite_info(SPRITE_REGS[27]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet15Color));
	bullet_mapper	bullet16 (.sprite_info(SPRITE_REGS[28]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet16Color));
	bullet_mapper	bullet17 (.sprite_info(SPRITE_REGS[29]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet17Color));
	bullet_mapper	bullet18 (.sprite_info(SPRITE_REGS[30]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet18Color));
	bullet_mapper	bullet19 (.sprite_info(SPRITE_REGS[31]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet19Color));
	bullet_mapper	bullet20 (.sprite_info(SPRITE_REGS[32]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet20Color));
	bullet_mapper	bullet21 (.sprite_info(SPRITE_REGS[33]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet21Color));
	bullet_mapper	bullet22 (.sprite_info(SPRITE_REGS[34]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet22Color));
	bullet_mapper	bullet23 (.sprite_info(SPRITE_REGS[35]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet23Color));
	bullet_mapper	bullet24 (.sprite_info(SPRITE_REGS[36]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet24Color));
	bullet_mapper	bullet25 (.sprite_info(SPRITE_REGS[37]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet25Color));
	bullet_mapper	bullet26 (.sprite_info(SPRITE_REGS[38]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet26Color));
	bullet_mapper	bullet27 (.sprite_info(SPRITE_REGS[39]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet27Color));
	bullet_mapper	bullet28 (.sprite_info(SPRITE_REGS[40]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet28Color));
	bullet_mapper	bullet29 (.sprite_info(SPRITE_REGS[41]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet29Color));
	bullet_mapper	bullet30 (.sprite_info(SPRITE_REGS[42]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet30Color));
	bullet_mapper	bullet31 (.sprite_info(SPRITE_REGS[43]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet31Color));
	bullet_mapper	bullet32 (.sprite_info(SPRITE_REGS[44]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet32Color));
	bullet_mapper	bullet33 (.sprite_info(SPRITE_REGS[45]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet33Color));
	bullet_mapper	bullet34 (.sprite_info(SPRITE_REGS[46]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet34Color));
	bullet_mapper	bullet35 (.sprite_info(SPRITE_REGS[47]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet35Color));
	bullet_mapper	bullet36 (.sprite_info(SPRITE_REGS[48]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet36Color));
	bullet_mapper	bullet37 (.sprite_info(SPRITE_REGS[49]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet37Color));
	bullet_mapper	bullet38 (.sprite_info(SPRITE_REGS[50]), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .palette_out(bullet38Color));
	
	
	
	// score digits
	digit_mapper	digit1 (.sprite_info(20'hBB096), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .digit(SPRITE_REGS[56][15:12]), .palette_out(digit1Color));
	digit_mapper	digit2 (.sprite_info(20'hBF096), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .digit(SPRITE_REGS[56][11:8]), .palette_out(digit2Color));
	digit_mapper	digit3 (.sprite_info(20'hC3096), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .digit(SPRITE_REGS[56][7:4]), .palette_out(digit3Color));
	digit_mapper	digit4 (.sprite_info(20'hC7096), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .digit(SPRITE_REGS[56][3:0]), .palette_out(digit4Color));
	
	digit_mapper	life (.sprite_info(20'hBB0F0), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .digit(SPRITE_REGS[57][7:4]), .palette_out(lifeColor));
	digit_mapper	spell (.sprite_info(20'hC70F0), .Clk(CLK), .DrawX(DrawX), .DrawY(DrawY), .digit(SPRITE_REGS[57][3:0]), .palette_out(spellColor));
	
	//B48F0, C10F0

	/*-- Process the color data from each sprite, if statements in priority to be set --*/
	logic [3:0] outputColor;
	
	
	
	always_comb begin
		if (playerColor!=0)
			outputColor = playerColor;
		
		else if (wEye1Color!=0)
			outputColor = wEye1Color;
		else if (wEye2Color!=0)
			outputColor = wEye2Color;
		else if (wEye3Color!=0)
			outputColor = wEye3Color;
		else if (wEye4Color!=0)
			outputColor = wEye4Color;
		
		else if (ghost1Color!=0)
			outputColor = ghost1Color;
		else if (ghost2Color!=0)
			outputColor = ghost2Color;
		else if (ghost3Color!=0)
			outputColor = ghost3Color;
		else if (ghost4Color!=0)
			outputColor = ghost4Color;
		
	   else if (fairy1Color!=0)
			outputColor = fairy1Color;
		else if (fairy2Color!=0)
			outputColor = fairy2Color;
		else if (fairy3Color!=0)
			outputColor = fairy3Color;
		else if (fairy4Color!=0)
			outputColor = fairy4Color;
	
			
		else if (bullet1Color!=0)
			outputColor = bullet1Color;
		else if (bullet2Color!=0)
			outputColor = bullet2Color;
		else if (bullet3Color!=0)
			outputColor = bullet3Color;
		else if (bullet4Color!=0)
			outputColor = bullet4Color;
		else if (bullet5Color!=0)
			outputColor = bullet5Color;
		else if (bullet6Color!=0)
			outputColor = bullet6Color;
		else if (bullet7Color!=0)
			outputColor = bullet7Color;
		else if (bullet8Color!=0)
			outputColor = bullet8Color;
		else if (bullet9Color!=0)
			outputColor = bullet9Color;
		else if (bullet10Color!=0)
			outputColor = bullet10Color;
		else if (bullet11Color!=0)
			outputColor = bullet11Color;
		else if (bullet12Color!=0)
			outputColor = bullet12Color;
		else if (bullet13Color!=0)
			outputColor = bullet13Color;
		else if (bullet14Color!=0)
			outputColor = bullet14Color;
		else if (bullet15Color!=0)
			outputColor = bullet15Color;
		else if (bullet16Color!=0)
			outputColor = bullet16Color;
		else if (bullet17Color!=0)
			outputColor = bullet17Color;
		else if (bullet18Color!=0)
			outputColor = bullet18Color;
		else if (bullet19Color!=0)
			outputColor = bullet19Color;
		else if (bullet20Color!=0)
			outputColor = bullet20Color;
		else if (bullet21Color!=0)
			outputColor = bullet21Color;
		else if (bullet22Color!=0)
			outputColor = bullet22Color;
		else if (bullet23Color!=0)
			outputColor = bullet23Color;
		else if (bullet24Color!=0)
			outputColor = bullet24Color;
		else if (bullet25Color!=0)
			outputColor = bullet25Color;
		else if (bullet26Color!=0)
			outputColor = bullet26Color;
		else if (bullet27Color!=0)
			outputColor = bullet27Color;
		else if (bullet28Color!=0)
			outputColor = bullet28Color;
		else if (bullet29Color!=0)
			outputColor = bullet29Color;
		else if (bullet30Color!=0)
			outputColor = bullet30Color;
		else if (bullet31Color!=0)
			outputColor = bullet31Color;
		else if (bullet32Color!=0)
			outputColor = bullet32Color;
		else if (bullet33Color!=0)
			outputColor = bullet33Color;
		else if (bullet34Color!=0)
			outputColor = bullet34Color;
		else if (bullet35Color!=0)
			outputColor = bullet35Color;
		else if (bullet36Color!=0)
			outputColor = bullet36Color;
		else if (bullet37Color!=0)
			outputColor = bullet37Color;
		else if (bullet38Color!=0)
			outputColor = bullet38Color;
		else
			outputColor = 4'b0; // no idea what this does
		
		palette_out = outputColor;
	end

	
	
	
	
	
	// Set the background color here based on the 
	logic [3:0] bgRED, bgBLUE, bgGREEN;
	always_comb begin
		bgRED = 4'h0;
		bgGREEN = 4'h0;
		bgBLUE = 4'h2;
	end
		
		
		logic withinGameBound, sideWalls, vertWalls;
		assign sideWalls =  ( ((DrawX>60&DrawX<65)|(DrawX>400&DrawX<405)) & (DrawY>60&DrawY<425) ); 
		assign vertWalls =  ( ((DrawY>60 & DrawY<65)|(DrawY>420&DrawY<425)) & (DrawX>64&DrawX<401) );
		assign withinGameBound = ( (DrawX>60 & DrawX<400) & (DrawY>60 & DrawY<420) );
		
		
		logic laserEnable, printLaser;
		logic [9:0] playerX;
		logic [8:0] playerY;
		
//		assign playerX = SPRITE_REGS[0][18:9];
//		assign playerY = SPRITE_REGS[0][8:0];
		
		assign laserEnable = SPRITE_REGS[58][2];
		assign printLaser = ( ((DrawX>(playerX+14)) & (DrawX<(playerX+18))) & (DrawY<(playerY+10)) );
		
		logic digitPrint1, digitPrint2, digitPrint3, digitPrint4, lifePrint, spellPrint;
		
		assign digitPrint1 = ((DrawX>471)&(DrawX<504)&(DrawY>149)&(DrawY<198));
		assign digitPrint2 = ((DrawX>503)&(DrawX<536)&(DrawY>149)&(DrawY<198));
		assign digitPrint3 = ((DrawX>535)&(DrawX<568)&(DrawY>149)&(DrawY<198));
		assign digitPrint4 = ((DrawX>567)&(DrawX<600)&(DrawY>149)&(DrawY<198));
		
		assign lifePrint = ((DrawX>471)&(DrawX<504)&(DrawY>239)&(DrawY<288));
		assign spellPrint = ((DrawX>567)&(DrawX<600)&(DrawY>239)&(DrawY<288));
		
		
		/*-- Set RGB values --*/ 
		always_ff @(posedge pixel_clk) begin
        
		  if (~blank) begin // if in the blanking period set to 0
				red <= 4'b0;
				blue <= 4'b0;
				green <= 4'b0;
			end
			else if (sideWalls)
				begin red<=4'hf; green<=4'hf; blue<=4'hf; end
			else if (vertWalls)
				begin red<=4'hf; green<=4'hf; blue<=4'hf; end
			else if (~withinGameBound) begin 
				
				if (digitPrint1) begin
					if (digit1Color!=0)
						begin red<=4'hf; green<=4'h3; blue<=4'h2; end
					else
						begin red<=4'h0; green<=4'h0; blue<=4'h0; end
				
				end else if (digitPrint2) begin
					if (digit2Color!=0)
						begin red<=4'hf; green<=4'h3; blue<=4'h2; end
					else
						begin red<=4'h0; green<=4'h0; blue<=4'h0; end
				
				end else if (digitPrint3) begin
					if (digit3Color!=0)
						begin red<=4'hf; green<=4'h3; blue<=4'h2; end
					else
						begin red<=4'h0; green<=4'h0; blue<=4'h0; end
				
				end else if (digitPrint4) begin
					if (digit4Color!=0)
						begin red<=4'hf; green<=4'h3; blue<=4'h2; end
					else
						begin red<=4'h0; green<=4'h0; blue<=4'h0; end
				
				end 
				else if (lifePrint) begin
					if (lifeColor!=0)
						begin red<=4'hf; green<=4'h3; blue<=4'h2; end
					else
						begin red<=4'h0; green<=4'h0; blue<=4'h0; end
						//red<=4'h0; green<=4'hF; blue<=4'h0;
				
				end else if (spellPrint) begin
					if (spellColor!=0)
						begin red<=4'hf; green<=4'h3; blue<=4'h2; end
					else
						begin red<=4'h0; green<=4'h0; blue<=4'h0; end
						//red<=4'h0; green<=4'hF; blue<=4'h0;
				
				end
				
				
				else begin
					red<=4'h0; green<=4'h0; blue<=4'h0;
				end
			end
		
		else begin
		  unique case (palette_out) 
		  4'h1: 
            begin red<=4'h0; green<=4'h0; blue<=4'h0; end
        4'h2: 
            begin red<=4'hf; green<=4'he; blue<=4'hc; end
        4'h3: 
            begin red<=4'hf; green<=4'he; blue<=4'he; end
        4'h4: 
            begin red<=4'h8; green<=4'h0; blue<=4'h0; end
        4'h5: 
            begin red<=4'hf; green<=4'h4; blue<=4'h4; end
        4'h6: 
            begin red<=4'he; green<=4'hB; blue<=4'hA; end
        4'h7: 
            begin red<=4'ha; green<=4'hA; blue<=4'h4; end
        4'h8: 
            begin red<=4'hf; green<=4'hf; blue<=4'h5; end
        4'h9: 
            begin red<=4'h0; green<=4'h6; blue<=4'h0; end
        4'hA: 
            begin red<=4'h0; green<=4'h0; blue<=4'hd; end
        4'hB: 
            begin red<=4'h9; green<=4'h9; blue<=4'hf; end
        4'hC: 
            begin red<=4'h8; green<=4'h0; blue<=4'h8; end
        4'hD: 
            begin red<=4'hd; green<=4'h6; blue<=4'hd; end
		  4'hE:
				begin red<=4'hf; green<=4'h3; blue<=4'h2; end
			default: 
				begin 
					if (printLaser && laserEnable)
						begin red<=4'h5; green<=4'hd; blue<=4'he; end
					else 
						begin red<=bgRED; green<=bgGREEN; blue<=bgBLUE; end
				end
        endcase
    end
	end
endmodule



