import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../../../../core/core.export.dart';
import '../data.export.dart';

abstract class _AuthRepositories {
  Future<UserModel> registerUser(UserModel userModel);

  Future<UserModel> insertNewUser(UserModel userModel);

  Future<UserModel> loginByEmail(UserModel userModel);

  Future<UserModel> getUserFromUid(String id);
}

class AuthRepositoriesImpl implements _AuthRepositories {
  @override
  Future<UserModel> registerUser(UserModel userModel) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: userModel.password!,
      );

      userModel.uid = userCredential.user!.uid;

      return await insertNewUser(userModel);
    } on FirebaseAuthException catch (e) {
      //handle auth error
      if (e.code == "email-already-in-use") {
        return Future.error(
            'The email is used. Please use another email address.');
      } else if (e.code == "invalid-email") {
        return Future.error('البريد الالكتروني غير صحيح');
      } else if (e.code == "weak-password") {
        return Future.error(
            "The password is weak. The password must be at least 6 characters.");
      } else {
        return Future.error('An unknown error. Please try again later.');
      }
    } on PlatformException catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserModel> insertNewUser(UserModel userModel) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      await db
          .collection(FirebaseConfig.usersCollectionKey)
          .doc(userModel.uid)
          .set(userModel.toJson());

      return userModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> loginByEmail(UserModel userModel) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: userModel.email!, password: userModel.password!);


      return await getUserFromUid(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return Future.error('There is no record of this email.');
      }

      if (e.code == "invalid-email") {
        return Future.error('Invalid email');
      } else {
        return Future.error('Incorrect email address or password.');
      }
    }
  }

  @override
  Future<UserModel> getUserFromUid(String id) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await db.collection(FirebaseConfig.usersCollectionKey).doc(id).get();

    try {
      Map<String, dynamic>? map =
          documentSnapshot.data() as Map<String, dynamic>?;
      UserModel userApp = UserModel.fromJson(map!);
      return userApp;
    } on Exception catch (e) {
      throw e.toString();
    }
  }
}
