; RUN: llc < %s | FileCheck %s

; This test verifies that SelectionDAG can handle landingPad of token type.

define void @test() personality i32 (...)* @dummy_personality {
; CHECK: .cfi_personality 155, _dummy_personality
entry:
  invoke void @dummy()
          to label %return unwind label %unwind

unwind:                                           ; preds = %entry
  %lp = landingpad token
            cleanup
  br label %return

return:                                           ; preds = %entry
  ret void
}

declare void @dummy()

declare i32 @dummy_personality(...)
