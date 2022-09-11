import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home.export.dart';

final favoriteNotifier = StateNotifierProvider<FavoriteStateNotifier,
    AsyncValue<List<UniversityModel>>>((ref) {
  return FavoriteStateNotifier();
});

class FavoriteStateNotifier
    extends StateNotifier<AsyncValue<List<UniversityModel>>> {
  FavoriteStateNotifier() : super(const AsyncData([]));
  List<UniversityModel> favoriteList = [];

  Future addFavorite(UniversityModel universityModel) async {
    try {
      state = const AsyncLoading();
      await HomeRepositoriesImpl().addFavorite(universityModel);
      state = const AsyncData([]);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future getMyFavorites() async {
    favoriteList.clear() ;
    try {
      state = const AsyncLoading();
      QuerySnapshot querySnapshot =
          await HomeRepositoriesImpl().getMyFavorite();

      favoriteList = querySnapshot.docs
          .map(
              (e) => UniversityModel.fromJson(e.data() as Map<String, dynamic>))
          .toList();
      state = AsyncData(favoriteList);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future deleteByFavoritesID(String favoriteID) async {
    try {
      state = const AsyncLoading();
      await HomeRepositoriesImpl().deleteMyFavorite(favoriteID);
      final int index = favoriteList
          .indexWhere((element) => element.favoriteID == favoriteID);
      favoriteList.removeAt(index);
      state = AsyncData(favoriteList);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }
}
