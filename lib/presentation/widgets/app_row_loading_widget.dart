import 'package:flutter/material.dart';

class AppRowLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
