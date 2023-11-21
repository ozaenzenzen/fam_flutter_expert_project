import 'package:flutter/material.dart';

class AppRowLoadingWidget extends StatelessWidget {
  const AppRowLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 210,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
