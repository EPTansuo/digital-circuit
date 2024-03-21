#include <Vtop.h>
#include <nvboard.h>
#include <verilated.h>
#include <iostream>
#include <verilated_vcd_c.h>


static TOP_NAME dut;

void nvboard_bind_all_pins(Vtop *top);

static void single_cycle() {
  dut.clk = 0;
  dut.eval();
  dut.clk = 1;
  dut.eval();
}

static void reset(int n) {
  dut.rst = 1;
  while (n-- > 0)
    single_cycle();
  dut.rst = 0;
}

void nvboard_sim() {
  nvboard_bind_all_pins(&dut);
  nvboard_init();

  reset(10);

  while (1) {
    nvboard_update();
    single_cycle();
  }
}
/*
void verilator_sim(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);
  Verilated::traceEverOn(true);
  Vtop *top = new Vtop;

  VerilatedVcdC *tfp = new VerilatedVcdC;

  top->trace(tfp, 0);
  tfp->open("wave.vcd");

  	// for (int i = 0; i < 4; i++) {
   //                top->a = i & 1;
   //                top->b = (i >> 1) & 1;
   //
   //                top->eval();
   //                tfp->dump(i);
   //
   //                std::cout << "a = " << (top->a ? "1" : "0")
   //                        << ", b = " << (top->b ? "1" : "0")
   //                        << ", f = " << (top->f ? "1" : "0") << std::endl;
   //
   //
   //                }

  top->final();
  tfp->close();

  delete top;
}
*/
int main(int argc, char** argv) {

  nvboard_sim();

  return 0;
}
