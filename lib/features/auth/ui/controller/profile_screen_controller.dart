import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:craft_bay/features/auth/data/model/profile_model.dart';
import 'package:get/get.dart';

class ProfileScreenController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  String _msg = '';

  String get message => _msg;

  late ProfileModel _profileModel;

  ProfileModel get profileModel => _profileModel;

  Future<bool> getProfileDetail() async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkClient>().getRequest(
      url: Urls.profileDetailUrl,
    );
    if (response.isSuccess) {
      _profileModel = ProfileModel.fromJson(response.responseData!['data']);
      _msg = response.responseData!['msg'];
      isSuccess = true;
    } else {
      _msg = response.errorMessage!;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
