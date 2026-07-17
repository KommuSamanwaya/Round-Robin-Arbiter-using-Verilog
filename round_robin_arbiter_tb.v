`timescale 1ns/1ps

module round_robin_arbiter_tb;

reg clk;
reg rst;
reg [3:0] req;
wire [3:0] grant;

round_robin_arbiter DUT(
    .clk(clk),
    .rst(rst),
    .req(req),
    .grant(grant)
);

parameter CYCLE = 10;


initial
begin
    clk = 0;
    forever #(CYCLE/2) clk = ~clk;
end

// Apply Request Task

task apply_request;
input [3:0] r;
begin
    @(negedge clk);
    req = r;
end
endtask

// Monitor

initial
begin
    $display("Time\tPointer\tRequest\tGrant");
    $monitor("%0t\t%d\t%b\t%b",
              $time,
              DUT.pointer,
              req,
              grant);
end

// Stimulus

initial
begin

    rst = 1;
    req = 4'b0000;

    #15;
    rst = 0;

    apply_request(4'b0001);

    apply_request(4'b0010);

    apply_request(4'b0100);

    apply_request(4'b1000);

    apply_request(4'b1111);

    apply_request(4'b1010);

    apply_request(4'b0101);

    apply_request(4'b0110);

    apply_request(4'b1101);

    apply_request(4'b0000);

    #30;

    $finish;

end

initial
begin
    $dumpfile("round_robin.vcd");
    $dumpvars(0,round_robin_arbiter_tb);
end

endmodule
