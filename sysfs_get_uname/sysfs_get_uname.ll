; Function Attrs: mustprogress nofree norecurse noredzone nosync nounwind null_pointer_is_valid sspstrong willreturn memory(argmem: readwrite)
define dso_local noundef i64 @sysfs_get_uname(ptr nocapture noundef readonly %0, ptr nocapture noundef writeonly %1, i64 noundef %2) local_unnamed_addr #37 {
  %4 = add i64 %2, -32
  %5 = icmp ult i64 %4, -31
  br i1 %5, label %17, label %6

6:                                                ; preds = %3
  %7 = getelementptr i8, ptr %0, i64 %2
  %8 = getelementptr i8, ptr %7, i64 -1
  %9 = load i8, ptr %8, align 1
  %10 = icmp eq i8 %9, 10
  %11 = sext i1 %10 to i64
  %12 = add nsw i64 %11, %2
  %13 = icmp eq i64 %12, 0
  br i1 %13, label %15, label %14

14:                                               ; preds = %6
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %1, ptr align 1 %0, i64 %12, i1 false)
  br label %15

15:                                               ; preds = %14, %6
  %16 = getelementptr i8, ptr %1, i64 %12
  store i8 0, ptr %16, align 1
  br label %17

17:                                               ; preds = %3, %15
  %18 = phi i64 [ %2, %15 ], [ -22, %3 ]
  ret i64 %18
}
