import 'package:food/view/photo_edit_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:food/view/home.dart';
import 'package:food/view/photo_list_screen.dart';
import 'package:food/view/photo_detail_screen.dart';
import 'package:food/view/photo_add_screen.dart';

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      name: 'add',
      path: '/add',
      builder: (context, state) => PhotoAddScreen(),
    ),
    GoRoute(
      name: 'list',
      path: '/list',
      builder: (context, state) => PhotoListScreen(),
    ),
    GoRoute(
      name: 'about',
      path: '/about',
      builder: (context, state) => PhotoDetailScreen(),
    ),
    GoRoute(
      name: 'edit',
      path: '/edit',
      builder: (context, state) => PhotoEditScreen(),
    ),
  ],
);
