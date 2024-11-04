import 'package:final_project/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:final_project/view/auth_page.dart';
import 'package:final_project/services/authentication.dart';
import 'package:final_project/model/user.dart';
import 'package:final_project/model/category.dart';
import 'package:final_project/view/chat_page.dart';
import 'package:final_project/view_model/me_view_model.dart';
import 'package:final_project/view_model/message_vm.dart';
import 'package:final_project/view/start_page.dart';
final routerConfig = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/auth',
      pageBuilder: (context, state) =>
          const NoTransitionPage<void>(child: AuthPage()),
    ),
    ShellRoute(
      builder: (context, state, child) {
        final myId = Provider.of<AuthenticationService>(context, listen: false)
            .checkAndGetLoggedInUserId();
        //final myrole =;
        if (myId == null) {
          debugPrint('Warning: ShellRoute should not be built without a user');
          return const SizedBox.shrink();
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<MeViewModel>(
              create: (_) => MeViewModel(myId),
            ),
            ChangeNotifierProvider<AllMessagesViewModel>(
              create: (_) => AllMessagesViewModel(userID: myId),
            ),
          ],
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/select',
          pageBuilder: (context, state) {
            final meViewModel = Provider.of<MeViewModel>(context, listen: true);
            return NoTransitionPage<void>(
                child: StreamBuilder<User>(
              // Listen to the me state changes
              stream: meViewModel.meStream,
              builder: (context, snapshot){
                if (snapshot.connectionState != ConnectionState.active ||
                    snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  debugPrint('Error loading user data: ${snapshot.error}');
                  return const Center(
                    child: Text('Error loading user data'),
                  );
                }
                return StartPage();
              },
            ));
          },
        ),
        GoRoute(
          path: '/chat',
          pageBuilder: (context, state) {
            final meViewModel = Provider.of<MeViewModel>(context, listen: true);
            
            return NoTransitionPage<void>(
                child: StreamBuilder<User>(
              // Listen to the me state changes
              stream: meViewModel.meStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.active ||
                    snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  debugPrint('Error loading user data: ${snapshot.error}');
                  return const Center(
                    child: Text('Error loading user data'),
                  );
                }
                return ChatPage();
              },
            ));
          },
        ),
      ],
    ),
  ],
  initialLocation: '/chat',
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final currentPath = state.uri.path;
    final isLoggedIn =
        Provider.of<AuthenticationService>(context, listen: false)
                .checkAndGetLoggedInUserId() !=
            null;
    final UserRepository _userRepository = UserRepository();
    if(isLoggedIn){
      //bool firstLogin = true;
      if (currentPath == '/auth') {
        return '/select';
      }
      // if (currentPath == '/select') {
      //   return '/chat';
      // }
    }
    if (!isLoggedIn && currentPath != '/auth') {
      // Redirect to auth page if the user is not logged in
      return '/auth';
    }
    if (currentPath == '/') {
      return '/chat';
    }
    // No redirection needed for other routes
    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri.path}'),
    ),
  ),
);

class NavigationService {
  late final GoRouter _router;

  NavigationService() {
    _router = routerConfig;
  }

  void goToChatPage() {
    _router.go('/chat');
  }

  void goToAuthPage() {
    _router.go('/auth');
  }
  void goToStartPage(){
    _router.go('/select');
  }

  void pop(BuildContext context) {
    _router.pop(context);
  }
}
