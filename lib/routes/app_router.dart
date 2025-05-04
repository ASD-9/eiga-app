import 'package:eiga/routes/desktop_router.dart';
import 'package:eiga/routes/mobile_router.dart';
import 'package:eiga/routes/tv_router.dart';
import 'package:eiga/utils/is_tv.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

Future<GoRouter> getAppRouter() async {
  if (kIsWeb) {
    return getDesktopRouter();
  } else if (await isTv()) {
    return getTvRouter();
  } else {
    return getMobileRouter();
  }
}
