
import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget? xs;
  final Widget? child;
  final Widget? md;
  final Widget? lg;
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({this.xs, this.child, this.md, this.lg,
    required this.mobile,
    this.tablet,
    required this.desktop,
    Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //responsive
    final Size _size = MediaQuery.of(context).size;
    if (Responsive.isXS(context)) {
      if (xs != null) {
        return xs!;
      } else if (child != null) {
        return child!;
      }
    } else if (Responsive.isMD(context)) {
      if (md != null) {
        return md!;
      } else if (child != null) {
        return child!;
      } else if (xs != null) {
        return xs!;
      }
    } else if (Responsive.isLG(context)) {
      if (lg != null) {
        return lg!;
      } else if (child != null) {
        return child!;
      } else if (md != null) {
        return md!;
      } else if (xs != null) {
        return xs!;
      }
    }
    // If our width is more than 1100 then we consider it a desktop
    else if (_size.width >= 1100) {
      return desktop;
    }
    // If width it less then 1100 and more then 850 we consider it as tablet
    else if (_size.width >= 850 && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
    throw UnimplementedError(
        " Needs atleast one property to be set lg, xs,md, child");
  }

  static bool isXS(context) {
    return MediaQuery.of(context).size.width <= MediaQueryUtil.xs;
  }

  static bool isMD(context) {
    var size = MediaQuery.of(context).size.width;
    return size > MediaQueryUtil.xs && size <= MediaQueryUtil.md;
  }

  static bool isLG(context) {
    return !(isXS(context) && isMD(context));
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
          MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;


}

class MediaQueryUtil {
  static const xs = 576;
  static const md = 768;
  static const lg = 1200;
}
