import 'package:account_manager/misc.dart';
import 'package:account_manager/screens/auth/choose_bank.dart';
import 'package:account_manager/screens/auth/choose_custom_bank.dart';
import 'package:account_manager/screens/auth/choose_existing_bank.dart';
import 'package:account_manager/screens/auth/choose_vault.dart';
import 'package:account_manager/screens/auth/login_to_bank.dart';
import 'package:account_manager/screens/auth/register_in_bank.dart';
import 'package:account_manager/screens/home.dart';
import 'package:account_manager/screens/oauth/authorize.dart';
import 'package:account_manager/screens/welcome.dart';
import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: "/welcome",
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/oauth/authorize',
      builder: (context, state) => OauthAuthorizeScreen(queryParameters: state.uri.queryParameters),
    ),
    GoRoute(
        path: "/login",
        redirect: (context, state) => state.uri.path == "/login" ? "/login/choose_bank" : null,
        routes: [
          GoRoute(path: "/choose_bank", builder: (context, state) => const ChooseBankScreen(newAccount: false)),
          GoRoute(path: "/choose_custom_bank", builder: (context, state) => const ChooseCustomBankScreen(newAccount: false)),
          GoRoute(path: "/choose_existing_bank", builder: (context, state) => const ChooseExistingBankScreen(newAccount: false)),
          GoRoute(path: "/login_to_bank", builder: (context, state) => LoginToBankScreen(newAccount: false, bankId: state.uri.queryParameters['bank_id']!)),
          GoRoute(path: "/choose_vault", builder: (context, state) => ChooseVaultScreen(newAccount: false, bankId: state.uri.queryParameters['bank_id']!)),
        ]
    ),
    GoRoute(
        path: "/register",
        redirect: (context, state) => state.uri.path == "/register" ? "/register/use_vault" : null,
        routes: [
          GoRoute(path: "/choose_bank", builder: (context, state) => const ChooseBankScreen(newAccount: true)),
          GoRoute(path: "/choose_custom_bank", builder: (context, state) => const ChooseCustomBankScreen(newAccount: true)),
          GoRoute(path: "/choose_existing_bank", builder: (context, state) => const ChooseExistingBankScreen(newAccount: true)),
          GoRoute(path: "/register_in_bank", builder: (context, state) => RegisterInBankScreen(bankId: state.uri.queryParameters['bank_id']!)),
          GoRoute(path: "/login_to_bank", builder: (context, state) => LoginToBankScreen(newAccount: true, bankId: state.uri.queryParameters['bank_id']!)),
          GoRoute(path: "/choose_vault", builder: (context, state) => ChooseVaultScreen(newAccount: true, bankId: state.uri.queryParameters['bank_id']!)),
        ]
    ),
  ],
  redirect: (context, state) {
    final selectedAccount = Beshence.selectedAccount;
    final location = state.uri.toString();

    if (selectedAccount == null) {
      if (location != '/welcome' && !location.startsWith('/login') && !location.startsWith('/register')) {
        // preserve location
        redirectToAfterLoggingIn = location;
        return "/welcome";
      }
    } else {
      if (location == '/welcome') {
        return "/";
      }
    }

    if(location == "/login") return "/login/choose_bank";
    if(location == "/register") return "/register/choose_bank";

    return null;
  },
);