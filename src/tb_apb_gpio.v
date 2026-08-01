module tb;

    reg PCLK;
    reg PRESETn;

    reg [7:0] PADDR;
    reg [7:0] PWDATA;

    reg PSEL;
    reg PENABLE;
    reg PWRITE;

    wire [7:0] PRDATA;
    wire PREADY;
    wire PSLVERR;

    reg [7:0] GPIO_IN;
    wire [7:0] GPIO_OUT;
    wire [7:0] GPIO_DIR;

    apb_gpio dut (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR),
        .GPIO_IN(GPIO_IN),
        .GPIO_OUT(GPIO_OUT),
        .GPIO_DIR(GPIO_DIR)
    );


     initial begin
	    $dumpfile("apb_gpio.vcd");
	    $dumpvars(0,tb);
    end

    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;
    end
    
    
    initial begin

        PRESETn = 0;
        GPIO_IN = 8'hA5;

        PADDR   = 0;
        PWDATA  = 0;
        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;

        #20;
        PRESETn = 1;

        // Write GPIO_OUT
        @(posedge PCLK);
        PADDR   = 8'h00;
        PWDATA  = 8'h55;
        PSEL    = 1;
        PWRITE  = 1;

        @(posedge PCLK);
        PENABLE = 1;

        @(posedge PCLK);
        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;

        // Write GPIO_DIR
        @(posedge PCLK);
        PADDR   = 8'h04;
        PWDATA  = 8'hFF;
        PSEL    = 1;
        PWRITE  = 1;

        @(posedge PCLK);
        PENABLE = 1;

        @(posedge PCLK);
        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;
        
	//------------------------------------
	// Read GPIO_IN
	//------------------------------------
	@(posedge PCLK);
	PADDR   = 8'h00;
	PSEL    = 1;
	PWRITE  = 0;

	@(posedge PCLK);
	PENABLE = 1;

	@(posedge PCLK);

	$display("READ GPIO_IN = %h", PRDATA);

	PSEL    = 0;
	PENABLE = 0;

	//------------------------------------
	// Read GPIO_DIR
	//------------------------------------
	@(posedge PCLK);
	PADDR   = 8'h04;
	PSEL    = 1;
	PWRITE  = 0;

	@(posedge PCLK);
	PENABLE = 1;

	@(posedge PCLK);

	$display("READ GPIO_DIR = %h", PRDATA);

	PSEL    = 0;
	PENABLE = 0;

        #100;
        $finish;
        
    end

endmodule
