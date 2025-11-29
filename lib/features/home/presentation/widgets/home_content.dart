import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_mock_section.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HomeMockSection(),
      ],
    );
  }
}
