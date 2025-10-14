enum Breakpoint { mobile, sm, md, lg, xl, x2l }

Breakpoint getBreakpoints(double width) {
  if (width < 500) return Breakpoint.mobile;
  if (width >= 500 && width < 640) return Breakpoint.sm;
  if (width >= 640 && width < 768) return Breakpoint.md;
  if (width >= 768 && width < 1024) return Breakpoint.lg;
  if (width >= 1024 && width < 1280) return Breakpoint.xl;
  return Breakpoint.x2l;
}
