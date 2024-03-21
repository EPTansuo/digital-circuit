#include <Vtop.h>
#include <nvboard.h>
#include <verilated.h>
#include <iostream>

#include "verilated_vcd_c.h"

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

void verilator_sim(int argc, char**argv){

    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;

    Verilated::traceEverOn(true); // 启用波形跟踪
    VerilatedVcdC* vcd = new VerilatedVcdC; // 创建VCD对象
    top->trace(vcd, 0); // 关联跟踪对象和VCD对象
    vcd->open("wave.vcd"); // 打开VCD文件

    unsigned int time = 0;


    for (int i = 0; i < 16; ++i) {
        if (i==5 || i== 11)
          top->sw &= 0b1111111111111110;  //输入0
        else
          top->sw |= 0b0000000000000001;  //输入1
        if(i<8)
          top->sw |= 0b1000000000000000;  //右移
        else
          top->sw &= 0b0111111111111111;  //左移

        top->btn = 0; top->eval();
        //vcd->dump(time++);
        top->btn = 1; top->eval();
        vcd->dump(time++);
    }

    vcd->close(); // 关闭VCD文件
    delete top;
    delete vcd;
    exit(0);
}
int main(int argc, char** argv) {

  nvboard_sim();
  //verilator_sim(argc,argv);
  return 0;
}
