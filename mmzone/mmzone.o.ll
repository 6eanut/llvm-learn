; ModuleID = 'mmzone.o.bc'
source_filename = "mm/mmzone.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.nodemask_t = type { [1 x i64] }
%struct.pglist_data = type { [4 x %struct.zone], [2 x %struct.zonelist], i32, i64, i64, i64, i32, %struct.wait_queue_head, %struct.wait_queue_head, ptr, i32, i32, i32, i32, i32, %struct.wait_queue_head, ptr, i64, i64, i64, [48 x i8], %struct.zone_padding, %struct.spinlock, %struct.lruvec, i64, [48 x i8], %struct.zone_padding, ptr, [32 x %struct.atomic64_t], [56 x i8] }
%struct.zone = type { [3 x i64], i64, i64, [4 x i64], i32, ptr, ptr, i64, %struct.atomic64_t, i64, i64, ptr, i32, [52 x i8], %struct.zone_padding, [11 x %struct.free_area], i64, %struct.spinlock, [28 x i8], %struct.zone_padding, i64, i64, [2 x i64], i64, i64, i32, i32, i32, i8, i8, [2 x i8], %struct.zone_padding, [12 x %struct.atomic64_t], [6 x %struct.atomic64_t], [48 x i8] }
%struct.atomic64_t = type { i64 }
%struct.free_area = type { [4 x %struct.list_head], i64 }
%struct.list_head = type { ptr, ptr }
%struct.zonelist = type { [257 x %struct.zoneref] }
%struct.zoneref = type { ptr, i32 }
%struct.wait_queue_head = type { %struct.spinlock, %struct.list_head }
%struct.spinlock = type { %union.anon }
%union.anon = type { %struct.raw_spinlock }
%struct.raw_spinlock = type { %struct.qspinlock }
%struct.qspinlock = type { %union.anon.0 }
%union.anon.0 = type { %struct.atomic_t }
%struct.atomic_t = type { i32 }
%struct.lruvec = type { [5 x %struct.list_head], %struct.zone_reclaim_stat, %struct.atomic64_t, i64 }
%struct.zone_reclaim_stat = type { [2 x i64], [2 x i64] }
%struct.zone_padding = type { [0 x i8] }

@node_data = external dso_local local_unnamed_addr global [0 x ptr], align 8
@node_states = external dso_local global [5 x %struct.nodemask_t], align 16

; Function Attrs: noredzone nounwind null_pointer_is_valid sspstrong
define dso_local ptr @first_online_pgdat() local_unnamed_addr #0 {
  %1 = tail call i64 @find_first_bit(ptr noundef nonnull getelementptr inbounds ([5 x %struct.nodemask_t], ptr @node_states, i64 0, i64 1), i64 noundef 64) #6
  %2 = trunc i64 %1 to i32
  %3 = tail call i32 @llvm.umin.i32(i32 %2, i32 64)
  %4 = zext nneg i32 %3 to i64
  %5 = getelementptr [0 x ptr], ptr @node_data, i64 0, i64 %4
  %6 = load ptr, ptr %5, align 8
  ret ptr %6
}

; Function Attrs: noredzone nounwind null_pointer_is_valid sspstrong
define dso_local ptr @next_online_pgdat(ptr nocapture noundef readonly %0) local_unnamed_addr #0 {
  %2 = getelementptr inbounds %struct.pglist_data, ptr %0, i64 0, i32 6
  %3 = load i32, ptr %2, align 64
  %4 = add i32 %3, 1
  %5 = sext i32 %4 to i64
  %6 = tail call i64 @find_next_bit(ptr noundef nonnull getelementptr inbounds ([5 x %struct.nodemask_t], ptr @node_states, i64 0, i64 1), i64 noundef 64, i64 noundef %5) #6
  %7 = and i64 %6, 4294967232
  %8 = icmp eq i64 %7, 0
  br i1 %8, label %9, label %13

9:                                                ; preds = %1
  %10 = and i64 %6, 63
  %11 = getelementptr [0 x ptr], ptr @node_data, i64 0, i64 %10
  %12 = load ptr, ptr %11, align 8
  br label %13

13:                                               ; preds = %1, %9
  %14 = phi ptr [ %12, %9 ], [ null, %1 ]
  ret ptr %14
}

