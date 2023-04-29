import 'package:cloudskillsboost_profile_validator/view/screens/home_screen.dart';
import 'package:cloudskillsboost_profile_validator/view/screens/result_screen.dart';
import 'package:get/get.dart';

class Routes {
  Routes._();

  static const home = '/home';
  static const result = '/result';

  static final List<GetPage> instance = [
    GetPage(name: home, page: () => const HomeScreen(), transition: Transition.native),
    GetPage(name: result, page: () => const ResultScreen(), transition: Transition.native)
  ];
}