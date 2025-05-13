import 'package:eiga/themes/app_colors.dart';
import 'package:eiga/views/tv/widgets/focus_widget.dart';
import 'package:flutter/material.dart';

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
                Image.asset(
                  "assets/images/logo.png",
                  width: 50,
                  height: 50,
                ), // TODO: to replace with profil's avatar pic
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
