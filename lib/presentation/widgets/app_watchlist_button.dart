import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/poster_2_entity.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppWatchlistButton extends StatelessWidget {
  final ItemDataEntity itemDataEntity;

  const AppWatchlistButton(this.itemDataEntity, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchlistStatusBloc, WatchlistStatusState>(
      listener: (context, state) {
        if (state is WatchlistStatusSuccess) {
          context.read<WatchlistBloc>().add(OnWatchlistDataRequested());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
              ),
            ),
          );
        } else if (state is WatchlistStatusError) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  state.message,
                ),
              );
            },
          );
        }
      },
      builder: (BuildContext context, state) {
        final poster2Entity = Poster2Entity(
          id: itemDataEntity.id,
          dataType: itemDataEntity.dataType,
        );
        context.read<WatchlistStatusBloc>().add(OnWatchlistStatusChecked(poster2Entity));

        return ElevatedButton(
          onPressed: () async {
            if (state is WatchlistStatusLoaded) {
              context.read<WatchlistStatusBloc>().add(state.isAdded ? OnWatchlistRemoved(poster2Entity) : OnWatchlistAdded(itemDataEntity));
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state is WatchlistStatusLoaded) state.isAdded ? const Icon(Icons.check) : const Icon(Icons.add),
              const Text('Watchlist'),
            ],
          ),
        );
      },
    );
  }
}
