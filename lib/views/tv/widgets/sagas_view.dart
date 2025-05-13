// ignore_for_file: use_build_context_synchronously
import 'package:eiga/providers/movies_provider.dart';
import 'package:eiga/views/tv/widgets/movie_card.dart';
import 'package:eiga/views/tv/widgets/reload.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class SagasView extends StatefulWidget {
  final FocusNode firstMovieFocusNode;
  final ScrollController scrollController;

  const SagasView({
    super.key,
    required this.firstMovieFocusNode,
    required this.scrollController,
  });

  @override
  State<SagasView> createState() => _SagasViewState();
}

class _SagasViewState extends State<SagasView> {
  @override
  void initState() {
    super.initState();
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(
      context,
      listen: false,
    );
    Future.microtask(() => moviesProvider.fetchMoviesBySaga());
  }

  @override
  Widget build(BuildContext context) {
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);
    return moviesProvider.sagaIsLoading
        ? Center(
          child: LoadingAnimationWidget.beat(
            color: Theme.of(context).primaryColor,
            size: MediaQuery.of(context).size.width / 5,
          ),
        )
        : moviesProvider.sagaError != null
        ? Reload(
          onReload: () => moviesProvider.fetchMoviesBySaga(),
          error: moviesProvider.sagaError!,
        )
        : Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Text(
                "Films de la saga ${moviesProvider.selectedMovie!.saga!.name}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Expanded(
                child: ListView(
                  controller: widget.scrollController,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    moviesProvider.sagasMovies.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: MovieCard(
                        focusNode:
                            index == 0 ? widget.firstMovieFocusNode : null,
                        movie: moviesProvider.sagasMovies[index],
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width / 5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
