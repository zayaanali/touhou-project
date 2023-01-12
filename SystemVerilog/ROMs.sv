module playerCenterROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/player-center.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule

module playerRightROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/player-right.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule

module playerLeftROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/player-left.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule

module wingedEyeROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/enemy-winged-eye.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule

module enemyGhostROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/enemy-ghost.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule

module enemyFairyROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/enemy-fairy.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule

module bulletROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/bullet.txt", mem);
end

always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end
endmodule

module zeroROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/zero.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule


module oneROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/one.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule


module twoROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/two.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule


module threeROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/three.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule


module fourROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/four.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule


module fiveROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/five.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule


module sixROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/six.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule


module sevenROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/seven.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule


module eightROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/eight.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule


module nineROM
(
		input [3:0] data_in,
		input [10:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_out
);

// mem has width of 4 bits each and a total of w32*h48 addresses
logic [3:0] mem [0:1535];

initial begin
	 $readmemh("sprite_bytes/nine.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out <= mem[read_address];
end

endmodule

