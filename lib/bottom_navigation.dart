// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'squat.dart';

enum BottomNavigationDemoType {
  withLabels,
  withoutLabels,
}

class BottomNavigationDemo extends StatefulWidget {
  const BottomNavigationDemo({Key key, @required this.type}) : super(key: key);

  final BottomNavigationDemoType type;

  @override
  _BottomNavigationDemoState createState() => _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    var bottomNavigationBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.accessible_forward),
        title: Text('Workout'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.account_circle),
        title: Text('Account'),
      ),
    ];


    return Scaffold(
      body: Center(
        child: PageTransitionSwitcher(
          child: _currentIndex == 0 ? SquatWidget() :  _NavigationDestinationView(
            // Adding [UniqueKey] to make sure the widget rebuilds when transitioning.
            key: UniqueKey(),
            item: bottomNavigationBarItems[_currentIndex],
          ),
          transitionBuilder: (child, animation, secondaryAnimation) {
            return FadeThroughTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels:
            widget.type == BottomNavigationDemoType.withLabels,
        items: bottomNavigationBarItems,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: textTheme.caption.fontSize,
        unselectedFontSize: textTheme.caption.fontSize,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: colorScheme.onPrimary,
        unselectedItemColor: colorScheme.onPrimary.withOpacity(0.38),
        backgroundColor: colorScheme.primary,
      ),
    );
  }
}

class _NavigationDestinationView extends StatelessWidget {
  _NavigationDestinationView({Key key, this.item}) : super(key: key);

  final BottomNavigationBarItem item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExcludeSemantics(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/polly-bg.jpg',
                ),
              ),
            ),
          ),
        ),
        Center(
          child: IconTheme(
            data: const IconThemeData(
              color: Colors.white,
              size: 80,
            ),
            child: Semantics(
              label: 'Theme?',
              child: item.icon,
            ),
          ),
        ),
      ],
    );
  }
}
