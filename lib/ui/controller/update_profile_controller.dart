import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../data/model/profile_details_model.dart';
import '../../data/model/user_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class UpdateProfileController extends GetxController {
  bool _isLoading = false;

  get isLoading => _isLoading;
  Logger _logger = Logger();

  Future<void> updateProfile({
    required Map<String, dynamic>? requestBody,
  }) async {
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );
    if (response.statusCode == 200) {
      await getProfileDetails();
    } else {
      _logger.e(response.errorMessage);
    }
  }

  Future<void> getProfileDetails() async {
    _isLoading = true;
    update();

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.profileDetailsUrl,
    );
    if (response.statusCode == 200) {
      String token = AuthController.token!;

      Map<String, dynamic> userDetailsMap = response.data!['data'][0];
      _logger.w(userDetailsMap);
      UpdateProfileModel updateProfileModel = UpdateProfileModel.fromJson(
        response.data!,
      );

      Map<String, dynamic> prepareJsonDataForInitiatingUserModel = {
        "_id": updateProfileModel.data.id,
        "email": updateProfileModel.data.email,
        "firstName": updateProfileModel.data.firstName,
        "lastName": updateProfileModel.data.lastName,
        "mobile": updateProfileModel.data.mobile,
        "createdDate": updateProfileModel.data.createdDate,
        "photo": updateProfileModel.data.photo,
      };
      UserModel userModel = UserModel.convertJsonToDart(
        prepareJsonDataForInitiatingUserModel,
      );
      await AuthController.saveUserInformation(token, userModel);
      await AuthController.getUserInformation();
    }
    _isLoading = false;
    update();
  }
}
