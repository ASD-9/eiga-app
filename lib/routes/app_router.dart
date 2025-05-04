import 'package:eiga/routes/desktop_router.dart';
import 'package:eiga/routes/mobile_router.dart';
import 'package:eiga/routes/tv_router.dart';
import 'package:eiga/utils/is_tv.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

GoRouter getAppRouter() {
  if (kIsWeb) {
    return getDesktopRouter();
  } else if (isTv()) {
    return getTvRouter();
  } else {
    return getMobileRouter();
  }
}
