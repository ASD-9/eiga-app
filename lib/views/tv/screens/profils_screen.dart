// ignore_for_file: use_build_context_synchronously
import 'package:eiga/models/profil_model.dart';
import 'package:eiga/providers/movies_provider.dart';
import 'package:eiga/providers/profils_provider.dart';
import 'package:eiga/themes/app_colors.dart';
import 'package:eiga/views/tv/widgets/focus_widget.dart';
import 'package:eiga/views/tv/widgets/reload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

Logger logger = Logger(printer: PrettyPrinter());

class ProfilsScreen extends StatefulWidget {
  const ProfilsScreen({super.key});

  @override
  State<ProfilsScreen> createState() => _ProfilsScreenState();
}

class _ProfilsScreenState extends State<ProfilsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ProfilsProvider>(
        context,
        listen: false,
      ).fetchProfils(17), // TODO: change with the real userId
    );
  }

  void selectProfil(int profilId) async {
    Provider.of<ProfilsProvider>(context, listen: false).selectedProfilId =
        profilId;
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(
      context,
      listen: false,
    );
    await moviesProvider.fetchFavorites(profilId);
    if (moviesProvider.favoritesError == null) {
      context.go("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProfilsProvider profilsProvider = Provider.of<ProfilsProvider>(
      context,
    );
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);
    return Scaffold(
      body:
          profilsProvider.isLoading || moviesProvider.favoritesIsLoading
              ? Center(
                child: LoadingAnimationWidget.beat(
                  color: AppColors.primary,
                  size: MediaQuery.of(context).size.width / 5,
                ),
              )
              : profilsProvider.error != null ||
                  moviesProvider.favoritesError != null
              ? Reload(
                error: moviesProvider.favoritesError ?? profilsProvider.error!,
                onReload:
                    () =>
                        moviesProvider.favoritesError != null
                            ? moviesProvider.fetchFavorites(
                              profilsProvider.selectedProfilId!,
                            )
                            : profilsProvider.fetchProfils(
                              17,
                            ), // TODO: change with the real userId
              )
              : Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.asset(
                    "assets/images/cover.jpg",
                    fit: BoxFit.cover,
                    opacity: AlwaysStoppedAnimation(.5),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 75),
                    child: Text(
                      "Qui regarde ?",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: List.generate(
                      profilsProvider.profils.length,
                      (index) => _buildProfilItem(
                        profilsProvider.profils[index],
                        index,
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildProfilItem(ProfilModel profil, int index) {
    return FocusWidget(
      autofocus: index == 0,
      onSelect: () => selectProfil(profil.id),
      focusedChild: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary,
                width: 3,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                "${dotenv.env['API_BASE_URL']}/avatars/${profil.avatar.imageName}",
              ),
              radius: 50,
            ),
          ),
          Text(profil.name, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              "${dotenv.env['API_BASE_URL']}/avatars/${profil.avatar.imageName}",
            ),
            radius: 50,
          ),
          Text(profil.name, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
