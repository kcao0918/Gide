import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:gide/core/constants/route_constants.dart';
import 'package:gide/core/models/credit_model.dart';
import 'package:gide/screens/home/page/credits.dart';
import 'package:gide/screens/home/page/favorites.dart';
import 'package:gide/screens/home/page/new_main.dart';
import 'package:gide/screens/home/page/profile.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gide/screens/auth/bloc/auth_bloc.dart';
import 'package:gide/screens/store/page/create_store.dart';
import 'package:gide/screens/store/page/create_item.dart';

enum Page {
  home,
  notifications,
  favorites,
  profile
}

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final PageController _pageController = PageController(initialPage: 0);
  final Color _activeColor = const Color(0xFF4670C1);
  final Color _disableColor = Colors.black45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _createHomePage(),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pushNamed(placeLocatorViewRoute);
        },
        child: SvgPicture.asset(
          'assets/icons/navbar/pin-svgrepo-com 1.svg'
        ),
      ),
      bottomNavigationBar: _createBottomNavigationBar()
    );
  }

  Widget _createBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      elevation: 0,
      notchMargin: 15,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  _pageController.animateToPage(
                    Page.home.index, 
                    duration: const Duration(milliseconds: 500), 
                    curve: Curves.ease
                  );
                }, 
                icon: SvgPicture.asset(
                  'assets/icons/navbar/home-svgrepo-com 1.svg',
                  color: (_currentIndex == Page.home.index) ? _activeColor :_disableColor,
                )
              ),
              IconButton(
                onPressed: () {
                  _pageController.animateToPage(
                    Page.notifications.index, 
                    duration: const Duration(milliseconds: 500), 
                    curve: Curves.ease
                  );
                }, 
                icon: SvgPicture.asset(
                  'assets/icons/navbar/bell.svg',
                  color: (_currentIndex == Page.notifications.index) ?_activeColor : _disableColor,
                )
              ),
              Container(width: MediaQuery.of(context).size.width * 0.2),
              IconButton(
                onPressed: () {
                  _pageController.animateToPage(
                    Page.favorites.index, 
                    duration: const Duration(milliseconds: 500), 
                    curve: Curves.ease
                  );
                }, 
                icon: SvgPicture.asset(
                  'assets/icons/navbar/bookmark.svg',
                  color: (_currentIndex == Page.favorites.index) ? _activeColor: _disableColor,
                )
              ),
              IconButton(
                onPressed: () {
                  _pageController.animateToPage(
                    Page.profile.index, 
                    duration: const Duration(milliseconds: 500), 
                    curve: Curves.ease
                  );
                }, 
                icon: SvgPicture.asset(
                  'assets/icons/navbar/person.svg',
                  color: (_currentIndex == Page.profile.index) ? _activeColor :_disableColor,
                )
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget _createHomePage() {
    return SafeArea(
      bottom: false,
      child: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        children: [
          MainPage(),
          // GreenScreen(),
          CreditsPage(),
          //CreateItem(),
          FavoritesPage(),
          ProfilePage(),
          // YellowScreen()
        ],
      ),
    );
  }
}

class BlueScreen extends StatelessWidget {
  const BlueScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red
    );
  }
}

class RedScreen extends StatelessWidget {
  const RedScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue
    );
  }
}

class GreenScreen extends StatelessWidget {
  const GreenScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green
    );
  }
}

class YellowScreen extends StatelessWidget {
  YellowScreen({ Key? key }) : super(key: key);

  final geo = Geoflutterfire();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: IconButton(icon: Icon(Icons.logout), onPressed: () {

        // TODO finish this
        // Credit credit = Credit(
        //   id: const Uuid().v4(), 
        //   expireDate: Timestamp.fromDate(DateTime(2022, 6, 2)), 
        //   storeId: "3f6b5aa0-a14f-45d3-aff2-79a59b73bbca", 
        //   amtOff: 0.5
        // );

        // Store store = Store(
        //   id: const Uuid().v4(),
        //   name: "Food Plus Supermarket",
        //   description: "Food",
        //   ownerId: AuthenticationService.getCurrentUser()!.uid,
        //   location: geo.point(latitude: 40.75342280139386, longitude: -73.82239825669403)
        // );

        // StoreSerice.updateStore(store);
        context.read<AuthBloc>().add(LogoutUser());
      },),
    );
  }
}