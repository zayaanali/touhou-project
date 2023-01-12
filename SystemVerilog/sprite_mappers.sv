module player_mapper (  input [19:0] sprite_info,
                        input Clk,
                        input [9:0] DrawX, DrawY,
								input [1:0] direction, // 00 = center, 10 = left, 01 = right
                        output logic [3:0] palette_out);


    /*-- Mapping from the sprite list to variables--*/
    logic [9:0] XCoord;
    logic [8:0] YCoord;
    logic sprite_en, draw_sprite;
    
	 assign XCoord = sprite_info[18:9];
    assign YCoord = sprite_info[8:0];
    assign sprite_en = sprite_info[19];
    
    
    /*-- Calculate all boundaries, x/y coord is top left --*/
    logic [9:0] leftBound, rightBound, topBound, lowerBound;
    
    assign leftBound = XCoord;
    assign rightBound = XCoord+31;
    assign topBound = YCoord;
    assign lowerBound = YCoord+47;

    /*-- Check if DrawX/DrawY is within boundaries, check if I should draw the sprite --*/
    always_comb begin
        if (DrawX>=leftBound && DrawX<=rightBound && sprite_en
            && DrawY<=lowerBound && DrawY>=topBound) begin
            draw_sprite = 1'b1;
        end else begin
            draw_sprite = 1'b0;
        end
    end

    /*-- Calculate the pixel access index (to access the rom) --*/
    int Xsprite, Ysprite, pixel_access;
    assign Xsprite = DrawX - leftBound;
    assign Ysprite = DrawY - topBound;
    assign pixel_access = (32*Ysprite)+Xsprite;

    logic [3:0] ctr_palette_idx, lft_palette_idx, rgt_palette_idx, palette_idx, data_in;

    playerCenterROM	ctr_player(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(ctr_palette_idx));
	 playerLeftROM 	lft_player(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(lft_palette_idx));
	 playerRightROM	rgt_player(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(rgt_palette_idx));
    
	 // Decide which direction of the player sprite to draw
	 always_comb begin
		unique case (direction)
			2'b10: palette_idx = lft_palette_idx;
			2'b01: palette_idx = rgt_palette_idx;
			default: palette_idx = ctr_palette_idx;
		endcase
	 end
	 
	 assign palette_out = (draw_sprite) ? palette_idx : 4'h0;
endmodule


module winged_eye_mapper (input [19:0] sprite_info,
                          input Clk,
                          input [9:0] DrawX, DrawY,
                          output logic [3:0] palette_out);


    /*-- Mapping from the sprite list to variables--*/
    logic [9:0] XCoord;
    logic [8:0] YCoord;
    logic sprite_en, draw_sprite;
    
	 assign XCoord = sprite_info[18:9];
    assign YCoord = sprite_info[8:0];
    assign sprite_en = sprite_info[19];
    
    
    /*-- Calculate all boundaries, x/y coord is top left --*/
    logic [9:0] leftBound, rightBound, topBound, lowerBound;
    
    assign leftBound = XCoord;
    assign rightBound = XCoord+31;
    assign topBound = YCoord;
    assign lowerBound = YCoord+47;

    /*-- Check if DrawX/DrawY is within boundaries, check if I should draw the sprite --*/
    always_comb begin
        if (DrawX>=leftBound && DrawX<=rightBound && sprite_en
            && DrawY<=lowerBound && DrawY>=topBound) begin
            draw_sprite = 1'b1;
        end else begin
            draw_sprite = 1'b0;
        end
    end

    /*-- Calculate the pixel access index (to access the rom) --*/
    int Xsprite, Ysprite, pixel_access;
    assign Xsprite = DrawX - leftBound;
    assign Ysprite = DrawY - topBound;
    assign pixel_access = (32*Ysprite)+Xsprite;

    logic [3:0] palette_idx, data_in;

    wingedEyeROM w_e_rom(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(palette_idx));
	 
	 assign palette_out = (draw_sprite) ? palette_idx : 4'h0;
endmodule

