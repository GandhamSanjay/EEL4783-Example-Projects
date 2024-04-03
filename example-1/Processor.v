module Processor(
    input clk       // clock
    );
    
    
    reg [63:0]  PC = 0;      // Program Counter
    reg [15:0]  Instruction; // Holds instruction binary
    reg [15:0]  reg1_addr;     // Data from Source 1 RS1
    reg [15:0]  reg2_addr;     // Data from Source 2  RS2
    reg [1:0]   State = 0;   // State of machine
    reg [3:0]   op_code;    // Opcode from instruction
    
    // Memory block
    reg [15:0] inst_mem [0:8192]; // Instruction memory 8KB  8192
    reg [15:0] data_mem [0:8192]; // Data memory 8KB
    reg [7:0] Register_File [0:7]; // Register File 8 registers of 8-bits
    
    initial
    begin
        $readmemb("instfile.mem", inst_mem);
        $readmemb("datafile.mem", data_mem);
    end
        
    always@(posedge clk)
    begin
        if(State == 0)              
            begin
            	Instruction <= inst_mem[PC];// Read instruction from instruction memory
            	PC <= PC + 1;// increment PC
            	State <= 1;// change state
            end
        else if(State == 1)          // Instruction Decode and read data from register/memory
            begin
                op_code <= Instruction[15:12]; // Extract opcode from instruction
                case(Instruction[15:12])
                    4'b0000: //ADD //0
                        begin
                            reg1_addr <= Register_File[Instruction [11:9]]; // Read source register 1 from register file
                            reg2_addr <= Register_File[Instruction [8:6]]; // Read source register 2 from register file
                        end
                        
                    4'b0001:// Sub  //1
                        begin
                            reg1_addr <= Register_File[Instruction [11:9]]; // Read source register 1 from register file
                            reg2_addr <= Register_File[Instruction [8:6]]; // Read source register 2 from register file
                        end 
                          
                    4'b0010:// Mul //2
                        begin
                            reg1_addr <= Register_File[Instruction [11:9]]; // Read source register 1 from register file
                            reg2_addr <= Register_File[Instruction [8:6]]; // Read source register 2 from register file
                        end
                            
                            
                    4'b0011:// Div  //3
                        begin
                            reg1_addr <= Register_File[Instruction [11:9]]; // Read source register 1 from register file
                            reg2_addr <= Register_File[Instruction [8:6]]; // Read source register 2 from register file
                        end  
                        
                          
                    4'b0100:// AND  //4
                        begin
                            reg1_addr <= Register_File[Instruction [11:9]]; // Read source register 1 from register file
                            reg2_addr <= Register_File[Instruction [8:6]]; // Read source register 2 from register file
                        end  
                          
                    4'b0101:// OR  //5
                        begin
                            reg1_addr <= Register_File[Instruction [11:9]]; // Read source register 1 from register file
                            reg2_addr <= Register_File[Instruction [8:6]]; // Read source register 2 from register file
                        end 
                           
                    4'b0110:// NOT   //6
                        begin
                            reg1_addr <= Register_File[Instruction [11:9]]; // Read source register 1 from register file
                            
                        end
                    4'b0111:// Load  //7
                        begin
                            reg1_addr <= data_mem[Instruction [5:0]]; // Read data memory
                        end
                        
                    4'b1000:// BEQ  //8
                        begin
                            reg1_addr <= Register_File[Instruction [11:9]]; // Read source register 1 from register file
                            reg2_addr <= Register_File[Instruction [8:6]]; // Read source register 2 from register file
                        end
                        
                    4'b1001:// Jump    //9
                       begin
                       PC <= Instruction[7:0];
                       end
                       
                       4'b1010:// Store  //10
                        begin
                            reg1_addr <= Register_File[Instruction [11:9]]; // Read source register 1 from register file                        
                        end
                        
                       4'b1011:// MOVE  //11 Read value from RS
                        begin
                            reg1_addr <= Register_File[Instruction [11:9]]; // Read source register 1 from register file
                        end
            endcase
            State <= 2;  //update state
            end
        else if(State == 2)          // ALU operations will use case system and execute
            begin
               case(Instruction[15:12])
                    4'b0000:    begin   // write the result of Add instruction back to register file  //0
                                    Register_File[Instruction [5:0]] <= reg1_addr + reg2_addr;
                                end
                                
		            4'b0001:    begin   // Sub  1
                                    Register_File[Instruction [5:0]] <= reg1_addr - reg2_addr;
                                end
                                
                    4'b0010:    begin   // Mul  //2
                                    Register_File[Instruction [5:0]] <= reg1_addr * reg2_addr;
                                end
                                
                    4'b0011:    begin   // Div  //3
                                    Register_File[Instruction [5:0]] <= reg1_addr / reg2_addr;
                                end
                                
                    4'b0100:    begin   // AND  //4
                                    Register_File[Instruction [5:0]] <= reg1_addr & reg2_addr;
                                end
                                
		            4'b0101:    begin   // OR  //5
                                    Register_File[Instruction [5:0]] <= reg1_addr | reg2_addr;
                                end
                                          
                    4'b0110:    begin   // NOT  //6
                                    Register_File[Instruction [5:0]] <= !reg1_addr;
                                end
                                
                    4'b0111:    begin   // Load // write data to register  //7
                                    Register_File[Instruction [8:6]] = reg1_addr;
                               end 
                                   
                    4'b1000:    begin   // BEQ //8
                                    if (reg1_addr == reg2_addr)
                                      PC <= Instruction [5:0];
                                    else
                                      PC <= PC + 1;                  
                                end
                    4'b1001:    begin  // Jump  //9
                                    PC = Instruction[5:0];
                    end              
                    
                    4'b1010:    begin  // Store // write data to data memory from register //10
                                    data_mem[Instruction[5:0]] = reg1_addr;
                                end
                                
                    4'b1011:    begin  // MOVE  //11 Copies value from RS to RD
                                    Register_File[Instruction [8:6]] <= reg1_addr; //Copy RS to RD
                                    Register_File[Instruction [11:9]] <= 0;// clear out RS
                                end
                endcase
               State <= 0; //update state
            end
    end
    
endmodule
