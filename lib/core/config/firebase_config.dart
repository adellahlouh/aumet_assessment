import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {

  static const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: 'AIzaSyBLUS50i3iBYh6alPV3odTxqMAfPEoOQZQ',
    appId: '1:610688519045:web:481a22fc54017f24c012ec',
    messagingSenderId: 'G-BLW1RKCNFZ',
    projectId: 'aumet-assessment-335e0',
  );

  static const String usersCollectionKey = 'Users' ;
  static const String favoriteCollectionKey = 'Favorite' ;
  static const String myFavoriteCollectionKey = 'MyFavorite' ;
}