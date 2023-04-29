import 'dart:convert';

import 'package:cloudskillsboost_profile_validator/util/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _controller;
  FilePickerResult? filePickerResult;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 768),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/images/banner.png'),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: Text(filePickerResult?.files.first.name ?? 'Select your .html public profile'.tr),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: _select,
                  child: Text('Select file'.tr),
                ),
                const SizedBox(width: 16),
                ValueListenableBuilder(
                  valueListenable: _controller,
                  builder: (context, value, child) => ElevatedButton(
                    onPressed: value.text.isNotEmpty ? _submit : null,
                    child: Text('Submit'.tr),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text('Go to your public profile > Right-click > Save as (Ctrl + S) > Save to save it to your computer'.tr, style: const TextStyle(color: Colors.grey, fontSize: 12),)
          ],
        ),
      ),
    );
  }

  void _select() async {
    var picked = await FilePicker.platform.pickFiles();
    setState(() {
      filePickerResult = picked;
    });
    _controller.text = utf8.decode(picked?.files.first.bytes as List<int>);
  }

  void _submit() {
    Get.toNamed(
      Routes.result,
      arguments: _controller.text,
    );
  }
}
