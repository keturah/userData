import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserDataNotifier with ChangeNotifier {
  UserData _currentLoggedInUserData;

  CollectionReference userDataRef = Firestore.instance.collection('userData');

  UserData get currentLoggedInUserData => _currentLoggedInUserData;

  Future getUserData() async {
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    try {
      DocumentSnapshot variable = await Firestore.instance
          .collection('userData')
          .document(userId)
          .get();

      _currentLoggedInUserData = UserData.fromMap(variable.data);
    } catch (e) {
      return e.message;
    }
    notifyListeners();
  }

  Future createOrUpdateUserData(UserData userData, bool isUpdating) async {
    String userId = (await FirebaseAuth.instance.currentUser()).uid;

    if (isUpdating) {
      userData.updatedAt = Timestamp.now();

      await userDataRef.document(userId).updateData(userData.toMap());
      print('updated userdata with id: ${userData.id}');
    } else {
      userData.createdAt = Timestamp.now();

      DocumentReference documentReference = userDataRef.document(userId);

      userData.id = documentReference.documentID;

      await documentReference.setData(userData.toMap(), merge: true);
      print('created userdata successfully with id: ${userData.id}');
    }
    notifyListeners();
  }
}
