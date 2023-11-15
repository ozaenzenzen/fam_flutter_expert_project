import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/presentation/pages/detail_page.dart';
import 'package:ditonton/presentation/widgets/app_image_widget.dart';
import 'package:flutter/material.dart';

class MovieList extends StatelessWidget {
  final List<IdPosterDataType> idAndPoster;

  MovieList(this.idAndPoster);

  factory MovieList.fromIdPosterTitleOverview(List<IdPosterTitleOverview> movies) {
    final idAndPoster = movies.map((e) => IdPosterDataType.fromIdPosterTitleOverview(e)).toList();
    return MovieList(idAndPoster);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  arguments: IdAndDataType.fromIdPosterDataType(idPoster),
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
