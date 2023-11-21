import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';

class AppImageWidget extends StatelessWidget {
  final String posterPath;
  final double? width;
  final double? height;

  const AppImageWidget(
    this.posterPath, {
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(16),
      ),
      child: CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: '$baseImageUrl$posterPath',
        placeholder: (context, url) => SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
        ),
      ),
    );
  }
}
