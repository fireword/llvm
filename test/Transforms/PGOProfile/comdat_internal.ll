; RUN: opt < %s -pgo-instr-gen -instrprof -S | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

$foo = comdat any

; CHECK: $__llvm_profile_raw_version = comdat any
; CHECK: $__profv__stdin__foo = comdat any

@bar = global i32 ()* @foo, align 8

; CHECK: @__llvm_profile_raw_version = constant i64 {{[0-9]+}}, comdat
; CHECK: @__profn__stdin__foo = private constant [11 x i8] c"<stdin>:foo"
; CHECK: @__profc__stdin__foo = private global [1 x i64] zeroinitializer, section "__llvm_prf_cnts", comdat($__profv__stdin__foo), align 8
; CHECK: @__profd__stdin__foo = private global { i64, i64, i64*, i8*, i8*, i32, [1 x i16] } { i64 -5640069336071256030, i64 12884901887, i64* getelementptr inbounds ([1 x i64], [1 x i64]* @__profc__stdin__foo, i32 0, i32 0), i8*
; CHECK-NOT: bitcast (i32 ()* @foo to i8*)
; CHECK-SAME: null
; CHECK-SAME: , i8* null, i32 1, [1 x i16] zeroinitializer }, section "__llvm_prf_data", comdat($__profv__stdin__foo), align 8
; CHECK: @__llvm_prf_nm = private constant [21 x i8] c"\0B\13x\DA\B3).I\C9\CC\B3\B3J\CB\CF\07\00\18a\04\1B", section "__llvm_prf_names"
; CHECK: @llvm.used = appending global [2 x i8*] [i8* bitcast ({ i64, i64, i64*, i8*, i8*, i32, [1 x i16] }* @__profd__stdin__foo to i8*), i8* getelementptr inbounds ([21 x i8], [21 x i8]* @__llvm_prf_nm, i32 0, i32 0)], section "llvm.metadata"

define internal i32 @foo() comdat {
entry:
  ret i32 1
}
