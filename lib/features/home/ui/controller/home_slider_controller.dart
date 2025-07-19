import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:craft_bay/features/home/data/model/slider_model.dart';
import 'package:get/get.dart';

class HomeSliderController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;
  late String _message;

  String get message => _message;
  List<SliderModel> _sliderList = [];

  List<SliderModel> get getSliderList => _sliderList;

  Future<bool> getSlides() async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkClient>().getRequest(
      url: Urls.sliderUrl,
    );
    if (response.isSuccess) {
      List<SliderModel> list = [];
      for (Map<String, dynamic> slider
          in response.responseData!['data']['results']) {
        list.add(SliderModel.fromJson(slider));
      }
      _sliderList = list;
      _message = response.responseData!['msg'];
      isSuccess = true;
    } else {
      _message = response.errorMessage!;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
