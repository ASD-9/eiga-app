// ignore_for_file: use_build_context_synchronously
import 'package:eiga/providers/movies_provider.dart';
import 'package:eiga/themes/app_colors.dart';
import 'package:eiga/views/tv/widgets/focus_widget.dart';
import 'package:eiga/views/tv/widgets/reload.dart';
import 'package:eiga/views/tv/widgets/sagas_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MovieScreen extends StatefulWidget {
  final int id;

  const MovieScreen({super.key, required this.id});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late FocusScopeNode focusScopeNodeBaseView;
  List<FocusNode> focusNodesExpandView = [];
  late FocusNode firstSagaMovieFocusNode;

  late ScrollController sagaMoviesListController;

  bool isExpand = false;
  int selectedExpandView = 0;

  List buttons = [
    {"icon": Icons.play_arrow, "label": "Regarder", "action": () {}},
    {"icon": Icons.add, "label": "Ajouter à ma liste", "action": () {}},
    {"icon": Icons.ondemand_video, "label": "Trailer", "action": () {}},
  ];

  List bottomButtons = ["Détails", "Casting", "Saga"];

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MoviesProvider>(
        context,
        listen: false,
      ).fetchMovie(widget.id),
    );
    focusScopeNodeBaseView = FocusScopeNode();
    for (var i = 0; i < bottomButtons.length; i++) {
      focusNodesExpandView.add(FocusNode());
    }
    firstSagaMovieFocusNode = FocusNode();
    sagaMoviesListController = ScrollController();
  }

  @override
  void dispose() {
    focusScopeNodeBaseView.dispose();
    for (var focusNode in focusNodesExpandView) {
      focusNode.dispose();
    }
    firstSagaMovieFocusNode.dispose();
    sagaMoviesListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        moviesProvider.clearSelectedMovie();
        if (moviesProvider.selectedMoviesHistory.isNotEmpty) {
          context.pushReplacement(
            "/movie/${moviesProvider.selectedMoviesHistory.last}",
          );
          moviesProvider.selectedMoviesHistory.removeLast();
        } else {
          context.pop();
        }
      },
      child: Scaffold(
        body:
            moviesProvider.isLoading || moviesProvider.selectedMovie == null
                ? Center(
                  child: LoadingAnimationWidget.beat(
                    color: AppColors.primary,
                    size: MediaQuery.of(context).size.width / 5,
                  ),
                )
                : moviesProvider.error != null
                ? Reload(
                  onReload: () => moviesProvider.fetchMovie(widget.id),
                  error: moviesProvider.error!,
                )
                : Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      '${dotenv.env["API_BASE_URL"]}/movies/images/${moviesProvider.focusedMovie?.imageName ?? moviesProvider.selectedMovie!.imageName}',
                      fit: BoxFit.cover,
                      opacity: const AlwaysStoppedAnimation(.15),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 25,
                      ),
                      child: Column(
                        children: [
                          if (!isExpand) _buildBaseView(),
                          if (!isExpand) const Spacer(),
                          _buildBottomButtonsBar(),
                          if (isExpand) _buildExpandView(),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildBaseView() {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                moviesProvider.selectedMovie!.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "${moviesProvider.selectedMovie!.releaseDate!.year.toString()} • ${(moviesProvider.selectedMovie!.duration! ~/ 60)}h ${(moviesProvider.selectedMovie!.duration! % 60)}min • ${moviesProvider.selectedMovie!.categories!.map((e) => e.name).toList().join(", ")}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Text(
                moviesProvider.selectedMovie!.synopsis,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              FocusScope(
                node: focusScopeNodeBaseView,
                onKeyEvent: (_, event) {
                  if (event is KeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                      focusNodesExpandView[selectedExpandView].requestFocus();
                      setState(() => isExpand = true);
                    }
                  }
                  return KeyEventResult.ignored;
                },
                child: Row(
                  spacing: 20,
                  children: List.generate(
                    buttons.length,
                    (index) => _buildButton(index),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 50),
        Expanded(
          flex: 1,
          child: Image.network(
            '${dotenv.env["API_BASE_URL"]}/movies/images/${moviesProvider.selectedMovie!.imageName}',
            height: MediaQuery.of(context).size.height / 1.35,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(int index) {
    Map button = buttons[index];
    if (button["label"] == "Ajouter à ma liste" &&
        Provider.of<MoviesProvider>(context).isInFavorites(widget.id)) {
      button = {
        "icon": Icons.remove,
        "label": "Retirer de ma liste",
        "action": () {},
      };
    }
    return FocusWidget(
      autofocus: index == 0,
      onSelect: button["action"],
      focusedChild: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(button["icon"]),
        label: Text(button["label"]),
      ),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(button["icon"]),
        label: Text(button["label"]),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.textPrimary),
          foregroundColor: WidgetStatePropertyAll(AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildBottomButtonsBar() {
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);
    return FocusScope(
      onKeyEvent: (_, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            focusScopeNodeBaseView.requestFocus();
            setState(() => isExpand = false);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
              selectedExpandView == 2) {
            firstSagaMovieFocusNode.requestFocus();
          }
        }
        return KeyEventResult.ignored;
      },
      child: Row(
        spacing: 50,
        children: List.generate(
          moviesProvider.selectedMovie!.saga != null
              ? bottomButtons.length
              : bottomButtons.length - 1,
          (index) => _buildBottomButton(index),
        ),
      ),
    );
  }

  Widget _buildBottomButton(int index) {
    String label = bottomButtons[index];
    return FocusWidget(
      focusNode: focusNodesExpandView[index],
      onFocus: () => setState(() => selectedExpandView = index),
      focusedChild: TextButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.primary),
          foregroundColor: WidgetStatePropertyAll(AppColors.textPrimary),
        ),
        child: Text(label),
      ),
      child: TextButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor:
              index == selectedExpandView
                  ? WidgetStatePropertyAll(
                    AppColors.primary.withValues(alpha: .6),
                  )
                  : WidgetStatePropertyAll(Colors.transparent),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildExpandView() {
    if (selectedExpandView == 0) {
      return _buildDetailsView();
    } else if (selectedExpandView == 1) {
      return _buildCastingView();
    } else {
      return _buildSagaView();
    }
  }

  Widget _buildDetailsView() {
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              moviesProvider.selectedMovie!.synopsis,
              overflow: TextOverflow.ellipsis,
              maxLines: 10,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 10,
                  children: [
                    Text(
                      "Durée",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "Date de sortie",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "Nationalités",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "Catégorie",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      "${(moviesProvider.selectedMovie!.duration! ~/ 60)}h ${(moviesProvider.selectedMovie!.duration! % 60)}min",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "${(moviesProvider.selectedMovie!.releaseDate!.day).toString().padLeft(2, "0")}/${(moviesProvider.selectedMovie!.releaseDate!.month).toString().padLeft(2, "0")}/${moviesProvider.selectedMovie!.releaseDate!.year}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      moviesProvider.selectedMovie!.nationalities!
                          .map((e) => e.name)
                          .toList()
                          .join(", "),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      moviesProvider.selectedMovie!.categories!
                          .map((e) => e.name)
                          .toList()
                          .join(", "),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCastingView() {
    return Center(child: Text("CASTING"));
  }

  Widget _buildSagaView() {
    return Expanded(
      child: FocusScope(
        onKeyEvent: (_, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              focusNodesExpandView[selectedExpandView].requestFocus();
              sagaMoviesListController.animateTo(
                0,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
              Provider.of<MoviesProvider>(
                context,
                listen: false,
              ).setFocusedMovie(null);
            }
          }
          return KeyEventResult.ignored;
        },
        child: SagasView(
          firstMovieFocusNode: firstSagaMovieFocusNode,
          scrollController: sagaMoviesListController,
        ),
      ),
    );
  }
}
