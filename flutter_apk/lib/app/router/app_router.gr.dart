// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AppShellPage]
class AppShellRoute extends PageRouteInfo<void> {
  const AppShellRoute({List<PageRouteInfo>? children})
    : super(AppShellRoute.name, initialChildren: children);

  static const String name = 'AppShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AppShellPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [InspectionFormPage]
class InspectionFormRoute extends PageRouteInfo<InspectionFormRouteArgs> {
  InspectionFormRoute({
    Key? key,
    required WorkOrder workOrder,
    List<PageRouteInfo>? children,
  }) : super(
         InspectionFormRoute.name,
         args: InspectionFormRouteArgs(key: key, workOrder: workOrder),
         initialChildren: children,
       );

  static const String name = 'InspectionFormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InspectionFormRouteArgs>();
      return InspectionFormPage(key: args.key, workOrder: args.workOrder);
    },
  );
}

class InspectionFormRouteArgs {
  const InspectionFormRouteArgs({this.key, required this.workOrder});

  final Key? key;

  final WorkOrder workOrder;

  @override
  String toString() {
    return 'InspectionFormRouteArgs{key: $key, workOrder: $workOrder}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InspectionFormRouteArgs) return false;
    return key == other.key && workOrder == other.workOrder;
  }

  @override
  int get hashCode => key.hashCode ^ workOrder.hashCode;
}

/// generated route for
/// [InspectionHistoryPage]
class InspectionHistoryRoute extends PageRouteInfo<void> {
  const InspectionHistoryRoute({List<PageRouteInfo>? children})
    : super(InspectionHistoryRoute.name, initialChildren: children);

  static const String name = 'InspectionHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InspectionHistoryPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    void Function(bool)? onResult,
    List<PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () => const LoginRouteArgs(),
      );
      return LoginPage(key: args.key, onResult: args.onResult);
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, this.onResult});

  final Key? key;

  final void Function(bool)? onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [MapPage]
class MapRoute extends PageRouteInfo<MapRouteArgs> {
  MapRoute({Key? key, OsrmService? osrmService, List<PageRouteInfo>? children})
    : super(
        MapRoute.name,
        args: MapRouteArgs(key: key, osrmService: osrmService),
        initialChildren: children,
      );

  static const String name = 'MapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MapRouteArgs>(
        orElse: () => const MapRouteArgs(),
      );
      return MapPage(key: args.key, osrmService: args.osrmService);
    },
  );
}

class MapRouteArgs {
  const MapRouteArgs({this.key, this.osrmService});

  final Key? key;

  final OsrmService? osrmService;

  @override
  String toString() {
    return 'MapRouteArgs{key: $key, osrmService: $osrmService}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MapRouteArgs) return false;
    return key == other.key && osrmService == other.osrmService;
  }

  @override
  int get hashCode => key.hashCode ^ osrmService.hashCode;
}

/// generated route for
/// [NotFoundPage]
class NotFoundRoute extends PageRouteInfo<void> {
  const NotFoundRoute({List<PageRouteInfo>? children})
    : super(NotFoundRoute.name, initialChildren: children);

  static const String name = 'NotFoundRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotFoundPage();
    },
  );
}

/// generated route for
/// [WorkOrdersPage]
class WorkOrdersRoute extends PageRouteInfo<void> {
  const WorkOrdersRoute({List<PageRouteInfo>? children})
    : super(WorkOrdersRoute.name, initialChildren: children);

  static const String name = 'WorkOrdersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WorkOrdersPage();
    },
  );
}
