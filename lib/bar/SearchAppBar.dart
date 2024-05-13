// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<bool> _isSearching = ValueNotifier(false);

  SearchAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isSearching,
      builder: (context, bool isSearching, _) {
        return AppBar(
          backgroundColor: const Color.fromARGB(255, 87, 42, 170),
          title: isSearching
              ? const TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search',
                  ),
                )
              : const Text('MYP'),
          actions: <Widget>[
            isSearching
                ? IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      _isSearching.value = false;
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _isSearching.value = true;
                    },
                  ),
          ],
        );
      },
    );
  }
}
