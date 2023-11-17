import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/common/extension.dart';
import 'package:ditonton/domain/entities/poster_2_entity.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/widgets/app_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final Poster2Entity poster2Entity;

  DetailPage({required this.poster2Entity});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.poster2Entity.dataType == DataType.Movie) {
      context.read<MovieDetailBloc>().add(
            OnMovieDetailDataRequested(widget.poster2Entity.id),
          );
    } else if (widget.poster2Entity.dataType == DataType.TvSeries) {
      context.read<TvDetailBloc>().add(
            OnTvDetailDataRequested(widget.poster2Entity.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.poster2Entity.dataType == DataType.TvSeries ? tvDetailSection() : movieDetailSection(),
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
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MovieDetailSuccess) {
          final movie = state.itemDataEntity;
          return SafeArea(
            child: AppDetailContent(movie),
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
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvDetailSuccess) {
          final tv = state.itemDataEntity;
          return SafeArea(
            child: AppDetailContent(tv),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
