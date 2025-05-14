import 'package:eiga/models/profil_model.dart';
import 'package:eiga/providers/profils_provider.dart';
import 'package:eiga/themes/app_colors.dart';
import 'package:eiga/views/tv/widgets/focus_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatefulWidget {
  final Widget body;

  const MainLayout({super.key, required this.body});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedItem = 0;

  List navItems = [
    Icons.search,
    Icons.home_outlined,
    Icons.bookmark_outline_outlined,
    Icons.interests_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            width: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfilItem(),
                Column(
                  children: List.generate(
                    navItems.length,
                    (index) => _buildNavItem(index),
                  ),
                ),
                FocusWidget(
                  onSelect: () {}, // TODO: navigate to settings page
                  translationValue: 5,
                  focusedBorder: Border.all(color: AppColors.primary, width: 1),
                  focusedShadows: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                  borderRadius: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 5,
                    ),
                    child: Icon(
                      Icons.settings_outlined,
                      color: AppColors.textPrimary,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: widget.body),
        ],
      ),
    );
  }

  Widget _buildProfilItem() {
    final ProfilModel profil =
        Provider.of<ProfilsProvider>(context).selectedProfil!;
    return FocusWidget(
      onSelect: () => context.push("/profils"),
      translationValue: 3,
      focusedChild: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            "${dotenv.env['API_BASE_URL']}/avatars/${profil.avatar.imageName}",
          ),
        ),
      ),
      child: CircleAvatar(
        backgroundImage: NetworkImage(
          "${dotenv.env['API_BASE_URL']}/avatars/${profil.avatar.imageName}",
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = navItems[index];
    final isSelected = index == selectedItem;

    return FocusWidget(
      onSelect: () {
        setState(() {
          selectedItem = index;
        });
        // TODO: add navigation
      },
      translationValue: 5,
      focusedBorder: Border.all(color: AppColors.primary, width: 1),
      focusedShadows: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: .4),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
      borderRadius: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Icon(
          item,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          size: 30,
        ),
      ),
    );
  }
}
