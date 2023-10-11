import 'package:ff_desktop/features/explore/explore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreViewModel>(
      builder: (BuildContext context, ExploreViewModel model, _) {
        return AnimatedSize(
          curve: Curves.easeOut,
          duration: FludaDuration.ms3,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: model.canBack
                    ? () {
                        model.back();
                      }
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: model.canForward
                    ? () {
                        model.forward();
                      }
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                onPressed: model.canUp
                    ? () {
                        model.up();
                      }
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  model.refresh();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
