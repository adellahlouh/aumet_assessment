import 'package:aumet_assessment/core/core.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data.export.dart';
import '../home_notifier/favorite_notifier.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final favoriteNotify = ref.watch(favoriteNotifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Screen'),
        centerTitle: true,
      ),
      body: favoriteNotify.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            itemBuilder: (_, index) {
              UniversityModel model = data[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                child: Container(
                  height: 32.0,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(
                        '${index + 1}) ${model.name}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const Spacer(),
                      favoriteNotify.when(data: (data) {
                        return IconButton(
                          onPressed: () => _onDeleteFav(model, ref),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        );
                      }, error: (error, s) {
                        return Text(error.toString());
                      }, loading: () {
                        return getCenterCircularProgress();
                      }),
                      const SizedBox(
                        width: 32.0,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        error: (error, s) {
          return Text(error.toString());
        },
        loading: () {
          return getCenterCircularProgress();
        },
      ),
    );
  }

  void _onDeleteFav(UniversityModel model, WidgetRef ref) {
    final favoriteNotify = ref.watch(favoriteNotifier.notifier);

    favoriteNotify.deleteByFavoritesID(model.favoriteID!);
  }
}
