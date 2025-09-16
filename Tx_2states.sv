// Define parameter for port list usage
module Tx_2states #(
    parameter DW = 8
)(
input logic clk, rst, tx_start,
input logic [7:0]clkdiv,
input logic [DW-1:0] tx_data,
output logic tx_done, tx
);

// state definition using enum
typedef enum logic{IDLE, TRANSMITTING}transition_states;
transition_states state; 

logic [3:0]bit_counter; //counts start, data, stop bits (total no of bits = 10)
logic [6:0]baud_counter; //counts the no of clock cycles till 'clkdiv' for which baud is one
logic [9:0]tx_buffer; // holds 1 start bit, 8 data bits, and 1 stop bit

always_ff @(posedge clk or negedge rst) begin
	if(!rst) begin
// default assignments
		state <= IDLE;
		tx_done <= 0;
		tx <= 1;
	end else begin

// state transition logic + output logic
		case (state)
		IDLE: begin
		tx <= 1;
		tx_done <= 0;
		if (tx_start) begin
			state <= TRANSMITTING;
			bit_counter <= 0;
			baud_counter <= 0;
			tx_buffer <= {1'b0, tx_data, 1'b0}; //loading the buffer with start, data, and stop bits
		end
		end

		TRANSMITTING: begin
			tx <= tx_buffer [0]; // transmitting the LSB bit
			baud_counter++;
			if (baud_counter == clkdiv) begin
				baud_counter <= 0;
				bit_counter++;
				tx_buffer[8:0] <= tx_buffer[9:1]; //// Shift tx_buffer right by 1 to send the bit to LSB position for transmission
				if (bit_counter == 9) begin
					tx_done <= 1;
					state <= IDLE;
				end
			end 
		end

		endcase

	end

end

endmodule
