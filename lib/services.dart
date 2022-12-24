import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'model.dart';
import 'package:http/http.dart' as http;

class Services {
  final repoUrl = 'https://api.github.com/users/freeCodeCamp/repos';

  /// Fetch all the repos from the github account and maintain list of [Model]
  Future<List<Model>?> getGithubRepos() async {
    final response = await http.get(Uri.parse(repoUrl));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as List<dynamic>;
      final result = <Model>[];
      for (final element in body) {
        final model = Model.fromJson(json: element as Map<String, dynamic>);
        result.add(model);
      }
      return result;
    }
    return null;
  }

  /// Fetching the last commit and update the [Model]
  Future<Model> fetchLastCommit({required Model model}) async {
    final url =
        'https://api.github.com/repos/freeCodeCamp/${model.name}/commits';
    final response = await http.get(Uri.parse(url));
    debugPrint('.... resp ${response.body}');
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as List<dynamic>;
      debugPrint('--------- ${body[0]}');
      final json =
          (body[0] as Map<String, dynamic>)['commit'] as Map<String, dynamic>;
      model = model.copyWith(lastCommit: json['message'] as String);
    }
    return model;
  }
}