module enemy_ghost_mapper (input [19:0] sprite_info,
                          input Clk,
                          input [9:0] DrawX, DrawY,
                          output logic [3:0] palette_out);


    /*-- Mapping from the sprite list to variables--*/
    logic [9:0] XCoord;
    logic [8:0] YCoord;
    logic sprite_en, draw_sprite;
    
	 assign XCoord = sprite_info[18:9];
    assign YCoord = sprite_info[8:0];
    assign sprite_en = sprite_info[19];
    
    
    /*-- Calculate all boundaries, x/y coord is top left --*/
    logic [9:0] leftBound, rightBound, topBound, lowerBound;
    
    assign leftBound = XCoord;
    assign rightBound = XCoord+31;
    assign topBound = YCoord;
    assign lowerBound = YCoord+47;

    /*-- Check if DrawX/DrawY is within boundaries, check if I should draw the sprite --*/
    always_comb begin
        if (DrawX>=leftBound && DrawX<=rightBound && sprite_en
            && DrawY<=lowerBound && DrawY>=topBound) begin
            draw_sprite = 1'b1;
        end else begin
            draw_sprite = 1'b0;
        end
    end

    /*-- Calculate the pixel access index (to access the rom) --*/
    int Xsprite, Ysprite, pixel_access;
    assign Xsprite = DrawX - leftBound;
    assign Ysprite = DrawY - topBound;
    assign pixel_access = (32*Ysprite)+Xsprite;

    logic [3:0] palette_idx, data_in;

    enemyGhostROM e_g_rom(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(palette_idx));
	 
	 assign palette_out = (draw_sprite) ? palette_idx : 4'h0;
endmodule

module enemy_fairy_mapper (input [19:0] sprite_info,
                          input Clk,
                          input [9:0] DrawX, DrawY,
                          output logic [3:0] palette_out);


    /*-- Mapping from the sprite list to variables--*/
    logic [9:0] XCoord;
    logic [8:0] YCoord;
    logic sprite_en, draw_sprite;
    
	 assign XCoord = sprite_info[18:9];
    assign YCoord = sprite_info[8:0];
    assign sprite_en = sprite_info[19];
    
    
    /*-- Calculate all boundaries, x/y coord is top left --*/
    logic [9:0] leftBound, rightBound, topBound, lowerBound;
    
    assign leftBound = XCoord;
    assign rightBound = XCoord+31;
    assign topBound = YCoord;
    assign lowerBound = YCoord+47;

    /*-- Check if DrawX/DrawY is within boundaries, check if I should draw the sprite --*/
    always_comb begin
        if (DrawX>=leftBound && DrawX<=rightBound && sprite_en
            && DrawY<=lowerBound && DrawY>=topBound) begin
            draw_sprite = 1'b1;
        end else begin
            draw_sprite = 1'b0;
        end
    end

    /*-- Calculate the pixel access index (to access the rom) --*/
    int Xsprite, Ysprite, pixel_access;
    assign Xsprite = DrawX - leftBound;
    assign Ysprite = DrawY - topBound;
    assign pixel_access = (32*Ysprite)+Xsprite;

    logic [3:0] palette_idx, data_in;

    enemyFairyROM e_f_rom(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(palette_idx));
	 
	 assign palette_out = (draw_sprite) ? palette_idx : 4'h0;
endmodule


module bullet_mapper (input [19:0] sprite_info,
                          input Clk,
                          input [9:0] DrawX, DrawY,
                          output logic [3:0] palette_out);


    /*-- Mapping from the sprite list to variables--*/
    logic [9:0] XCoord;
    logic [8:0] YCoord;
    logic sprite_en, draw_sprite;
    
	 assign XCoord = sprite_info[18:9];
    assign YCoord = sprite_info[8:0];
    assign sprite_en = sprite_info[19];
    
    
    /*-- Calculate all boundaries, x/y coord is top left --*/
    logic [9:0] leftBound, rightBound, topBound, lowerBound;
    
    assign leftBound = XCoord;
    assign rightBound = XCoord+31;
    assign topBound = YCoord;
    assign lowerBound = YCoord+47;

    /*-- Check if DrawX/DrawY is within boundaries, check if I should draw the sprite --*/
    always_comb begin
        if (DrawX>=leftBound && DrawX<=rightBound && sprite_en
            && DrawY<=lowerBound && DrawY>=topBound) begin
            draw_sprite = 1'b1;
        end else begin
            draw_sprite = 1'b0;
        end
    end

    /*-- Calculate the pixel access index (to access the rom) --*/
    int Xsprite, Ysprite, pixel_access;
    assign Xsprite = DrawX - leftBound;
    assign Ysprite = DrawY - topBound;
    assign pixel_access = (32*Ysprite)+Xsprite;

    logic [3:0] palette_idx, data_in;

    bulletROM b_rom(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(palette_idx));
	 
	 assign palette_out = (draw_sprite) ? palette_idx : 4'h0;
