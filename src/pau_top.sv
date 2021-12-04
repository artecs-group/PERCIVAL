// Copyright 2021 David Mallasén Quintana.
//
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Author: David Mallasén <dmallase@ucm.es>
// Date: 04.12.2021
// Description: Posit Arithmetic Unit top-level module

module pau_top import ariane_pkg::*; (
    input  logic                     clk_i,          // Clock
    input  logic                     rst_ni,         // Asynchronous reset active low
    input  fu_data_t                 fu_data_i,
    input  logic                     pau_valid_i,
    output logic                     pau_ready_o,
    output logic [TRANS_ID_BITS-1:0] pau_trans_id_o,
    output logic                     pau_valid_o,
    output riscv::xlen_t             result_o
);
    // This is a workaround. See fpu_wrap.sv
    // Otherwise compilation might issue an error if POSLEN=0
    enum logic {READY, STALL} state_q, state_d;

    if (POS_PRESENT) begin : pau_gen
        logic [POSLEN-1:0]   add_a_i;
        logic [POSLEN-1:0]   add_b_i;
        logic [POSLEN-1:0]   mul_a_i;
        logic [POSLEN-1:0]   mul_b_i;
        logic [POSLEN-1:0]   div_a_i;
        logic [POSLEN-1:0]   div_b_i;
        logic [POSLEN-1:0]   sqrt_i;
        logic [POSLEN-1:0]   qmadd_a_i;
        logic [POSLEN-1:0]   qmadd_b_i;
        logic [QUIRELEN-1:0] qmadd_c_i;
        logic [POSLEN-1:0]   add_o;
        logic [POSLEN-1:0]   mul_o;
        logic [POSLEN-1:0]   div_o;
        logic [POSLEN-1:0]   sqrt_o;
        logic [QUIRELEN-1:0] qmadd_o;

        logic [QUIRELEN-1:0] quire_q, quire_d, curr_quire;

        logic pau_valid_d;

        logic [TRANS_ID_BITS-1:0] trans_id_d, trans_id_q;

        riscv::xlen_t operand_a, operand_a_d, operand_a_q;
        riscv::xlen_t operand_b, operand_b_d, operand_b_q;

        fu_op operator, operator_d, operator_q, operator_delay;
        
        assign operand_a_d = fu_data_i.operand_a;
        assign operand_b_d = fu_data_i.operand_b;
        assign operator_d  = fu_data_i.operator;

        assign pau_trans_id_o = trans_id_q;

        // Current updated quire value (shortcut from the previous operation if needed)
        assign curr_quire = operator_delay inside {QMADD, QMSUB, QCLR, QNEG} ? quire_d
                            : quire_q;

        always_comb begin : quire_ops
            quire_d = quire_q;

            unique case (operator_delay)
                QCLR:      quire_d = '0;
                QNEG:      quire_d = ~quire_q + {{QUIRELEN-1{1'b0}}, 1'b1};
                QMADD,
                QMSUB:     quire_d = pau_ready_o ? qmadd_o : quire_q;
                default: ; // default case to suppress unique warning
            endcase
        end

        always_comb begin : addmul_ops
            add_a_i = '0;
            add_b_i = '0;
            mul_a_i = '0;
            mul_b_i = '0;
            div_a_i = '0;
            div_b_i = '0;
            sqrt_i  = '0;
            qmadd_a_i = '0;
            qmadd_b_i = '0;
            qmadd_c_i = '0;

            unique case (operator)
                PADD: begin    
                    add_a_i = operand_a[POSLEN-1:0];
                    add_b_i = operand_b[POSLEN-1:0];
                end
                PSUB: begin    
                    add_a_i = operand_a[POSLEN-1:0];
                    add_b_i = ~operand_b[POSLEN-1:0] + {{POSLEN-1{1'b0}}, 1'b1};
                end
                PMUL: begin  
                    mul_a_i = operand_a[POSLEN-1:0];
                    mul_b_i = operand_b[POSLEN-1:0];
                end
                PDIV: begin  
                    div_a_i = operand_a[POSLEN-1:0];
                    div_b_i = operand_b[POSLEN-1:0];
                end
                PSQRT: begin  
                    sqrt_i  = operand_a[POSLEN-1:0];
                end
                QMADD: begin
                    qmadd_a_i = operand_a[POSLEN-1:0];
                    qmadd_b_i = operand_b[POSLEN-1:0];
                    qmadd_c_i = curr_quire;
                end
                QMSUB: begin
                    qmadd_a_i = operand_a[POSLEN-1:0];
                    qmadd_b_i = ~operand_b[POSLEN-1:0] + {{POSLEN-1{1'b0}}, 1'b1};
                    qmadd_c_i = curr_quire;
                end
                default: ; // default case to suppress unique warning
            endcase
        end

        PositAdd pau_add_i (
            .clk ( clk_i   ),
            .X   ( add_a_i ),
            .Y   ( add_b_i ),
            .R   ( add_o   )
        );

        localparam bit POS_LOG_MULT = 1'b0;

        if (!POS_LOG_MULT) begin
            PositMult pau_mul_i (
                .clk ( clk_i   ),
                .X   ( mul_a_i ),
                .Y   ( mul_b_i ),
                .R   ( mul_o   )
            );
        end else begin
            PositLAM pau_mul_approx_i (
                .clk ( clk_i   ),
                .X   ( mul_a_i ),
                .Y   ( mul_b_i ),
                .R   ( mul_o   )
            );
        end

        PositLAD pau_div_approx_i (
            .clk ( clk_i   ),
            .X   ( div_a_i ),
            .Y   ( div_b_i ),
            .R   ( div_o   )
        );

        PositLASqrt pau_sqrt_approx_i (
            .clk ( clk_i  ),
            .X   ( sqrt_i ),
            .R   ( sqrt_o )
        );

        PositMAC pau_mac_i (
            .clk ( clk_i     ),
            .A   ( qmadd_a_i ),
            .B   ( qmadd_b_i ),
            .C   ( qmadd_c_i ),
            .R   ( qmadd_o   )
        );

        logic [31:0] conv32int_i;
        logic [63:0] conv64int_i;
        logic [POSLEN-1:0] convp_i;
        logic [QUIRELEN-1:0] convq_i;
        logic [31:0] conv_p2i_o, conv_p2i_q;
        logic [31:0] conv_p2u_o, conv_p2u_q;
        logic [63:0] conv_p2l_o, conv_p2l_q;
        logic [63:0] conv_p2lu_o, conv_p2lu_q;
        logic [POSLEN-1:0] conv_i2p_o, conv_i2p_q;
        logic [POSLEN-1:0] conv_u2p_o, conv_u2p_q;
        logic [POSLEN-1:0] conv_l2p_o, conv_l2p_q;
        logic [POSLEN-1:0] conv_lu2p_o, conv_lu2p_q;
        logic [POSLEN-1:0] conv_q2p_o;

        always_comb begin : conv_ops
            convp_i     = '0;
            conv32int_i = '0;
            conv64int_i = '0;
            convq_i     = '0;

            unique case (operator)
                PCVT_P2I, 
                PCVT_P2L, 
                PCVT_P2U, 
                PCVT_P2LU: begin
                    convp_i = operand_a[POSLEN-1:0];
                end
                PCVT_I2P,
                PCVT_U2P: begin
                    conv32int_i = operand_a[31:0];
                end
                PCVT_L2P,
                PCVT_LU2P: begin
                    conv64int_i = operand_a[63:0];
                end
                QROUND: begin
                    convq_i = curr_quire;
                end
                default: ; // default case to suppress unique warning
            endcase
        end

        Posit2Int pau_p2i (
            .clk ( clk_i      ),
            .X   ( convp_i    ),
            .R   ( conv_p2i_o )
        );

        Posit2UInt pau_p2u (
            .clk ( clk_i      ),
            .X   ( convp_i    ),
            .R   ( conv_p2u_o )
        );

        Posit2Long pau_p2l (
            .clk ( clk_i      ),
            .X   ( convp_i    ),
            .R   ( conv_p2l_o )
        );

        Posit2ULong pau_p2lu (
            .clk ( clk_i       ),
            .X   ( convp_i     ),
            .R   ( conv_p2lu_o )
        );

        Int2Posit pau_i2p (
            .clk ( clk_i       ),
            .X   ( conv32int_i ),
            .R   ( conv_i2p_o  )
        );

        UInt2Posit pau_u2p (
            .clk ( clk_i       ),
            .X   ( conv32int_i ),
            .R   ( conv_u2p_o  )
        );

        Long2Posit pau_l2p (
            .clk ( clk_i       ),
            .X   ( conv64int_i ),
            .R   ( conv_l2p_o  )
        );

        ULong2Posit pau_lu2p (
            .clk ( clk_i       ),
            .X   ( conv64int_i ),
            .R   ( conv_lu2p_o )
        );

        Quire2Posit pau_q2p (
            .clk ( clk_i      ),
            .X   ( convq_i    ),
            .R   ( conv_q2p_o )
        );

        logic move_flip; // Flip the sign of the move operations
        logic [POSLEN-1:0] sgnj_d, sgnj_o;
        logic [POSLEN-1:0] pmv_d, pmv_o;

        always_comb begin : move_ops
            move_flip = 1'b0;
            pmv_d     = '0;

            unique case (operator)
                PSGNJ: begin
                    if (fu_data_i.operand_a[POSLEN-1] != fu_data_i.operand_b[POSLEN-1])
                        move_flip = 1'b1;
                end
                PSGNJN: begin
                    if (fu_data_i.operand_a[POSLEN-1] == fu_data_i.operand_b[POSLEN-1])
                        move_flip = 1'b1;
                end
                PSGNJX: begin
                    if (fu_data_i.operand_b[POSLEN-1]) // sgn(a) ^ sgn(b) != sgn(a) <=> sgn(b)
                        move_flip = 1'b1;
                end
                PMV_P2X,
                PMV_X2P: pmv_d = operand_a;
                default: ; // default case to suppress unique warning
            endcase
        end

        assign sgnj_d = move_flip ? ~operand_a + {{POSLEN-1{1'b0}}, 1'b1}
                                  : operand_a;

        always_comb begin : result_mux
            result_o   = '0;

            unique case (operator_delay)
                PADD, PSUB:     result_o = {{riscv::XLEN-POSLEN{1'b0}}, add_o};
                PMUL:           result_o = {{riscv::XLEN-POSLEN{1'b0}}, mul_o};
                PDIV:           result_o = {{riscv::XLEN-POSLEN{1'b0}}, div_o};
                PSQRT:          result_o = {{riscv::XLEN-POSLEN{1'b0}}, sqrt_o};
                QROUND:         result_o = {{riscv::XLEN-POSLEN{1'b0}}, conv_q2p_o};

                PCVT_P2I:       result_o = {{riscv::XLEN-32{conv_p2i_o[31]}}, conv_p2i_q};
                PCVT_P2U:       result_o = {{riscv::XLEN-32{conv_p2u_o[31]}}, conv_p2u_q};
                PCVT_P2L:       result_o = conv_p2l_q;
                PCVT_P2LU:      result_o = conv_p2lu_q;
                PCVT_I2P:       result_o = {{riscv::XLEN-POSLEN{1'b0}}, conv_i2p_q};
                PCVT_U2P:       result_o = {{riscv::XLEN-POSLEN{1'b0}}, conv_u2p_q};
                PCVT_L2P:       result_o = {{riscv::XLEN-POSLEN{1'b0}}, conv_l2p_q};
                PCVT_LU2P:      result_o = {{riscv::XLEN-POSLEN{1'b0}}, conv_lu2p_q};

                PSGNJ,
                PSGNJN,
                PSGNJX:         result_o = {{riscv::XLEN-POSLEN{1'b0}}, sgnj_o};

                PMV_P2X,
                PMV_X2P:        result_o = {{riscv::XLEN-POSLEN{pmv_o[POSLEN - 1]}}, pmv_o};
                default: ; // default case to suppress unique warning
            endcase
        end

        logic hold_inputs;
        logic use_hold;
        logic [1:0] count;
        logic [1:0] latency_d, latency_q;

        always_comb begin : p_inputFSM
            // Default Values
            pau_ready_o  = 1'b0;
            hold_inputs  = 1'b0;    // Hold register disabled
            use_hold     = 1'b0;    // Inputs go directly to unit
            pau_valid_d  = 1'b0;
            state_d      = state_q; // Stay in the same state
            trans_id_d   = trans_id_q;

            unique case (state_q)
                // Default state, ready for instructions
                READY: begin
                    pau_ready_o  = 1'b1;        // Act as if PAU ready
                    trans_id_d = fu_data_i.trans_id;

                    if (pau_valid_i) begin
                        if (latency_d > 0) begin
                            pau_ready_o = 1'b0;  // No token given to Issue
                            hold_inputs = 1'b1;  // save inputs to the holding register
                            state_d     = STALL; // stall future incoming requests
                        end else begin
                            pau_valid_d  = 1'b1; // 1 cycle operations
                        end
                    end
                end
                // We're stalling the upstream (ready=0)
                STALL: begin
                    use_hold     = 1'b1; // The data comes from the hold reg

                    // Wait until it's consumed
                    if (count == latency_q) begin
                        pau_ready_o = 1'b1;  // Give a token to issue
                        pau_valid_d = 1'b1;  // Multicycle operations
                        state_d     = READY; // Accept future requests
                    end
                end
                default: ;
            endcase
        end  // p_inputFSM

        // Registers and FSM state holding
        always_ff @(posedge clk_i or negedge rst_ni) begin : pos_hold_reg
            if(~rst_ni) begin
                state_q        <= READY;
                operand_a_q    <= '0;
                operand_b_q    <= '0;
                quire_q        <= '0;
                latency_q      <= '0;
                trans_id_q     <= '0;
                pau_valid_o    <= '0;
                sgnj_o         <= '0;
                pmv_o          <= '0;
                conv_p2i_q     <= '0;
                conv_p2u_q     <= '0;
                conv_p2l_q     <= '0;
                conv_p2lu_q    <= '0;
                conv_i2p_q     <= '0;
                conv_u2p_q     <= '0;
                conv_l2p_q     <= '0;
                conv_lu2p_q    <= '0;
            end else begin
                state_q        <= state_d;
                quire_q        <= quire_d;
                latency_q      <= latency_d;
                trans_id_q     <= trans_id_d;
                pau_valid_o    <= pau_valid_d;
                sgnj_o         <= sgnj_d;
                pmv_o          <= pmv_d;
                operator_delay <= operator;
                conv_p2i_q     <= conv_p2i_o;
                conv_p2u_q     <= conv_p2u_o;
                conv_p2l_q     <= conv_p2l_o;
                conv_p2lu_q    <= conv_p2lu_o;
                conv_i2p_q     <= conv_i2p_o;
                conv_u2p_q     <= conv_u2p_o;
                conv_l2p_q     <= conv_l2p_o;
                conv_lu2p_q    <= conv_lu2p_o;
                // Hold register is [TRIGGERED] by FSM
                if (hold_inputs) begin
                    operand_a_q   <= operand_a_d;
                    operand_b_q   <= operand_b_d;
                    operator_q    <= operator_d;
                end
            end
        end  // pos_hold_reg

        // Select PAU input data: from register if valid data in register, else directly from input
        assign operand_a  = use_hold ? operand_a_q  : operand_a_d;
        assign operand_b  = use_hold ? operand_b_q  : operand_b_d;
        assign operator   = use_hold ? operator_q   : operator_d;

        // Pipeline stalling
        always_ff @(posedge clk_i or negedge rst_ni) begin : pos_pipe_reg
            if(~rst_ni || state_d == READY) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end  // pos_pipe_reg

        always_comb begin : latency_mux
            unique case (operator)
                PADD, PSUB:          latency_d = 2'b10;
                PMUL, PDIV, PSQRT,
                QROUND,QMADD, QMSUB: latency_d = 2'b01;
                default:             latency_d = 2'b00;
            endcase
        end  // latency_mux

    end  // pau_gen
endmodule