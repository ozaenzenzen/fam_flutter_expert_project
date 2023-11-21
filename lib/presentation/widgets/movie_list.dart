import 'package:ditonton/domain/entities/poster_2_entity.dart';
import 'package:ditonton/domain/entities/poster_3_entity.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/presentation/pages/detail_page.dart';
import 'package:ditonton/presentation/widgets/app_image_widget.dart';
import 'package:flutter/material.dart';

class MovieList extends StatelessWidget {
  final List<Poster3Entity> idAndPoster;

  const MovieList(this.idAndPoster, {super.key});

  factory MovieList.fromPoster5Entity(List<Poster5Entity> movies) {
    final idAndPoster = movies.map((e) => Poster3Entity.fromPoster5Entity(e)).toList();
    return MovieList(idAndPoster);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: idAndPoster.length,
        itemBuilder: (context, index) {
          final idPoster = idAndPoster[index];
          return Container(
            width: 140,
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DetailPage.ROUTE_NAME,
                  arguments: Poster2Entity.fromPoster3Entity(idPoster),
                );
              },
              child: AppImageWidget(idPoster.poster),
            ),
          );
        },
      ),
    );
  }
}
