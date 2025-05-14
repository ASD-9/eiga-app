import 'package:eiga/models/movie_model.dart';
import 'package:eiga/providers/movies_provider.dart';
import 'package:eiga/themes/app_colors.dart';
import 'package:eiga/views/tv/widgets/focus_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final double height;
  final double width;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool mustShowTitle;

  const MovieCard({
    super.key,
    required this.movie,
    required this.height,
    required this.width,
    this.focusNode,
    this.autofocus = false,
    this.mustShowTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);
    return Column(
      children: [
        FocusWidget(
          focusNode: focusNode,
          autofocus: autofocus,
          animationDuration: 0,
          focusedBorder: Border.all(color: AppColors.primary, width: 3),
          scaleRatio: 1,
          onFocus: () {
            moviesProvider.setFocusedMovie(movie.id);
          },
          onSelect: () {
            if (moviesProvider.selectedMovie != null) {
              moviesProvider.clearSelectedMovie(mustAddToHistory: true);
              context.pushReplacement("/movie/${movie.id}");
            } else {
              context.push("/movie/${movie.id}");
            }
          },
          child: Column(
            children: [
              Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      '${dotenv.env["API_BASE_URL"]}/movies/images/${movie.imageName}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (mustShowTitle)
                Container(
                  width: width,
                  color: AppColors.background,
                  child: Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
