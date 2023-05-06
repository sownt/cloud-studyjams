import 'dart:convert';
import 'dart:io';

class ConfigLoader {
  const ConfigLoader({
    this.path,
  });

  final String? path;

  dynamic get value async {
    final configs = jsonDecode(utf8.decode(await File(path!).readAsBytes()));
    configs['name'] as String;
    configs['start'] as String;
    configs['end'] as String;
    final section = configs['section'] as List;
    final type = configs['type'] as List;
    for (var s in section) {
      for (var t in type) {
        configs['quests'][s][t] as List;
      }
    }
    return configs;
  }
}
