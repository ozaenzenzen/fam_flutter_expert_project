import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final Function? retry;

  const AppErrorWidget(this.message, {super.key, this.retry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          if (retry != null)
            ElevatedButton(
              onPressed: () {
                retry?.call();
              },
              child: const Text('Retry'),
            )
        ],
      ),
    );
  }
}
