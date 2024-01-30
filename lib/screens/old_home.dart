import 'package:firebase_auth/firebase_auth.dart' as firebase_auth_module;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gide/core/constants/colors_constants.dart';
import 'package:gide/screens/auth/bloc/auth_bloc.dart';
import 'package:gide/core/models/user_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool cond = true;

  
  void initState() {
    super.initState();
  }

  Widget _buildUserInfo(BuildContext context, User? user) {
    return (user != null)
        ? DecoratedBox(
            decoration: const BoxDecoration(color: Colors.black),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: CircleAvatar(
                      radius: 25,
                    ),
                  ),
                  // poppinsText(AuthProvider.getUser().displayName!, 18, FontWeight.w600),
                  // poppinsText(AuthProvider.getUser().email!, 11, FontWeight.w300),
                  Divider(height: 30)
                ],
              ),
            ),
          )
        : ListTile(
            leading: SvgPicture.asset(
              'assets/icons/drawer/user.svg',
              width: 25,
              height: 25,
            ), // TODO: need custom icons here
            title: const Text("Sign in"),
            onTap: () {
              // go to login page here
              context.read<AuthBloc>().add(GoogleLoginUser());
            },
          );
  }

  Widget _buildDrawer(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            User? user;

            if (state is AuthConfirmed) {
              user = state.user;
            }

            return ListView(
              children: [
                _buildUserInfo(context, user),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, String iconPath, double iconSize, Function onPressed) {
    return IconButton(
      onPressed: () => {onPressed()},
      iconSize: iconSize,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: SvgPicture.asset(iconPath),
    );
  }

  Widget _buildOverlayUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
      child: _buildIcon(context, 'assets/icons/hamburger-menu.svg', 30.0, () {
        // Open drawer
        _scaffoldKey.currentState!.openDrawer();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          _buildOverlayUI(context)
        ],
      ),
      backgroundColor: mainBackgroundColor,
    );
  }
}