endmodule


module digit_mapper (	input [19:0] sprite_info,
                        input Clk,
                        input [9:0] DrawX, DrawY,
								input [3:0] digit, // 0-9 digit to represent
                        output logic [3:0] palette_out);


    /*-- Mapping from the sprite list to variables--*/
    logic [9:0] XCoord;
    logic [8:0] YCoord;
    logic sprite_en, draw_sprite;
    
	 assign XCoord = sprite_info[18:9];
    assign YCoord = sprite_info[8:0];
    assign sprite_en = sprite_info[19];
    
    
    /*-- Calculate all boundaries, x/y coord is top left --*/
    logic [9:0] leftBound, rightBound, topBound, lowerBound;
    
    assign leftBound = XCoord;
    assign rightBound = XCoord+31;
    assign topBound = YCoord;
    assign lowerBound = YCoord+47;

    /*-- Check if DrawX/DrawY is within boundaries, check if I should draw the sprite --*/
    always_comb begin
        if (DrawX>=leftBound && DrawX<=rightBound && sprite_en
            && DrawY<=lowerBound && DrawY>=topBound) begin
            draw_sprite = 1'b1;
        end else begin
            draw_sprite = 1'b0;
        end
    end

    /*-- Calculate the pixel access index (to access the rom) --*/
    int Xsprite, Ysprite, pixel_access;
    assign Xsprite = DrawX - leftBound;
    assign Ysprite = DrawY - topBound;
    assign pixel_access = (32*Ysprite)+Xsprite;

    logic [3:0] zero_palette_idx, one_palette_idx, two_palette_idx, three_palette_idx, data_in, four_palette_idx, five_palette_idx;
	 logic [3:0] six_palette_idx, seven_palette_idx, eight_palette_idx, nine_palette_idx, palette_idx; 

    zeroROM		zero1(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(zero_palette_idx));
	 oneROM 		one1(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(one_palette_idx));
	 twoROM		two1(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(two_palette_idx));
	 threeROM	three1(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(three_palette_idx));
	 fourROM		four1(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(four_palette_idx));
	 fiveROM		five1(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(five_palette_idx));
	 sixROM		six1(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(six_palette_idx));
	 sevenROM	seven1(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(seven_palette_idx));
	 eightROM	eight1(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(eight_palette_idx));
	 nineROM		nine1(.data_in(4'b0), .write_address(11'b0), .read_address(pixel_access), .we(1'b0), .Clk(Clk), .data_out(nine_palette_idx));
	 
	 //Decide which direction of the player sprite to draw
	 always_comb begin
		unique case (digit)
			4'd0: palette_idx = zero_palette_idx;
			4'd1: palette_idx = one_palette_idx;
			4'd2: palette_idx = two_palette_idx;
			4'd3: palette_idx = three_palette_idx;
			4'd4: palette_idx = four_palette_idx;
			4'd5: palette_idx = five_palette_idx;
			4'd6: palette_idx = six_palette_idx;
			4'd7: palette_idx = seven_palette_idx;
			4'd8: palette_idx = eight_palette_idx;
			4'd9: palette_idx = nine_palette_idx;
			default: palette_idx = zero_palette_idx; // this shouldn't happen?
		endcase
	 end
	 
	 //assign palette_out = (draw_sprite) ? palette_idx : 4'h0;
	 assign palette_out = palette_idx;
endmodule


