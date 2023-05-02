import 'package:cloudskillsboost_profile_validator/data/models/badge.dart';
import 'package:cloudskillsboost_profile_validator/util/gcp5.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String profile;

  @override
  void initState() {
    super.initState();
    try {
      profile = Get.arguments as String;
    } catch (e) {
      profile = '';
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 768) {
            return _buildNormalLayout();
          } else {
            return _buildWideLayout();
          }
        },
      ),
    );
  }

  Widget _buildNormalLayout() {
    return Center(
      child: Text('Unsupported screen size'.tr),
    );
  }

  Widget _buildWideLayout() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final response = snapshot.data ?? [];
          var skill = 0, regular = 0, count = 0;
          for (int i = 0; i < response.length; i++) {
            final item = response[i];
            if (item.earned.isAfter(GCP5.start) &&
                item.earned.isBefore(GCP5.end)) {
              if (GCP5.skill.contains(item.name)) {
                count++;
                skill++;
              } else if (GCP5.regular.contains(item.name)) {
                count++;
                regular++;
              }
            }
          }
          final tier1 = count >= 7 && skill >= 3;
          final tier2 = count >= 14 && skill >= 6;
          return SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 768),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Total: $count\tSkill Badges: $skill\tRegular Badges: $regular',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = response[index];
                        if ((GCP5.skill.contains(item.name) ||
                                GCP5.regular.contains(item.name)) &&
                            (item.earned.isAfter(GCP5.start) &&
                                item.earned.isBefore(GCP5.end))) {
                          return Row(
                            children: [
                              Text(item.name),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(GCP5.skill.contains(item.name)
                                  ? 'Skill'
                                  : 'Regular')
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Text(item.name),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                            ],
                          );
                        }
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: response.length,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: (tier1 && !tier2) ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tier 1'.tr,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 32),
                        Icon(
                          Icons.check_circle,
                          color: tier2 ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tier 2'.tr,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error'.tr),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
          // child: SizedBox(
          //   width: 120,
          //   height: 120,
          //   child: RiveAnimation.asset(
          //     'assets/rives/liquid_download.riv',
          //     stateMachines: ['Complete'],
          //   ),
          // ),
        );
      },
      future: fetch(profile),
    );
  }

  Future<List<Badge>?> fetch(String profile) async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      var document = parser.parse(profile);
      var badges = document.getElementsByClassName('profile-badge').map((e) {
        final name =
            e.getElementsByClassName('ql-subhead-1 l-mts')[0].text.trim();
        final date = e.getElementsByClassName('ql-body-2 l-mbs')[0].text.trim();
        var end = date.indexOf(' EDT');
        if (end == -1) end = date.indexOf(' EST');
        final sub = date.substring(7, end).replaceAll(RegExp(' +'), ' ');
        final datetime = DateFormat('MMM d, yyyy').parse(sub);
        return Badge(name: name, earned: datetime);
      });
      return badges.toList();
    } catch (e) {
      rethrow;
    }
  }
}
