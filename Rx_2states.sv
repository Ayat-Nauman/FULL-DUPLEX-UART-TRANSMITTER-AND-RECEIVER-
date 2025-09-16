module Rx_2states #(parameter DW = 8, baud_DW = 8 
)(
input logic clk, rst, rx, rx_start,
input logic [baud_DW-1:0]clkdiv,
output logic rx_done,
output logic [DW-1:0] rx_data
);

logic [baud_DW-1:0]baud_counter; //counts the no of clock cycles till 'clkdiv' for which baud value is one
logic [5:0]bit_counter; 
logic [DW:0]rx_buffer; // 9 bits buffer


typedef enum logic {IDLE, RECEIVING} transition_states;
transition_states state;

always_ff @(posedge clk or negedge rst) begin
	if(!rst) begin
		state <= IDLE;
		bit_counter <= 0;
		baud_counter <= 0;
		rx_done <= 1'b0;
		rx_data <= 8'b00000000;
	end else begin
		case (state) 
			IDLE: begin
  			rx_done <= 1'b0;
  			if(!rx) begin
     				baud_counter <= baud_counter +1;
			end else begin 
				baud_counter <= 0;
			end 
			if (baud_counter == (clkdiv >> 1)) begin
				state <= RECEIVING;
				baud_counter <= 0;
			end
			end
			RECEIVING: begin
 				baud_counter <= baud_counter + 1;
				if (baud_counter == clkdiv) begin 
					baud_counter <= 0;		
					bit_counter <= bit_counter + 1;
					rx_buffer <= {rx, rx_buffer[8:1]};
				end	
			if (bit_counter == DW+1) begin
				rx_done <= 1'b1;
				rx_data <= rx_buffer [7:0];
				state <= IDLE;
			end
			end
			endcase
		end
	end
endmodule

