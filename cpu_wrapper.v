
module cpu_wrapper 

//----------------------------------------------------------------
// Params
//----------------------------------------------------------------


//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
     clk_i
    ,rst_i
    ,rst_rom_i
    ,mode_sel_i
    ,en_w_rom_i
    ,w_rom_addr_i
    ,w_rom_data_i
    ,instruction_i
    ,WB_RAM_data_o
    ,WB_reg_data_1_o
    ,WB_reg_data_2_o
);

    // Inputs
    input clk_i;
    input rst_i;
    input rst_rom_i;
    input mode_sel_i;
    input en_w_rom_i;
    input [15:0] w_rom_addr_i;
    input [31:0] w_rom_data_i;
    input [31:0] instruction_i;
    
    // Outputs
    output [7:0] WB_RAM_data_o;
    output [7:0] WB_reg_data_1_o;
    output [7:0] WB_reg_data_2_o;

//----------------------------------------------------------------
// Includes
//----------------------------------------------------------------

`include "defs.v"

//----------------------------------------------------------------
// Modules Output Wires
//----------------------------------------------------------------
    
// PC
wire [15:0] pc_s30;
wire [1:0] pc_sgin_s12;
wire [1:0] pc_sgin_s23;

// ROM
wire [31:0] rom_inst_s12;
wire [31:0] inst_s12;

// Decoder
wire [7:0] alu_s12;
wire [1:0] reg_s12;
wire imm_s12;
wire mem_s12;
wire [4:0] r_reg_addr_1_s12;
wire [4:0] r_reg_addr_2_s12;
wire [4:0] r_reg_addr_3_s12;
wire [4:0] r_reg_addr_4_s12;
wire [15:0] r_ram_addr_s12;
wire [7:0] imm_data_1_s12;
wire [7:0] imm_data_2_s12;

// Instruction buffer
wire [7:0] alu_s23;
wire [1:0] reg_s23;
wire imm_s23;
wire mem_s23;
wire [4:0] r_reg_addr_1_s23;
wire [4:0] r_reg_addr_2_s23;
wire [4:0] r_reg_addr_3_s23;
wire [4:0] r_reg_addr_4_s23;
wire [15:0] r_ram_addr_s23;
wire [7:0] imm_data_1_s23;
wire [7:0] imm_data_2_s23;

// Register
wire [7:0] r_reg_data_1;
wire [7:0] r_reg_data_2;
wire [7:0] r_reg_data_3;
wire [7:0] r_reg_data_4;

// RAM
wire [7:0] r_ram_data;

// ALU
wire en_w_reg;
wire en_w_ram;
wire [7:0] w_ram_data;
wire [15:0] w_ram_addr;
wire [7:0] w_reg_data_1;
wire [7:0] w_reg_data_2;
wire [4:0] w_reg_addr_1;
wire [4:0] w_reg_addr_2;

//----------------------------------------------------------------
// Modules Import
//----------------------------------------------------------------

rom rom(
     .clk_i(clk_i)
    ,.rst_i(rst_rom_i)
    ,.pc_i(pc_s30)
    ,.w_rom_data_i(w_rom_data_i)
    ,.w_rom_addr_i(w_rom_addr_i)
    ,.en_w_rom_i(en_w_rom_i)
    ,.inst_o(rom_inst_s12)
);

inst_mode inst_mode(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.mode_sel_i(mode_sel_i)
    ,.imm_inst_i(instruction_i)
    ,.rom_inst_i(rom_inst_s12)
    ,.inst_o(inst_s12)
);

decode decode(
     .inst_i(inst_s12)
    ,.alu_o(alu_s12)
    ,.pc_o(pc_sgin_s12)
    ,.reg_o(reg_s12)
    ,.imm_o(imm_s12)
    ,.mem_o(mem_s12)
    ,.reg_addr_1_o(r_reg_addr_1_s12)
    ,.reg_addr_2_o(r_reg_addr_2_s12)
    ,.reg_addr_3_o(r_reg_addr_3_s12)
    ,.reg_addr_4_o(r_reg_addr_4_s12)
    ,.ram_addr_o(r_ram_addr_s12)
    ,.imm_data_1_o(imm_data_1_s12)
    ,.imm_data_2_o(imm_data_2_s12)
);

ram ram(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.en_w_ram_i(en_w_ram)
    ,.w_ram_data_i(w_ram_data)
    ,.w_ram_addr_i(w_ram_addr)
    ,.r_ram_addr_i(r_ram_addr_s12)
    ,.r_ram_data_o(r_ram_data)
);

register register(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.en_w_reg_i(en_w_reg)
    ,.w_reg_data_1_i(w_reg_data_1)
    ,.w_reg_data_2_i(w_reg_data_2)
    ,.w_reg_addr_1_i(w_reg_addr_1)
    ,.w_reg_addr_2_i(w_reg_addr_2)
    ,.r_reg_addr_1_i(r_reg_addr_1_s12)
    ,.r_reg_addr_2_i(r_reg_addr_2_s12)
    ,.r_reg_addr_3_i(r_reg_addr_3_s12)
    ,.r_reg_addr_4_i(r_reg_addr_4_s12)
    ,.r_reg_data_1_o(r_reg_data_1)
    ,.r_reg_data_2_o(r_reg_data_2)
    ,.r_reg_data_3_o(r_reg_data_3)
    ,.r_reg_data_4_o(r_reg_data_4)
);

inst_buffer inst_buffer(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.alu_i(alu_s12)
    ,.pc_i(pc_sgin_s12)
    ,.reg_i(reg_s12)
    ,.imm_i(imm_s12)
    ,.mem_i(mem_s12)
    ,.reg_addr_1_i(r_reg_addr_1_s12)
    ,.reg_addr_2_i(r_reg_addr_2_s12)
    ,.reg_addr_3_i(r_reg_addr_3_s12)
    ,.reg_addr_4_i(r_reg_addr_4_s12)
    ,.ram_addr_i(r_ram_addr_s12)
    ,.imm_data_1_i(imm_data_1_s12)
    ,.imm_data_2_i(imm_data_2_s12)
    ,.alu_o(alu_s23)
    ,.pc_o(pc_sgin_s23)
    ,.reg_o(reg_s23)
    ,.imm_o(imm_s23)
    ,.mem_o(mem_s23)
    ,.reg_addr_1_o(r_reg_addr_1_s23)
    ,.reg_addr_2_o(r_reg_addr_2_s23)
    ,.reg_addr_3_o(r_reg_addr_3_s23)
    ,.reg_addr_4_o(r_reg_addr_4_s23)
    ,.ram_addr_o(r_ram_addr_s23)
    ,.imm_data_1_o(imm_data_1_s23)
    ,.imm_data_2_o(imm_data_2_s23)
);

alu alu(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.mode_sel_i(mode_sel_i)
    ,.alu_i(alu_s23)
    ,.pc_i(pc_sgin_s23)
    ,.reg_i(reg_s23)
    ,.imm_i(imm_s23)
    ,.mem_i(mem_s23)
    ,.reg_addr_1_i(r_reg_addr_1_s23)
    ,.reg_addr_2_i(r_reg_addr_2_s23)
    ,.reg_addr_3_i(r_reg_addr_3_s23)
    ,.reg_addr_4_i(r_reg_addr_4_s23)
    ,.ram_addr_i(r_ram_addr_s23)
    ,.imm_data_1_i(imm_data_1_s23)
    ,.imm_data_2_i(imm_data_2_s23)
    ,.r_ram_data_i(r_ram_data)
    ,.r_reg_data_1_i(r_reg_data_1)
    ,.r_reg_data_2_i(r_reg_data_2)
    ,.r_reg_data_3_i(r_reg_data_3)
    ,.r_reg_data_4_i(r_reg_data_4)
    ,.r_pc_data_i(pc_s30)
    ,.en_w_reg_o(en_w_reg)
    ,.en_w_ram_o(en_w_ram)
    ,.w_ram_data_o(w_ram_data)
    ,.w_ram_addr_o(w_ram_addr)
    ,.w_reg_data_1_o(w_reg_data_1)
    ,.w_reg_data_2_o(w_reg_data_2)
    ,.w_reg_addr_1_o(w_reg_addr_1)
    ,.w_reg_addr_2_o(w_reg_addr_2)
    ,.w_pc_data_o(pc_s30)
);

//----------------------------------------------------------------
// Output Watcher
//----------------------------------------------------------------

assign WB_RAM_data_o = w_ram_data;
assign WB_reg_data_1_o = w_reg_data_1;
assign WB_reg_data_2_o = w_reg_data_2;

endmodule
