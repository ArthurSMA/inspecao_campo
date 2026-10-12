import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/network/osrm_service.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/inspection_history_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/work_orders/domain/entities/work_order.dart';
import '../../features/work_orders/presentation/pages/inspection_form_page.dart';
import '../../features/work_orders/presentation/pages/work_orders_page.dart';

import 'app_shell_page.dart';
import 'auth_guard.dart';
import 'not_found_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this.authGuard});

  final AuthGuard authGuard;

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/login', page: LoginRoute.page),
    AutoRoute(
      path: '/app',
      page: AppShellRoute.page,
      guards: [authGuard],
      initial: true,
      children: [
        AutoRoute(path: 'home', page: HomeRoute.page, initial: true),
        AutoRoute(path: 'map', page: MapRoute.page),
        AutoRoute(path: 'work-orders', page: WorkOrdersRoute.page),
      ],
    ),
    AutoRoute(
      path: '/inspection-history',
      page: InspectionHistoryRoute.page,
      guards: [authGuard],
    ),
    AutoRoute(path: '/map', page: MapRoute.page, guards: [authGuard]),
    AutoRoute(
      path: '/work-orders/:workOrderId/inspection',
      page: InspectionFormRoute.page,
      guards: [authGuard],
    ),
    RedirectRoute(path: '/', redirectTo: '/app'),
    AutoRoute(path: '*', page: NotFoundRoute.page),
  ];
}
