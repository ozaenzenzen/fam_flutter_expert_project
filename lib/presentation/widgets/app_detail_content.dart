import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/common/extension.dart';
import 'package:ditonton/domain/entities/genre_entity.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/poster_2_entity.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/pages/detail_page.dart';
import 'package:ditonton/presentation/widgets/app_image_widget.dart';
import 'package:ditonton/presentation/widgets/app_watchlist_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AppDetailContent extends StatelessWidget {
  final ItemDataEntity itemDataEntity;

  const AppDetailContent(this.itemDataEntity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppImageWidget(
          itemDataEntity.posterPath,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 56,
          ),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemDataEntity.title,
                              style: kHeading5,
                            ),
                            AppWatchlistButton(itemDataEntity),
                            Text(
                              _showGenres(itemDataEntity.genres),
                            ),
                            itemDataEntity.dataType == DataType.movie
                                ? Text(
                                    _showDuration(
                                      int.parse(itemDataEntity.runtime),
                                    ),
                                  )
                                : Text(
                                    itemDataEntity.runtime,
                                  ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: itemDataEntity.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return const Icon(
                                      Icons.star,
                                      color: kMikadoYellow,
                                    );
                                  },
                                  itemSize: 24,
                                ),
                                Text('${itemDataEntity.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              itemDataEntity.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            if (itemDataEntity.dataType == DataType.tvSeries) tvDetailSection() else movieDetailSection()
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget movieDetailSection() {
    return BlocConsumer<MovieDetailBloc, MovieDetailState>(
      listener: (context, state) {
        if (state is MovieDetailError) {
          context.dialog(state.message, state.retry);
        }
      },
      builder: (context, state) {
        if (state is MovieDetailLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MovieDetailSuccess) {
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final movies = state.recommendations[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        DetailPage.ROUTE_NAME,
                        arguments: Poster2Entity.fromPoster3Entity(movies),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: AppImageWidget(movies.poster),
                    ),
                  ),
                );
              },
              itemCount: state.recommendations.length,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget tvDetailSection() {
    return BlocConsumer<TvDetailBloc, TvDetailState>(
      listener: (context, state) {
        if (state is TvDetailError) {
          context.dialog(state.message, state.retry);
        }
      },
      builder: (context, state) {
        if (state is TvDetailLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvDetailSuccess) {
          return SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final poster3Entity = state.recommendations[index];
                return Container(
                  width: 120,
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        DetailPage.ROUTE_NAME,
                        arguments: Poster2Entity.fromPoster3Entity(
                          poster3Entity,
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: AppImageWidget(poster3Entity.poster),
                    ),
                  ),
                );
              },
              itemCount: state.recommendations.length,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  String _showGenres(List<GenreEntity> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
