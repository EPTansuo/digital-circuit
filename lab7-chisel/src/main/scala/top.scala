package MyModule

import chisel3._
import chisel3.util._
// import chisel3.stage._
import chisel3.experimental._
import _root_.circt.stage.ChiselStage

class PS2IO extends Bundle {
  val clk = Input(Bool())
  val data = Input(Bool())
}


class MyModule extends Module {
  val io = IO(new PS2IO)
  
  // val s_idle::s_data::s_parity::s_stop::Nil = Enum(4)
  // val state = RegInit(s_idle)
  val cnt = RegInit(0.U(4.W))
  val data = RegInit(0.U(9.W))
  val ps2_clk_reg = RegInit(io.clk)
  val fifo = Module(new Queue(UInt(8.W), 8))
  
  ps2_clk_reg := io.clk 
  val next_bit = ps2_clk_reg && (!io.clk)
  
  when(cnt === 10.U && next_bit){
    cnt := 0.U
  }.elsewhen(next_bit){
    cnt := cnt + 1.U
  }
  

  when(cnt =/= 0.U && cnt =/= 10.U && next_bit){
    data := Cat(io.data, data(8,1))
  }

  fifo.io.enq.valid := (cnt === 10.U) && next_bit 
  fifo.io.enq.bits := data(7,0)


  when(fifo.io.deq.valid) {
    printf("data: %x, parity: %b\n", data(7,0),data(8))
    fifo.io.deq.ready := true.B
  }.otherwise {
    fifo.io.deq.ready := false.B
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

