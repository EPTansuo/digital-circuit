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
  
  val s_idle::s_data::s_parity::s_stop::Nil = Enum(4)

  val dummy = RegInit(0.U(1.W))
  dummy := ~dummy
  dontTouch(dummy)

  withClockAndReset((!io.clk).asClock, reset) {
    val state = RegInit(s_idle)
    val cnt = RegInit(0.U(4.W))
    val data = RegInit(0.U(8.W))
    val parity = RegInit(0.U(1.W))

  

    switch(state) {
      is(s_idle) {
        when(io.data === 0.U) {
          state := s_data
          cnt := 0.U
          data := 0.U
          parity := 0.U
        }
      }
      is(s_data) {
        data := Cat(io.data, data(7,1))
        cnt := cnt + 1.U
        when(cnt === 7.U) {
          state := s_parity
        }
      }
      is(s_parity) {
        parity := io.data
        state := s_stop
      }
      is(s_stop) {
        state := s_idle
        
      }
    }
    when(state === s_stop) {
      printf("data: %x, parity: %b\n", data, parity)
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

