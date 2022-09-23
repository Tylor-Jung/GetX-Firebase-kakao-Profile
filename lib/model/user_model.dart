import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid;
  String? docId;
  String? name;
  String? description;
  String? avatarUrl;
  String? backgroundUrl;
  File? avatarFile;
  File? backgroundFile;
  DateTime? lastLoginTime;
  DateTime? createdTime;

  UserModel({
    this.uid,
    this.docId,
    this.name = '',
    this.description = '',
    this.avatarUrl,
    this.backgroundUrl,
    this.lastLoginTime,
    this.createdTime,
  });

  UserModel.clone(UserModel user)
      : this(
          uid: user.uid,
          docId: user.docId,
          name: user.name,
          description: user.description,
          avatarUrl: user.avatarUrl,
          backgroundUrl: user.backgroundUrl,
          lastLoginTime: user.lastLoginTime,
          createdTime: user.createdTime,
        );

  void initImageFile() {
    avatarFile = null;
    backgroundFile = null;
  }

  UserModel.fromJson(Map<String, dynamic> json, String docId)
      : uid = json['uid'] as String,
        docId = docId,
        name = json['name'] as String,
        description = json['description'] as String,
        avatarUrl = json['avatar_url'] as String,
        backgroundUrl = json["background_url"],
        lastLoginTime = json['last_login_time'].toDate(),
        createdTime = json['created_time'].toDate();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'avatar_url': avatarUrl,
      'background_url': backgroundUrl,
      'last_login_time': lastLoginTime,
      'created_time': createdTime,
    };
  }
}
