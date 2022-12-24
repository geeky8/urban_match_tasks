/// [Model] obejct consists of all necessary attributes of the reposiotry.
class Model {
  Model({
    required this.name,
    required this.starGazersCount,
    required this.forks,
    required this.onTap,
    required this.lastCommit,
  });

  factory Model.fromJson({required Map<String, dynamic> json}) {
    return Model(
      name: (json['name'] ?? '') as String,
      starGazersCount: (json['stargazers_count'] ?? 0) as int,
      forks: (json['forks'] ?? 0) as int,
      onTap: false,
      lastCommit: '',
    );
  }

  /// Update the [Model]
  Model copyWith({bool? onTap, String? lastCommit}) {
    return Model(
      name: name,
      starGazersCount: starGazersCount,
      forks: forks,
      onTap: onTap ?? this.onTap,
      lastCommit: lastCommit ?? this.lastCommit,
    );
  }

  /// Name of the repository
  final String name;

  /// No. of stars upon the repo
  final int starGazersCount;

  /// No. of forks on the repo
  final int forks;

  /// [bool] to check whether user tapped on the designated [ListTile]
  final bool onTap;

  /// Last commit of the repo
  final String lastCommit;
}
