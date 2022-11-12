import 'package:get/get.dart';

class SliderController extends GetxController {
  Rx<double> _value = 0.0.obs;

  double get value => _value.value;

  set value(double value) {
    _value.value = value;
  }
}
