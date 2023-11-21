import 'package:ditonton/domain/entities/poster_2_entity.dart';
import 'package:ditonton/domain/entities/poster_3_entity.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/presentation/pages/detail_page.dart';
import 'package:ditonton/presentation/widgets/app_image_widget.dart';
import 'package:flutter/material.dart';

class MovieList extends StatelessWidget {
  final List<Poster3Entity> listPoster3Entity;

  const MovieList(this.listPoster3Entity, {super.key});

  factory MovieList.fromPoster5Entity(List<Poster5Entity> movies) {
    final List<Poster3Entity> poster3entity = movies.map((e) => Poster3Entity.fromPoster5Entity(e)).toList();
    return MovieList(poster3entity);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listPoster3Entity.length,
        itemBuilder: (context, index) {
          final dataListPoster3Entity = listPoster3Entity[index];
          return Container(
            width: 140,
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DetailPage.ROUTE_NAME,
                  arguments: Poster2Entity.fromPoster3Entity(dataListPoster3Entity),
                );
              },
              child: AppImageWidget(dataListPoster3Entity.poster),
            ),
          );
        },
      ),
    );
  }
}
