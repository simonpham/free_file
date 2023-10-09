import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

class MainPage extends StatelessWidget {
  static const String routePath = '/';

  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: Spacing.d64 * 4,
            child: const Center(
              child: Text('Sidebar'),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: Spacing.d32,
                  color: Colors.orange,
                  child: const Center(
                    child: Text('Tab Bar'),
                  ),
                ),
                Container(
                  height: Spacing.d36,
                  color: Colors.green,
                  child: Row(
                    children: [
                      SizedBox(
                        width: Spacing.d12 * 10,
                        child: const Center(
                          child: Text('Toolbar'),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.yellow,
                          child: const Center(
                            child: Text(
                              'Address Bar',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: Spacing.d320,
                        color: Colors.pink,
                        child: const Center(
                          child: Text('Search Bar'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: const Center(
                      child: Text('Main'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
