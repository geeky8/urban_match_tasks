import 'package:flutter/material.dart';
import 'package:task/constants.dart';
import 'package:task/loading_enum.dart';
import 'package:task/services.dart';

import 'model.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  List<Model> githubRepos = <Model>[];
  CurrentState state = CurrentState.SUCCESS;

  @override
  void initState() {
    _getRepos();
    super.initState();
  }

  _getRepos() async {
    final service = Services();
    setState(() {
      state = CurrentState.LOADING;
    });
    final res = await service.getGithubRepos();
    setState(() {
      state = CurrentState.SUCCESS;
      if (res != null) {
        githubRepos.addAll(res);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GitHub Repos',
          style: customTextStyle(
            fontSize: 18,
            weight: FontWeight.w500,
            isHeader: true,
          ),
        ),
        centerTitle: true,
      ),
      body: (state != CurrentState.LOADING)
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                child: ListView.builder(
                  itemCount: githubRepos.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        /// Display last commit only when user taps on [ListTile]
                        subtitle: (githubRepos[index].onTap)

                            /// User tapped and last commit has been fetched
                            ? (githubRepos[index].onTap &&
                                    githubRepos[index].lastCommit != '')
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      'Last Commit : ${githubRepos[index].lastCommit}',
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                    ),
                                  )

                                /// Showing progression of fetching last commit with [CircularProgressIndicator]
                                : const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  )
                            : const SizedBox(),

                        trailing: Icon(
                          (githubRepos[index].onTap)
                              ? Icons.arrow_drop_down
                              : Icons.arrow_right_outlined,
                          size: 20,
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                githubRepos[index].name,
                                style: customTextStyle(
                                  fontSize: 15,
                                  weight: FontWeight.w500,
                                ),
                                maxLines: 2,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.star,
                              color: Colors.amber[300],
                              size: 12,
                            ),
                            Text(
                              "${githubRepos[index].starGazersCount}",
                              style: customTextStyle(
                                fontSize: 15,
                                weight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.download,
                              color: Colors.blueAccent,
                              size: 14,
                            ),
                            Text(
                              "${githubRepos[index].forks}",
                              style: customTextStyle(
                                fontSize: 15,
                                weight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          /// Updating the to create opening and closing of a [ListTile].
                          final model = githubRepos[index]
                              .copyWith(onTap: !githubRepos[index].onTap);
                          setState(() {
                            githubRepos
                              ..removeAt(index)
                              ..insert(index, model);
                          });

                          /// Fetching the last commit of repository if not already fetched
                          if (model.onTap && model.lastCommit == '') {
                            final services = Services();
                            final currModel =
                                await services.fetchLastCommit(model: model);
                            setState(() {
                              githubRepos
                                ..removeAt(index)
                                ..insert(index, currModel);
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
