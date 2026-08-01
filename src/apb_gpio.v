module apb_gpio (
    input  wire        PCLK,
    input  wire        PRESETn,

    input  wire [7:0]  PADDR,
    input  wire [7:0]  PWDATA,
    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,

    output reg  [7:0]  PRDATA,
    output wire        PREADY,
    output wire        PSLVERR,

    input  wire [7:0]  GPIO_IN,
    output reg  [7:0]  GPIO_OUT,
    output reg  [7:0]  GPIO_DIR
);

    // Address Map
    localparam GPIO_DATA_ADDR = 8'h00;
    localparam GPIO_DIR_ADDR  = 8'h04;

    assign PREADY  = 1'b1;
    assign PSLVERR = 1'b0;

    //-------------------------
    // APB Write Logic
    //-------------------------
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            GPIO_OUT <= 8'h00;
            GPIO_DIR <= 8'h00;
        end
        else if (PSEL && PENABLE && PWRITE) begin
            case (PADDR)

                GPIO_DATA_ADDR:
                    GPIO_OUT <= PWDATA;

                GPIO_DIR_ADDR:
                    GPIO_DIR <= PWDATA;

                default:
                    begin
                        GPIO_OUT <= GPIO_OUT;
                        GPIO_DIR <= GPIO_DIR;
                    end

            endcase
        end
    end

    //-------------------------
    // APB Read Logic
    //-------------------------
    always @(*) begin
    PRDATA = 8'h00;

    if (PSEL && !PWRITE) begin
        case (PADDR)
        
            GPIO_DATA_ADDR : PRDATA = GPIO_IN;
            GPIO_DIR_ADDR  : PRDATA = GPIO_DIR;
            default        : PRDATA = 8'h00;
            
        endcase
        
    end
    end

endmodule
