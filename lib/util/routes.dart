import 'package:cloudskillsboost_profile_validator/view/screens/home_screen.dart';
import 'package:cloudskillsboost_profile_validator/view/screens/result_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class Routes {
  Routes._();

  static const home = '/home';
  static const result = '/result';

  static final List<GetPage> instance = [
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: result, page: () => const ResultScreen())
  ];
}