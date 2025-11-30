import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/history/application/history_providers.dart';

/// Search bar for history page
class HistorySearchBar extends ConsumerStatefulWidget {
  const HistorySearchBar({super.key});

  @override
  ConsumerState<HistorySearchBar> createState() => _HistorySearchBarState();
}

class _HistorySearchBarState extends ConsumerState<HistorySearchBar> {
  final _controller = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (!_isExpanded) {
        _controller.clear();
        ref.read(historyControllerProvider.notifier).clearSearch();
      }
    });
  }

  void _onSearchChanged(String query) {
    ref.read(historyControllerProvider.notifier).setSearchQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isExpanded) {
      return IconButton(
        icon: const Icon(Icons.search),
        onPressed: _toggleSearch,
        tooltip: 'Buscar',
      );
    }

    return Expanded(
      child: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Buscar por nombre, ingrediente o alérgeno',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _toggleSearch,
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}