; Function Attrs: noredzone nounwind null_pointer_is_valid sspstrong
define dso_local ptr @next_zone(ptr noundef readonly %0) local_unnamed_addr #0 {
  %2 = getelementptr inbounds %struct.zone, ptr %0, i64 0, i32 5
  %3 = load ptr, ptr %2, align 16
  %4 = getelementptr %struct.zone, ptr %3, i64 3
  %5 = icmp ugt ptr %4, %0
  br i1 %5, label %6, label %8

6:                                                ; preds = %1
  %7 = getelementptr %struct.zone, ptr %0, i64 1
  br label %20

8:                                                ; preds = %1
  %9 = getelementptr inbounds %struct.pglist_data, ptr %3, i64 0, i32 6
  %10 = load i32, ptr %9, align 64
  %11 = add i32 %10, 1
  %12 = sext i32 %11 to i64
  %13 = tail call i64 @find_next_bit(ptr noundef nonnull getelementptr inbounds ([5 x %struct.nodemask_t], ptr @node_states, i64 0, i64 1), i64 noundef 64, i64 noundef %12) #6
  %14 = and i64 %13, 4294967232
  %15 = icmp eq i64 %14, 0
  br i1 %15, label %16, label %20

16:                                               ; preds = %8
  %17 = and i64 %13, 63
  %18 = getelementptr [0 x ptr], ptr @node_data, i64 0, i64 %17
  %19 = load ptr, ptr %18, align 8
  br label %20

20:                                               ; preds = %16, %8, %6
  %21 = phi ptr [ %7, %6 ], [ %19, %16 ], [ null, %8 ]
  ret ptr %21
}

; Function Attrs: noredzone nounwind null_pointer_is_valid sspstrong
define dso_local ptr @__next_zones_zonelist(ptr noundef readonly %0, i32 noundef %1, ptr noundef %2) local_unnamed_addr #0 {
  %4 = icmp eq ptr %2, null
  br i1 %4, label %5, label %11, !prof !5

5:                                                ; preds = %3, %5
  %6 = phi ptr [ %10, %5 ], [ %0, %3 ]
  %7 = getelementptr inbounds %struct.zoneref, ptr %6, i64 0, i32 1
  %8 = load i32, ptr %7, align 8
  %9 = icmp ugt i32 %8, %1
  %10 = getelementptr %struct.zoneref, ptr %6, i64 1
  br i1 %9, label %5, label %28

11:                                               ; preds = %3, %26
  %12 = phi ptr [ %27, %26 ], [ %0, %3 ]
  %13 = getelementptr inbounds %struct.zoneref, ptr %12, i64 0, i32 1
  %14 = load i32, ptr %13, align 8
  %15 = icmp ugt i32 %14, %1
  br i1 %15, label %26, label %16

16:                                               ; preds = %11
  %17 = load ptr, ptr %12, align 8
  %18 = icmp eq ptr %17, null
  br i1 %18, label %28, label %19

19:                                               ; preds = %16
  %20 = getelementptr inbounds %struct.zone, ptr %17, i64 0, i32 4
  %21 = load i32, ptr %20, align 8
  %22 = sext i32 %21 to i64
  %23 = tail call i8 asm sideeffect " btq  $2,$1\0A\09/* output condition code c*/\0A", "={@ccc},*m,Ir,~{memory},~{dirflag},~{fpsr},~{flags}"(ptr nonnull elementtype(i64) %2, i64 %22) #7, !srcloc !6
  %24 = icmp ult i8 %23, 2
  tail call void @llvm.assume(i1 %24)
  %25 = icmp eq i8 %23, 0
  br i1 %25, label %26, label %28

26:                                               ; preds = %11, %19
  %27 = getelementptr %struct.zoneref, ptr %12, i64 1
  br label %11

28:                                               ; preds = %19, %16, %5
  %29 = phi ptr [ %6, %5 ], [ %12, %16 ], [ %12, %19 ]
  ret ptr %29
}

