import 'dart:io';

import 'package:get/get.dart';
import 'package:kakao_profile/model/user_model.dart';
import 'package:kakao_profile/src/controller/image_crop_controller.dart';

enum profileImageType { THUMBNAIL, BACKGROUND }

class ProfileController extends GetxController {
  RxBool isEditMyProfile = false.obs;
  UserModel originMyProfile = UserModel(
    name: '개빠',
    discription: '개발하는 아빠',
  );
  Rx<UserModel> myProfile = UserModel().obs;
  @override
  void onInit() {
    isEditMyProfile(false);
    myProfile(UserModel.clone(originMyProfile));
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
      my?.discription = updateDesciption;
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
            my?.backgroudFile = file;
          });
          break;
      }
    }
  }

  void save() {
    originMyProfile = myProfile.value;
    toggleEditProfile();
  }
}
