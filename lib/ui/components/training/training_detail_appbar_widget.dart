import 'package:flutter/material.dart';

///AppBar Widget for the training session detail page.
class TrainingDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int heroTag;

  const TrainingDetailAppBar({super.key, required this.title, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Hero(
      tag: heroTag,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.inverseSurface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          forceMaterialTransparency: true,
          foregroundColor: colorScheme.onInverseSurface,
          title: Text(title),
          centerTitle: true,
          actions: [
            Visibility(
              visible: false, //TODO maybe implement edit function
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.check, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}