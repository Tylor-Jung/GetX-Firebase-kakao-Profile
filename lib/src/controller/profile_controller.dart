import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:kakao_profile/model/user_model.dart';
import 'package:kakao_profile/repository/firebase_user_repository.dart';
import 'package:kakao_profile/repository/firestorage_reppository.dart';
import 'package:kakao_profile/src/controller/image_crop_controller.dart';

enum profileImageType { THUMBNAIL, BACKGROUND }

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();
  RxBool isEditMyProfile = false.obs;
  UserModel originMyProfile = UserModel();
  Rx<UserModel> myProfile = UserModel().obs;
  FirestorageRepository _firestorageRepository = FirestorageRepository();

  Future<void> authStateChanges(User? firebaseUser) async {
    if (firebaseUser != null) {
      UserModel? userModel =
          await FirebaseUserRepository.findUserByUid(firebaseUser.uid);
      if (userModel != null) {
        originMyProfile = userModel;
        FirebaseUserRepository.updateLastLoginDate(
            userModel.docId, DateTime.now());
      } else {
        originMyProfile = UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName,
          avatarUrl: firebaseUser.photoURL,
          createdTime: DateTime.now(),
          lastLoginTime: DateTime.now(),
        );
        String? docId = await FirebaseUserRepository.signup(originMyProfile);
        originMyProfile.docId = docId;
      }
    }
    myProfile(UserModel.clone(originMyProfile));
  }

  @override
  void onInit() {
    isEditMyProfile(false);
    super.onInit();
  }

  void rollback() {
    myProfile.value.initImageFile();
    myProfile(originMyProfile);
    toggleEditProfile();
  }

  void toggleEditProfile() {
    isEditMyProfile(!isEditMyProfile.value);
  }

  void updateName(String updateName) {
    myProfile.update((my) {
      my?.name = updateName;
    });
  }

  void updateDesciption(String updateDesciption) {
    myProfile.update((my) {
      my?.description = updateDesciption;
    });
  }

  void pickedImage(profileImageType type) async {
    if (isEditMyProfile.value) {
      File? file = await ImageCropController.to.selectImage(type);
      if (file == null) return;
      switch (type) {
        case profileImageType.THUMBNAIL:
          myProfile.update((my) {
            my?.avatarFile = file;
          });
          break;
        case profileImageType.BACKGROUND:
          myProfile.update((my) {
            my?.backgroundFile = file;
          });
          break;
      }
    }
  }

  void _updateProfileImageUrl(String downloadUrl) {
    originMyProfile.avatarUrl = downloadUrl;
    myProfile.update((user) => user!.avatarUrl = downloadUrl);
  }

  void _updateBackgroundImageUrl(String downloadUrl) {
    originMyProfile.backgroundUrl = downloadUrl;
    myProfile.update((user) => user!.backgroundUrl = downloadUrl);
  }

  void save() {
    originMyProfile = myProfile.value;

    if (originMyProfile.avatarFile != null) {
      UploadTask task = _firestorageRepository.uploadImageFile(
          originMyProfile.uid, "profile", originMyProfile.avatarFile);
      task.snapshotEvents.listen((event) async {
        if (event.bytesTransferred == event.totalBytes) {
          String? downloadUrl = await event.ref.getDownloadURL();
          _updateProfileImageUrl(downloadUrl);
          FirebaseUserRepository.updateImageUrl(
              originMyProfile.docId, downloadUrl, "avatar_url");
        }
      });
    }
    if (originMyProfile.backgroundFile != null) {
      UploadTask task = _firestorageRepository.uploadImageFile(
          originMyProfile.uid, "background", originMyProfile.backgroundFile);
      task.snapshotEvents.listen((event) async {
        if (event.bytesTransferred == event.totalBytes) {
          String downloadUrl = await event.ref.getDownloadURL();
          _updateBackgroundImageUrl(downloadUrl);
          FirebaseUserRepository.updateImageUrl(
              originMyProfile.docId, downloadUrl, "background_url");
        }
      });
    }

    FirebaseUserRepository.updateData(originMyProfile.docId, originMyProfile);
    toggleEditProfile();
  }
}
