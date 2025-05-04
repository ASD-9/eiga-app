import 'package:eiga/themes/desktop_theme.dart';
import 'package:eiga/themes/mobile_theme.dart';
import 'package:eiga/themes/tv_theme.dart';
import 'package:eiga/utils/is_tv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

ThemeData getAppTheme() {
  if (kIsWeb) {
    return getDesktopTheme();
  } else if (isTv()) {
    return getTvTheme();
  } else {
    return getMobileTheme();
  }
}
