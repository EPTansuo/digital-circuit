package MyModule

import chisel3._
import chisel3.util._
// import chisel3.stage._
import chisel3.experimental._
import _root_.circt.stage.ChiselStage

class VGAIO extends Bundle {
  val r = Output(UInt(8.W))
  val g = Output(UInt(8.W))
  val b = Output(UInt(8.W))
  val hsync = Output(Bool())
  val vsync = Output(Bool())
  val valid = Output(Bool())
}



class MyModule extends Module {
  val io = IO(new VGAIO)

/*
  //640x480分辨率下的VGA参数设置
  parameter    h_frontporch = 96;
  parameter    h_active = 144;
  parameter    h_backporch = 784;
  parameter    h_total = 800;

  parameter    v_frontporch = 2;
  parameter    v_active = 35;
  parameter    v_backporch = 515;
  parameter    v_total = 525;
  */

  val h_frontporch = 96
  val h_active = 144
  val h_backporch = 784
  val h_total = 800

  val v_frontporch = 2
  val v_active = 35
  val v_backporch = 515
  val v_total = 525

  val x_cnt = RegInit(1.U(10.W))
  val y_cnt = RegInit(1.U(10.W))
  val h_valid = Wire(Bool())
  val v_valid = Wire(Bool())

  when(x_cnt === h_total.U){
    x_cnt := 1.U
  }.otherwise{
    x_cnt := x_cnt + 1.U
  }

  when(y_cnt === v_total.U && x_cnt === h_total.U){
    y_cnt := 1.U
  }.elsewhen(x_cnt === h_total.U){
    y_cnt := y_cnt + 1.U
  }

  io.hsync := x_cnt > h_frontporch.U
  io.vsync := y_cnt > v_frontporch.U
  
  h_valid := x_cnt > h_active.U & (x_cnt <= h_backporch.U)
  v_valid := y_cnt > v_active.U & (y_cnt <= v_backporch.U) 
  io.valid := h_valid & v_valid

  val h_addr = Mux(h_valid, (x_cnt - h_active.U), 0.U)
  val v_addr = Mux(v_valid, (y_cnt - v_active.U), 0.U)

  io.r := 0.U
  io.g := 0.U
  io.b := 0.U

  when(io.valid){
    when((h_addr >= 0.U && h_addr <= 106.U) || (h_addr > 320.U && h_addr <= 426.U)){
      io.r := 255.U
    }
    when((h_addr > 106.U && h_addr <= 212.U) || (h_addr > 426.U && h_addr <= 532.U)){
      io.g := 255.U
    }
    when((h_addr > 212.U && h_addr <= 320.U) || (h_addr > 532.U && h_addr <= 640.U)){
      io.b := 255.U
    }
  }
  

}

object MyModule extends App {
  // val firtoolOptions = Array("--disable-annotation-unknown")
  val firtoolOptions = Array("--lowering-options=" + List(
        // make yosys happy
        // see https://github.com/llvm/circt/blob/main/docs/VerilogGeneration.md
        "disallowLocalVariables",
        "disallowPackedArrays",
        "locationInfoStyle=wrapInAtSquareBracket"
    ).reduce(_ + "," + _),
    "--disable-annotation-unknown")
  ChiselStage.emitSystemVerilogFile(new MyModule, args, firtoolOptions)
}

