import 'package:eiga/views/tv/widgets/focus_widget.dart';
import 'package:flutter/material.dart';

class Reload extends StatelessWidget {
  final String error;
  final VoidCallback onReload;

  const Reload({super.key, required this.error, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error),
          const SizedBox(height: 10),
          FocusWidget(
            autofocus: true,
            onSelect: onReload,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.refresh),
              label: Text('Recharger'),
            ),
          ),
        ],
      ),
    );
  }
}
