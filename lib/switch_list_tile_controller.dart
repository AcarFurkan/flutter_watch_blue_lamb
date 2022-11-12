import 'package:get/get.dart';

class SwitchController extends GetxController {
  Rx<bool> _switchIsOpen1 = false.obs;
  Rx<bool> _switchIsOpen2 = false.obs;
  Rx<bool> _switchIsOpen3 = false.obs;
  Rx<bool> _switchIsOpen4 = false.obs;
  Rx<bool> _switchIsOpen5 = false.obs;

  bool get switchIsOpen1 => _switchIsOpen1.value;

  set switchIsOpen1(bool value) {
    ///!value  ? Get.changeTheme(ThemeData.dark())  : Get.changeTheme(ThemeData.light());
    _switchIsOpen1.value = value;
  }

  bool get switchIsOpen2 => _switchIsOpen2.value;

  set switchIsOpen2(bool value) {
    _switchIsOpen2.value = value;
  }

  bool get switchIsOpen3 => _switchIsOpen3.value;

  set switchIsOpen3(bool value) {
    _switchIsOpen3.value = value;
  }

  bool get switchIsOpen4 => _switchIsOpen4.value;

  set switchIsOpen4(bool value) {
    _switchIsOpen4.value = value;
  }

  bool get switchIsOpen5 => _switchIsOpen5.value;

  set switchIsOpen5(bool value) {
    _switchIsOpen5.value = value;
  }
}
