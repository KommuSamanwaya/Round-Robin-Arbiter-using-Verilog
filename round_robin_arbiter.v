module round_robin_arbiter(
    input              clk,
    input              rst,
    input      [3:0]   req,
    output reg [3:0]   grant
);

    // Pointer indicates which requester has the highest priority
    reg [1:0] pointer;
    reg [1:0] next_pointer;

    //----------------------------------------------------
    // Pointer Register
    //----------------------------------------------------
    always @(posedge clk or posedge rst)
    begin
        if(rst)
            pointer <= 2'd0;
        else
            pointer <= next_pointer;
    end

    //----------------------------------------------------
    // Grant Logic and Next Pointer Logic
    //----------------------------------------------------
    always @(*)
    begin
        // Default values
        grant = 4'b0000;
        next_pointer = pointer;

        case(pointer)

        //------------------------------------------------
        // Priority : 0 → 1 → 2 → 3
        //------------------------------------------------
        2'd0:
        begin
            if(req[0])
            begin
                grant = 4'b0001;
                next_pointer = 2'd1;
            end
            else if(req[1])
            begin
                grant = 4'b0010;
                next_pointer = 2'd2;
            end
            else if(req[2])
            begin
                grant = 4'b0100;
                next_pointer = 2'd3;
            end
            else if(req[3])
            begin
                grant = 4'b1000;
                next_pointer = 2'd0;
            end
        end

        //------------------------------------------------
        // Priority : 1 → 2 → 3 → 0
        //------------------------------------------------
        2'd1:
        begin
            if(req[1])
            begin
                grant = 4'b0010;
                next_pointer = 2'd2;
            end
            else if(req[2])
            begin
                grant = 4'b0100;
                next_pointer = 2'd3;
            end
            else if(req[3])
            begin
                grant = 4'b1000;
                next_pointer = 2'd0;
            end
            else if(req[0])
            begin
                grant = 4'b0001;
                next_pointer = 2'd1;
            end
        end

        //------------------------------------------------
        // Priority : 2 → 3 → 0 → 1
        //------------------------------------------------
        2'd2:
        begin
            if(req[2])
            begin
                grant = 4'b0100;
                next_pointer = 2'd3;
            end
            else if(req[3])
            begin
                grant = 4'b1000;
                next_pointer = 2'd0;
            end
            else if(req[0])
            begin
                grant = 4'b0001;
                next_pointer = 2'd1;
            end
            else if(req[1])
            begin
                grant = 4'b0010;
                next_pointer = 2'd2;
            end
        end

        //------------------------------------------------
        // Priority : 3 → 0 → 1 → 2
        //------------------------------------------------
        2'd3:
        begin
            if(req[3])
            begin
                grant = 4'b1000;
                next_pointer = 2'd0;
            end
            else if(req[0])
            begin
                grant = 4'b0001;
                next_pointer = 2'd1;
            end
            else if(req[1])
            begin
                grant = 4'b0010;
                next_pointer = 2'd2;
            end
            else if(req[2])
            begin
                grant = 4'b0100;
                next_pointer = 2'd3;
            end
        end

        default:
        begin
            grant = 4'b0000;
            next_pointer = pointer;
        end

        endcase
    end

endmodule
