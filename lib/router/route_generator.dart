import 'package:flutter/material.dart';
import 'package:gide/core/base.dart';

import 'package:gide/core/constants/route_constants.dart';
import 'package:gide/core/models/credit_model.dart';
import 'package:gide/core/models/store_model.dart';
import 'package:gide/screens/home/page/credit_confirm.dart';
import 'package:gide/screens/home/page/qr_code_result.dart';
import 'package:gide/screens/home/page/qr_code_scan.dart';

// UIs
import 'package:gide/screens/place_locator/place_locator.dart';
import 'package:gide/screens/home/home.dart';
import 'package:gide/screens/auth/page/login_page.dart';
import 'package:gide/screens/auth/page/sign_up_page.dart';
import 'package:gide/screens/home/page/favorites.dart';
import 'package:gide/screens/home/page/profile.dart';
import 'package:gide/screens/home/page/new_main.dart';
import 'package:gide/screens/store/page/create_item.dart';
import 'package:gide/screens/store/page/create_store.dart';
import 'package:gide/screens/store/page/store_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeViewRoute:
        return MaterialPageRoute(
            builder: (_) => const Base(
                  key: Key("home_page"),
                ));
      case placeLocatorViewRoute:
        return MaterialPageRoute(builder: (_) => const PlaceLocator());
      case signUpRoute:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case favoritesRoute:
        return MaterialPageRoute(builder: (_) => const FavoritesPage());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case storeRoute:
        final store = settings.arguments as Store;
        return MaterialPageRoute(builder: (_) => StorePage(
          store: store,
        ));
      case createStoreRoute:
        return MaterialPageRoute(builder: (_) => const CreateStore());
      case mainRoute:
        return MaterialPageRoute(builder: (_) => MainPage());
      case createItemRoute:
        final store = settings.arguments as Store;
        return MaterialPageRoute(builder: (_) => CreateItem(
          store: store,
        ));
      case qrCodeResultRoute:
        final credit = settings.arguments as Credit;
        return MaterialPageRoute(
          builder: (_) => QRCodeResultPage(
            credit: credit,
          )
        );
      case qrCodeScannerRoute:
        return MaterialPageRoute(builder: (_) => const QRCodeScanner());
      case qrCodeConfirmationRoute:
        final credit = settings.arguments as Credit;
        return MaterialPageRoute(
          builder: (_) => CreditConfirm(
            credit: credit,
          )
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text("Unknown route. Check the route path again."),
        ),
      );
    });
  }
}
