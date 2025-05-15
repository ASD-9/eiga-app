// ignore_for_file: use_build_context_synchronously
import 'package:eiga/models/category_model.dart';
import 'package:eiga/models/movie_model.dart';
import 'package:eiga/providers/categories_provider.dart';
import 'package:eiga/providers/movies_provider.dart';
import 'package:eiga/themes/app_colors.dart';
import 'package:eiga/views/tv/widgets/focus_widget.dart';
import 'package:eiga/views/tv/widgets/main_layout.dart';
import 'package:eiga/views/tv/widgets/movie_card.dart';
import 'package:eiga/views/tv/widgets/reload.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  List<FocusNode> focusNodes = [];
  late FocusNode firstMovieFocusNode;

  int focusedIndex = 0;
  int selectedCategoryId = -1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final CategoriesProvider categoriesProvider =
          Provider.of<CategoriesProvider>(context, listen: false);
      await categoriesProvider.fetchCategories();
      focusNodes = List.generate(
        categoriesProvider.categories.length + 1,
        (index) => FocusNode(),
      );
      selectedCategoryId = categoriesProvider.categories[0].id;
      Provider.of<MoviesProvider>(
        context,
        listen: false,
      ).fetchMoviesByCategory(selectedCategoryId);
    });
    firstMovieFocusNode = FocusNode();
  }

  @override
  void dispose() {
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    firstMovieFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CategoriesProvider categoriesProvider =
        Provider.of<CategoriesProvider>(context);
    return categoriesProvider.isLoading || categoriesProvider.categories.isEmpty
        ? Scaffold(
          body: Center(
            child: LoadingAnimationWidget.beat(
              color: AppColors.primary,
              size: MediaQuery.of(context).size.width / 5,
            ),
          ),
        )
        : categoriesProvider.error != null
        ? Reload(
          error: categoriesProvider.error!,
          onReload: () => categoriesProvider.fetchCategories(),
        )
        : MainLayout(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: FocusWidget(
                    scaleRatio: 1,
                    onFocus: () => focusNodes[focusedIndex].requestFocus(),
                    child: ListView(
                      children: List.generate(
                        categoriesProvider.categories.length + 1,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: _buildCategoryItem(index - 1),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 3, child: _buildMoviesList()),
              ],
            ),
          ),
        );
  }

  Widget _buildCategoryItem(int index) {
    final CategoriesProvider categoriesProvider =
        Provider.of<CategoriesProvider>(context);
    CategoryModel category;
    if (index == -1) {
      category = CategoryModel(id: -1, name: "Tous");
      index = categoriesProvider.categories.length;
    } else {
      category = categoriesProvider.categories[index];
    }
    return FocusWidget(
      focusNode: focusNodes[index],
      autofocus: index == 0,
      scaleRatio: 1,
      focusedShadows: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: .6),
          blurRadius: 5,
          spreadRadius: 1,
        ),
      ],
      animationDuration: 0,
      borderRadius: 8,
      onFocus: () => setState(() => focusedIndex = index),
      onSelect: () {
        if (category.id != selectedCategoryId) {
          setState(() => selectedCategoryId = category.id);
          final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(
            context,
            listen: false,
          );
          if (category.id == -1) {
            moviesProvider.fetchMovies();
          } else {
            moviesProvider.fetchMoviesByCategory(category.id);
          }
          firstMovieFocusNode.requestFocus();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          category.name,
          style:
              selectedCategoryId == category.id
                  ? Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: AppColors.primary)
                  : Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildMoviesList() {
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);
    return moviesProvider.isLoading
        ? Center(
          child: LoadingAnimationWidget.beat(
            color: AppColors.primary,
            size: MediaQuery.of(context).size.width / 5,
          ),
        )
        : moviesProvider.error != null
        ? Reload(onReload: () {}, error: moviesProvider.error!)
        : Builder(
          builder: (context) {
            List<MovieModel> movies = [];
            if (selectedCategoryId == -1) {
              movies = moviesProvider.movies;
            } else {
              movies = moviesProvider.getMoviesByCategory(selectedCategoryId);
            }
            return GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisExtent: 250,
              ),
              children: List.generate(
                movies.length,
                (index) => MovieCard(
                  focusNode: index == 0 ? firstMovieFocusNode : null,
                  movie: movies[index],
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width / 7.5,
                  mustSetFocus: false,
                ),
              ),
            );
          },
        );
  }
}
