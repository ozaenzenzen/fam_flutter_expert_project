import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/common/extension.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/widgets/detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final IdAndDataType idAndDataType;

  DetailPage({required this.idAndDataType});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.idAndDataType.dataType == DataType.Movie) {
      context.read<MovieDetailBloc>().add(
            OnMovieDetailDataRequested(widget.idAndDataType.id),
          );
    } else if (widget.idAndDataType.dataType == DataType.TvSeries) {
      context.read<TvDetailBloc>().add(
            OnTvDetailDataRequested(widget.idAndDataType.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.idAndDataType.dataType == DataType.TvSeries ? tvDetailSection() : movieDetailSection(),
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
          final movie = state.itemDataModel;
          return SafeArea(
            child: DetailContent(movie),
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
          final tv = state.itemDataModel;
          return SafeArea(
            child: DetailContent(tv),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
