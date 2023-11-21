import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/widgets/app_error_widget.dart';
import 'package:ditonton/presentation/widgets/poster_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistPage extends StatelessWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/watchlist-movie';

  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<WatchlistBloc>().add(OnWatchlistDataRequested());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final watchlist = state.data[index];
                  return PosterItemWidget(watchlist);
                },
                itemCount: state.data.length,
              );
            } else if (state is WatchlistEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No watchlist yet, you can add some from list movie or serial tv',
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add Now'),
                    ),
                  ],
                ),
              );
            } else if (state is WatchlistError) {
              return Center(
                key: const Key('error_message'),
                child: AppErrorWidget(
                  state.message,
                  retry: state.retry,
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
