import 'package:dio/dio.dart';
import 'package:eiga/providers/movies_provider.dart';
import 'package:eiga/providers/profils_provider.dart';
import 'package:eiga/routes/app_router.dart';
import 'package:eiga/services/movies_service.dart';
import 'package:eiga/services/profils_service.dart';
import 'package:eiga/themes/app_theme.dart';
import 'package:eiga/utils/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  final Dio dio = DioClient.dio;

  final ProfilsService profilsService = ProfilsService(dio);
  final MoviesService moviesService = MoviesService(dio);

  GoRouter router = await getAppRouter();
  ThemeData theme = await getAppTheme();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfilsProvider>(
          create: (_) => ProfilsProvider(profilsService),
        ),
        ChangeNotifierProvider<MoviesProvider>(
          create: (_) => MoviesProvider(moviesService),
        ),
      ],
      child: MyApp(router: router, theme: theme),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  final ThemeData theme;

  const MyApp({super.key, required this.router, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: router,
    );
  }
}