; Function Attrs: nofree norecurse noredzone nounwind null_pointer_is_valid sspstrong memory(argmem: readwrite, inaccessiblemem: readwrite)
define dso_local void @lruvec_init(ptr noundef %0) local_unnamed_addr #1 {
  %2 = getelementptr inbounds i8, ptr %0, i64 80
  tail call void @llvm.memset.p0.i64(ptr noundef align 8 dereferenceable(128) %2, i8 0, i64 48, i1 false)
  %3 = ptrtoint ptr %0 to i64
  store volatile i64 %3, ptr %0, align 8
  %4 = getelementptr [5 x %struct.list_head], ptr %0, i64 0, i64 0, i32 1
  store ptr %0, ptr %4, align 8
  %5 = getelementptr [5 x %struct.list_head], ptr %0, i64 0, i64 1
  %6 = ptrtoint ptr %5 to i64
  store volatile i64 %6, ptr %5, align 8
  %7 = getelementptr [5 x %struct.list_head], ptr %0, i64 0, i64 1, i32 1
  store ptr %5, ptr %7, align 8
  %8 = getelementptr [5 x %struct.list_head], ptr %0, i64 0, i64 2
  %9 = ptrtoint ptr %8 to i64
  store volatile i64 %9, ptr %8, align 8
  %10 = getelementptr [5 x %struct.list_head], ptr %0, i64 0, i64 2, i32 1
  store ptr %8, ptr %10, align 8
  %11 = getelementptr [5 x %struct.list_head], ptr %0, i64 0, i64 3
  %12 = ptrtoint ptr %11 to i64
  store volatile i64 %12, ptr %11, align 8
  %13 = getelementptr [5 x %struct.list_head], ptr %0, i64 0, i64 3, i32 1
  store ptr %11, ptr %13, align 8
  %14 = getelementptr [5 x %struct.list_head], ptr %0, i64 0, i64 4
  %15 = ptrtoint ptr %14 to i64
  store volatile i64 %15, ptr %14, align 8
  %16 = getelementptr [5 x %struct.list_head], ptr %0, i64 0, i64 4, i32 1
  store ptr %14, ptr %16, align 8
  ret void
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: noredzone null_pointer_is_valid
declare dso_local i64 @find_first_bit(ptr noundef, i64 noundef) local_unnamed_addr #3

; Function Attrs: noredzone null_pointer_is_valid
declare dso_local i64 @find_next_bit(ptr noundef, i64 noundef, i64 noundef) local_unnamed_addr #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #5

attributes #0 = { noredzone nounwind null_pointer_is_valid sspstrong "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+retpoline-external-thunk,+retpoline-indirect-branches,+retpoline-indirect-calls,-3dnow,-3dnowa,-aes,-avx,-avx10.1-256,-avx10.1-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512er,-avx512f,-avx512fp16,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-f16c,-fma,-fma4,-gfni,-kl,-mmx,-pclmul,-sha,-sha512,-sm3,-sm4,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-ssse3,-vaes,-vpclmulqdq,-widekl,-x87,-xop" "tune-cpu"="generic" "warn-stack-size"="2048" }
attributes #1 = { nofree norecurse noredzone nounwind null_pointer_is_valid sspstrong memory(argmem: readwrite, inaccessiblemem: readwrite) "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+retpoline-external-thunk,+retpoline-indirect-branches,+retpoline-indirect-calls,-3dnow,-3dnowa,-aes,-avx,-avx10.1-256,-avx10.1-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512er,-avx512f,-avx512fp16,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-f16c,-fma,-fma4,-gfni,-kl,-mmx,-pclmul,-sha,-sha512,-sm3,-sm4,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-ssse3,-vaes,-vpclmulqdq,-widekl,-x87,-xop" "tune-cpu"="generic" "warn-stack-size"="2048" }
attributes #2 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #3 = { noredzone null_pointer_is_valid "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+retpoline-external-thunk,+retpoline-indirect-branches,+retpoline-indirect-calls,-3dnow,-3dnowa,-aes,-avx,-avx10.1-256,-avx10.1-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512er,-avx512f,-avx512fp16,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-f16c,-fma,-fma4,-gfni,-kl,-mmx,-pclmul,-sha,-sha512,-sm3,-sm4,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-ssse3,-vaes,-vpclmulqdq,-widekl,-x87,-xop" "tune-cpu"="generic" }
attributes #4 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { noredzone nounwind }
attributes #7 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 2}
!1 = !{i32 1, !"Code Model", i32 2}
!2 = !{i32 1, !"override-stack-alignment", i32 8}
!3 = !{i32 4, !"SkipRaxSetup", i32 1}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = !{!"branch_weights", i32 1, i32 2000}
!6 = !{i64 2147858488, i64 2147858548}
