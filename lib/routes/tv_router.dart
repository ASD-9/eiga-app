import 'package:eiga/views/tv/screens/home_screen.dart';
import 'package:eiga/views/tv/screens/movie_screen.dart';
import 'package:eiga/views/tv/screens/profils_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter getTvRouter() {
  return GoRouter(
    initialLocation: "/profils",
    routes: [
      GoRoute(path: "/home", builder: (context, state) => HomeScreen()),
      GoRoute(path: "/profils", builder: (context, state) => ProfilsScreen()),
      GoRoute(
        path: "/movie/:movieId",
        pageBuilder: (context, state) {
          String movieId = state.pathParameters["movieId"]!;
          return MaterialPage(
            key: ValueKey(movieId),
            child: MovieScreen(id: int.parse(movieId)),
          );
        },
      ),
    ],
  );
}
