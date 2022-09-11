import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/core.export.dart';
import '../../home.export.dart';

final getUniversityNotifier = StateNotifierProvider<GetUniversityStateNotifier,
    AsyncValue<List<UniversityModel>>>((ref) {
  return GetUniversityStateNotifier();
});

final universityTypeProvider = StateProvider<UniversityType>(
  (ref) => UniversityType.jordan,
);

final selectedPagesProvider = StateProvider<int>(
      (ref) => 0,
);

class GetUniversityStateNotifier
    extends StateNotifier<AsyncValue<List<UniversityModel>>> {
  GetUniversityStateNotifier() : super(const AsyncData([]));
  List<UniversityModel> originalUniversitiesList = [];

  List<UniversityModel> filterUniversitiesList = [];

  Future getUniversitiesByType(UniversityType type) async {
    try {
      originalUniversitiesList.clear() ;
      filterUniversitiesList.clear() ;

      state = const AsyncLoading();
      final response = await HomeRepositoriesImpl().getUniversities(type);
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        originalUniversitiesList =
            list.map((e) => UniversityModel.fromJson(e)).toList();
        filterUniversitiesList.addAll(originalUniversitiesList);
        if(filterUniversitiesList.length > 20){
          List chunksList = [];
          chunksList = divideList(originalUniversitiesList , 15);
          filterUniversitiesList.clear();
          filterUniversitiesList.addAll(chunksList[0]);
        }
        state = AsyncValue.data(filterUniversitiesList);
      } else {
        state = AsyncValue.error(response.body);
      }
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  void searchUniversities(String nameUniversity) {
    filterUniversitiesList = originalUniversitiesList
        .where((element) =>
            element.name!.toLowerCase().contains(nameUniversity.toLowerCase()))
        .toList();

    state = AsyncValue.data(filterUniversitiesList);

  }

  void loadPage(int index){
    state = const AsyncLoading();
    List chunksList = [];
    chunksList = divideList(originalUniversitiesList , 15);
    filterUniversitiesList.clear();
    filterUniversitiesList.addAll(chunksList[index]);
    state = AsyncValue.data(filterUniversitiesList);
  }
}
