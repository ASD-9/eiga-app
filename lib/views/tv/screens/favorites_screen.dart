import 'package:eiga/providers/movies_provider.dart';
import 'package:eiga/views/tv/widgets/main_layout.dart';
import 'package:eiga/views/tv/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);
    return MainLayout(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Text(
              "Ma liste de films",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisExtent: 250,
                ),
                children: List.generate(
                  moviesProvider.favoriteMovies.length,
                  (index) => MovieCard(
                    movie: moviesProvider.favoriteMovies[index],
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 7.5,
                    autofocus:
                        index == 0 &&
                        ModalRoute.of(context)!.settings.name == "/favorites",
                    mustSetFocus: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
