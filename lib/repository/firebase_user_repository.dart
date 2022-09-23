import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_profile/model/user_model.dart';

class FirebaseUserRepository {
  static Future<String> signup(UserModel user) async {
    var users = FirebaseFirestore.instance.collection('Users');
    var drf = await users.add(user.toMap());
    return drf.id;
  }

  static Future<UserModel?> findUserByUid(String? uid) async {
    var users = FirebaseFirestore.instance.collection('Users');
    var data = await users.where('uid', isEqualTo: uid).get();
    if (data.size == 0) {
      return null;
    } else {
      return UserModel.fromJson(data.docs[0].data(), data.docs[0].id);
    }
  }

  static void updateLastLoginDate(String? docId, DateTime time) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    users.doc(docId).update({'data_last_login': time});
  }
}
