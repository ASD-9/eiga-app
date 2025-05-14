// ignore_for_file: use_build_context_synchronously
import 'package:eiga/models/movie_model.dart';
import 'package:eiga/providers/movies_provider.dart';
import 'package:eiga/themes/app_colors.dart';
import 'package:eiga/views/tv/widgets/main_layout.dart';
import 'package:eiga/views/tv/widgets/movie_card.dart';
import 'package:eiga/views/tv/widgets/reload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<MoviesProvider>(
            context,
            listen: false,
          ).fetchRandomMovies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);
    return moviesProvider.randomIsLoading || moviesProvider.randomMovies.isEmpty
        ? Scaffold(
          body: Center(
            child: LoadingAnimationWidget.beat(
              color: AppColors.primary,
              size: MediaQuery.of(context).size.width / 5,
            ),
          ),
        )
        : moviesProvider.randomError != null
        ? Scaffold(
          body: Reload(
            onReload: () => moviesProvider.fetchRandomMovies(),
            error: moviesProvider.randomError!,
          ),
        )
        : Builder(
          builder: (_) {
            MovieModel movie =
                moviesProvider.focusedMovie ?? moviesProvider.randomMovies[0];
            return MainLayout(
              body: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    '${dotenv.env["API_BASE_URL"]}/movies/images/${movie.imageName}',
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(.15),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 20,
                            children: [
                              Text(
                                movie.title,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              Text(
                                movie.synopsis,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 7,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 20,
                            children: [
                              Text(
                                "Suggestions",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Expanded(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(
                                    moviesProvider.randomMovies.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: MovieCard(
                                        movie:
                                            moviesProvider.randomMovies[index],
                                        height:
                                            MediaQuery.of(context).size.height /
                                            3,
                                        width:
                                            MediaQuery.of(context).size.width /
                                            7.5,
                                        autofocus: index == 0,
                                        mustShowTitle: false,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
  }
}
