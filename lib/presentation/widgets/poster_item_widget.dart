import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/entities/poster_2_entity.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/presentation/pages/detail_page.dart';
import 'package:ditonton/presentation/widgets/app_image_widget.dart';
import 'package:flutter/material.dart';

class PosterItemWidget extends StatelessWidget {
  final Poster5Entity data;

  const PosterItemWidget(this.data, {super.key});

  factory PosterItemWidget.fromMovie(MovieEntity movie) => PosterItemWidget(Poster5Entity.fromMovie(movie));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailPage.ROUTE_NAME,
            arguments: Poster2Entity.from(data),
          );
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      data.overview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                child: AppImageWidget(
                  data.poster,
                  width: 80,
                  height: 120,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
