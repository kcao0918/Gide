import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gide/core/constants/route_constants.dart';
import 'package:gide/screens/auth/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "", _password = "";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Material(
      color: const Color(0xFFF6F6F6),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthConfirmed) {
            Navigator.of(context).pushNamed(homeViewRoute);
          }
        },
        child: BlocBuilder(bloc: BlocProvider.of<AuthBloc>(context), 
          builder: (context, state) {
            if (state is AuthConfirmed) return Container();

            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  color: const Color(0xFFF6F6F6),
                  child: Column(
                    children: [buildText(height, width), buildFields(height, width), buildButtons(height, width)],
                  )
                ),
              ),
            );
          },
        ),
      )
    );
  }

  Widget buildText(double height, double width) {
    return Column(children: [
      Padding(
          padding: EdgeInsets.only(top: height * 0.08),
          child: const Text('Welcome Back!', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800))),
      Padding(
        padding: EdgeInsets.only(top: height * 0.01125),
        child: const Text('You’ve been missed!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
      )
    ]);
  }

  Widget buildFields(double height, double width) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: height * 0.055),
          child: Container(
            width: width * .8444,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(12)),
                hintText: 'Enter a email...',
                hintStyle: const TextStyle(color: Color(0xFFC2C2C2), fontSize: 14),
              ),
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            )
          )
        ),
        Padding(
          padding: EdgeInsets.only(top: height * 0.05),
          child: Container(
            width: width * .8444,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                  borderRadius: BorderRadius.circular(12)
                ),
                hintText: 'Enter password...',
                hintStyle: const TextStyle(color: Color(0xFFC2C2C2), fontSize: 14),
              ),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            )
          )
        ),
      ],
    );
  }

  Widget buildButtons(double height, double width) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: height * 0.050),
          child: Container(
            width: width * .8444,
            height: height * .0837,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(LoginUser(email: _email, password: _password));
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF4670C1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )
              ),
              child: const Text('Sign in', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
            )
          )
        ),
        buildDivider(height, width),
        googleButton(height, width),
        Padding(
          padding: EdgeInsets.only(top: height * .0375),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Not a member? ',
              ),
              GestureDetector(
                child: const Text('Register here',
                  style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
                onTap: () async {
                  Navigator.of(context).pushNamed(signUpRoute);
                }
              )
            ],
          )
        )
      ],
    );
  }

  Widget buildDivider(double height, double width) {
    return Padding(
        padding: EdgeInsets.only(top: height * 0.050),
        child: Container(
            width: width * .756,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Expanded(
                child: Divider(
                  height: 10,
                  thickness: 1,
                  endIndent: width * .02,
                  color: Color(0xFFC2C2C2),
                ),
              ),
              const Text(
                'Or continue with',
                style: TextStyle(color: Color(0xFFC2C2C2), fontSize: 14),
              ),
              Expanded(
                child: Divider(
                  height: 10,
                  thickness: 1,
                  indent: width * .02,
                  color: const Color(0xFFC2C2C2),
                ),
              ),
            ])));
  }

  Widget googleButton(double height, double width) {
    return Padding(
      padding: EdgeInsets.only(top: height * .0375),
      child: Container(
        width: width * .16,
        height: height * .0837,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(GoogleLoginUser());
          },
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFFF6F6F6),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xFFC2C2C2), width: 1.1736824632845932),
              borderRadius: BorderRadius.circular(12),
            )
          ),
          child: SvgPicture.asset(
            'assets/icons/google.svg',
            width: 25,
            height: 25,
          )
        )
      )
    );
  }
}
