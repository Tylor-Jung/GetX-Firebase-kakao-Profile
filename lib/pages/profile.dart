import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_profile/src/components/text_editor_widget.dart';
import 'package:kakao_profile/src/controller/image_crop_controller.dart';
import 'package:kakao_profile/src/controller/profile_controller.dart';

class Profile extends GetView<ProfileController> {
  const Profile({super.key});

  Widget _header() {
    return Positioned(
        top: Get.mediaQuery.padding.top, //디바이스 상단 노출 == Safearea 기능을 Get으로 대신 함
        right: 0,
        left: 0,
        child: Obx(
          () => Container(
            padding: EdgeInsets.all(15),
            child: controller.isEditMyProfile.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: controller.rollback,
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                            Text(
                              '프로필 편집',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.save,
                        child: Text(
                          '완료',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.close_sharp, color: Colors.white),
                      Row(
                        children: [
                          Icon(Icons.qr_code, color: Colors.white),
                          SizedBox(width: 10),
                          Icon(Icons.settings, color: Colors.white),
                        ],
                      )
                    ],
                  ),
          ),
        ));
  }

  Widget _backgroundImage() {
    return Positioned(
      top: 0,
      right: 0,
      bottom: 0,
      left: 0,
      child: GestureDetector(
        onTap: () {
          controller.pickedImage(profileImageType.BACKGROUND);
        },
        child: Obx(
          () => Opacity(
            opacity: 0.5,
            child: Container(
                color: Colors.transparent, //배경화면 투명
                child: controller.isEditMyProfile.value
                    ? _editBackgroundImageWidget()
                    : _backgroundImageWidget()),
          ),
        ),
      ),
    );
  }

  Widget _editBackgroundImageWidget() {
    return controller.myProfile.value.backgroundFile == null
        ? _backgroundImageWidget()
        : Image.file(
            controller.myProfile.value.backgroundFile!,
            fit: BoxFit.cover,
          );
  }

  Widget _backgroundImageWidget() {
    return controller.myProfile.value.backgroundUrl == null
        ? Container()
        : Image.network(
            controller.myProfile.value.backgroundUrl!,
            fit: BoxFit.cover,
          );
  }

  Widget _oneButton(IconData icon, String title, Function()? ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        child: Row(
          children: [
            Column(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _myProfile() {
    return Positioned(
      bottom: 120,
      left: 0,
      right: 0,
      child: Container(
          height: 220,
          child: Obx(
            () => Column(
              children: [
                _profileImage(),
                controller.isEditMyProfile.value
                    ? _editProfileInfo()
                    : _profileInfo(),
              ],
            ),
          )),
    );
  }

  Widget _editProfileImageWidget() {
    return controller.myProfile.value.avatarFile == null
        ? _profileImageWidget()
        : Image.file(
            controller.myProfile.value.avatarFile!,
            fit: BoxFit.cover,
          );
  }

  Widget _profileImageWidget() {
    return controller.myProfile.value.avatarUrl == null
        ? Image.network(
            'https://i.stack.imgur.com/l60Hf.png',
            fit: BoxFit.cover,
          )
        : Image.network(
            controller.myProfile.value.avatarUrl!,
            fit: BoxFit.cover,
          );
  }

  Widget _profileImage() {
    return GestureDetector(
      onTap: () {
        controller.pickedImage(profileImageType.THUMBNAIL);
      },
      child: Container(
          width: 120,
          height: 120,
          child: Stack(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                      width: 100,
                      height: 100,
                      child: controller.isEditMyProfile.value
                          ? _editProfileImageWidget()
                          : _profileImageWidget()),
                ),
              ),
              controller.isEditMyProfile.value
                  ? Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          )),
    );
  }

  Widget _profileInfo() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            controller.myProfile.value.name!,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ),
        Text(
          controller.myProfile.value.description!,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ],
    );
  }

  Widget _partProfileInfo(String value, Function()? ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Stack(
        children: [
          Container(
            height: 45,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.white),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 15,
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: 18,
            ),
          )
        ],
      ),
    );
  }

  Widget _editProfileInfo() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Obx(
          () => Column(
            children: [
              _partProfileInfo(controller.myProfile.value.name!, () async {
                String? value = await Get.dialog(TextEditorWidget(
                  text: controller.myProfile.value.name!,
                ));
                if (value != null) {
                  controller.updateName(value);
                }
              }),
              _partProfileInfo(controller.myProfile.value.description!,
                  () async {
                String? value = await Get.dialog(TextEditorWidget(
                  text: controller.myProfile.value.description!,
                ));
                if (value != null) {
                  controller.updateDesciption(value);
                }
              }),
            ],
          ),
        ));
  }

  Widget _footer() {
    return Obx(
      () => controller.isEditMyProfile.value
          ? Container()
          : Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _oneButton(Icons.chat_bubble, '나와의 채팅', () {}),
                    _oneButton(
                        Icons.edit, '프로필 편집', controller.toggleEditProfile),
                    _oneButton(Icons.chat_bubble_outline, '카카오 스토리', () {})
                  ],
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          children: [
            _backgroundImage(),
            _header(),
            _myProfile(),
            _footer(),
          ],
        ),
      ),
    );
  }
}
