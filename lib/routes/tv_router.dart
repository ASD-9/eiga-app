import 'package:eiga/views/tv/screens/movie_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter getTvRouter() {
  return GoRouter(
    initialLocation: "/movie/21",
    routes: [
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
