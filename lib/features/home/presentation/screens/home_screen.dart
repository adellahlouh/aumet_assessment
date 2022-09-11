import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/core.export.dart';
import '../../../features.export.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, ref) {
    final universityNotifier = ref.watch(getUniversityNotifier);
    final universityNotifierProvider =
        ref.watch(getUniversityNotifier.notifier);
    final favoriteNotify = ref.watch(favoriteNotifier);
    final selectedPageState = ref.watch(selectedPagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => _onFavorite(ref, context),
              icon: const Icon(Icons.favorite))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFieldWidget(
              controller: _searchController,
              hintText: 'Search',
              icon: const Icon(Icons.search),
              onChanged: (srt) => _onChangeSearch(srt, ref),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<UniversityType>(
                value: ref.watch(universityTypeProvider),
                onChanged: (value) => _onChangeDropDown(value!, ref),
                items: const [
                  DropdownMenuItem(
                    value: UniversityType.jordan,
                    child: Text(
                      'Jordan',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  DropdownMenuItem(
                    value: UniversityType.egypt,
                    child: Text(
                      'Egypt',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  DropdownMenuItem(
                    value: UniversityType.spain,
                    child: Text(
                      'Spain',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            universityNotifier.when(data: (data) {
              int itemCountPages =
                  universityNotifierProvider.originalUniversitiesList.length;

              return Column(
                children: [
                  if (universityNotifierProvider
                          .originalUniversitiesList.length >
                      20)
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                          itemCount: (itemCountPages / 15).ceil(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: MaterialButton(
                                  color: selectedPageState == index
                                      ? Colors.green
                                      : Colors.blue,
                                  onPressed: () => _onSelectedPage(index, ref),
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ListView.builder(
                      itemCount: data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        UniversityModel model = data[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 8.0),
                          child: Container(
                              height: 32.0,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Text(
                                    '${index + 1}) ${model.name}',
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  const Spacer(),
                                  favoriteNotify.when(data: (data) {
                                    return IconButton(
                                      onPressed: () => _onAddFav(model, ref),
                                      icon: const Icon(
                                        Icons.favorite_border,
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
                              )),
                        );
                      }),
                ],
              );
            }, error: (error, s) {
              return Text(error.toString());
            }, loading: () {
              return getCenterCircularProgress();
            })
          ],
        ),
      ),
    );
  }

  void _onChangeDropDown(
    UniversityType? value,
    WidgetRef ref,
  ) {
    ref.read(universityTypeProvider.notifier).state = value!;
    ref.read(selectedPagesProvider.notifier).state = 0;
    final homeNotifier = ref.read(getUniversityNotifier.notifier);
    homeNotifier
        .getUniversitiesByType(ref.read(universityTypeProvider.notifier).state);
    _searchController.text = '';
  }

  void _onFavorite(WidgetRef ref, BuildContext context) {
    final favoriteNotify = ref.watch(favoriteNotifier.notifier);
    favoriteNotify.getMyFavorites();
    openNewPage(context, const FavoriteScreen());
  }

  void _onChangeSearch(String srt, WidgetRef ref) {
    final universityNotifier = ref.watch(getUniversityNotifier.notifier);
    ref.read(selectedPagesProvider.notifier).state = 0;
    universityNotifier.searchUniversities(srt);
    if (srt.isEmpty) {
      universityNotifier.loadPage(0);
    }
  }

  void _onSelectedPage(int index, WidgetRef ref) {
    ref.read(selectedPagesProvider.notifier).state = index;
    final universityNotifier = ref.watch(getUniversityNotifier.notifier);
    universityNotifier.loadPage(index);
  }

  void _onAddFav(UniversityModel model, WidgetRef ref) {
    final favoriteNotify = ref.watch(favoriteNotifier.notifier);
    favoriteNotify.addFavorite(model);
  }
}
