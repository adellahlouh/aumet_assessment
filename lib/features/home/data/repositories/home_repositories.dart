import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/core.export.dart';
import 'package:http/http.dart' as http;
import '../data.export.dart';

abstract class _HomeRepositories {
  Future<http.Response> getUniversities(UniversityType universityType);

  Future addFavorite(UniversityModel universityModel);

  Future<QuerySnapshot> getMyFavorite();

  Future deleteMyFavorite(String favoriteID);
}

class HomeRepositoriesImpl implements _HomeRepositories {
  @override
  Future<http.Response> getUniversities(UniversityType universityType) async {
    final response = await http
        .get(Uri.parse(universityBaseUrl + universityType.name.toString()));

    return response;
  }

  @override
  Future addFavorite(UniversityModel universityModel) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      DocumentReference doc = db
          .collection(FirebaseConfig.favoriteCollectionKey)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseConfig.myFavoriteCollectionKey)
          .doc();

      universityModel.favoriteID = doc.id;

      await doc.set(universityModel.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<QuerySnapshot> getMyFavorite() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await db
          .collection(FirebaseConfig.favoriteCollectionKey)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseConfig.myFavoriteCollectionKey)
          .get();
      return querySnapshot;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future deleteMyFavorite(String favoriteID)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      DocumentReference doc = db
          .collection(FirebaseConfig.favoriteCollectionKey)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseConfig.myFavoriteCollectionKey)
          .doc(favoriteID);

      await doc.delete();
    } catch (e) {
      throw Exception(e.toString());
    }  }
}
