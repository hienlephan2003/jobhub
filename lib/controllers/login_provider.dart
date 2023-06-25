import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/models/request/auth/login_model.dart';
import 'package:jobhub/models/request/auth/profile_update_model.dart';
import 'package:jobhub/models/request/auth/signup_model.dart';
import 'package:jobhub/services/helpers/auth_helper.dart';
import 'package:jobhub/services/helpers/notification_heloer.dart';
import 'package:jobhub/views/ui/auth/login.dart';
import 'package:jobhub/views/ui/auth/update_user.dart';
import 'package:jobhub/views/ui/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier extends ChangeNotifier {
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  set obscureText(bool newState) {
    _obscureText = newState;
    notifyListeners();
  }

  bool _firstTime = false;

  bool get firstTime => _firstTime;

  set firstTime(bool newState) {
    _obscureText = newState;
    notifyListeners();
  }

  bool? _entrypoint;

  bool get entrypoint => _entrypoint ?? false;

  set entrypoint(bool newState) {
    _entrypoint = newState;
    notifyListeners();
  }

  bool? _loggedIn;

  bool get loggedIn => _loggedIn ?? false;

  set loggedIn(bool newState) {
    _loggedIn = newState;
    notifyListeners();
  }

  final updateProfileFormKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    entrypoint = prefs.getBool('entrypoint') ?? false;
    loggedIn = prefs.getBool('loggedIn') ?? false;
  }

  validateAndSave() {
    final form = loginFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  validateUodateProfileAndSave() {
    final form = updateProfileFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  validateSignUpAndSave() {
    final form = signupFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  userLogin(LoginModel model) {
    AuthHelper.login(model).then((response) {
      if (response && firstTime) {
        Get.off(() => PersonalDetails());
        // Get.off(() => const MainScreen());
      } else if (response && !firstTime) {
        Get.offAll(() => const MainScreen());
      } else if (!response) {
        Get.snackbar("Sign Failed", "Please check your credential",
            colorText: Color(kLight.value),
            backgroundColor: Colors.red,
            icon: const Icon(Icons.add_alert));
      }
    });
  }

  updateProfile(ProfileUpdateReq req) {
    AuthHelper.updateProfile(req).then((res) {
      if (res) {
        Get.snackbar("Profile Updated", "Enjoy yor seacrhing for job",
            colorText: Color(kLight.value),
            backgroundColor: Color(kLightBlue.value),
            icon: const Icon(Icons.add_alert));
        Future.delayed(const Duration(seconds: 3)).then((value) {
          Get.offAll(() => const MainScreen());
        });
      } else {
        Get.snackbar("Profile Failed", "Please try again",
            colorText: Color(kLight.value),
            backgroundColor: Color(kOrange.value),
            icon: const Icon(Icons.add_alert));
      }
    });
  }

  userSignUp(SignupModel model) async {
    AuthHelper.signup(model).then((response) {
      if (response) {
        Get.off(() => const LoginPage(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } // Get.off(() => const MainScreen());
      else if (!response) {
        Get.snackbar("Sign up Failed", "Please check your credential",
            colorText: Color(kLight.value),
            backgroundColor: Colors.red,
            icon: const Icon(Icons.add_alert));
      }
    });
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    await prefs.remove('token');
    _firstTime = false;
  }
}
