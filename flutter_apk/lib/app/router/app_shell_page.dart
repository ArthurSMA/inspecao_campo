import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'app_router.dart';

@RoutePage()
class AppShellPage extends StatelessWidget {
  const AppShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [HomeRoute(), MapRoute(), WorkOrdersRoute()],
      bottomNavigationBuilder: (context, tabsRouter) {
        return NavigationBar(
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: tabsRouter.setActiveIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map_rounded),
              label: 'Mapa',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment_rounded),
              label: 'Serviços',
            ),
          ],
        );
      },
    );
  }
}
