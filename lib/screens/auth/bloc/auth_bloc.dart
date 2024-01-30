import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gide/core/models/user_model.dart' as self_module;
import 'package:gide/core/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {

    on<LoadAuth>((event, emit) async {
      // TODO: check if user is already logged in
      User? resUser = AuthenticationService.getCurrentUser();
      
      if (resUser != null) {
        self_module.User user = await AuthenticationService.setUserInfo();
          
        emit(AuthConfirmed(user: user));
      } else {
        emit(AuthMissing());
      }
    });

    on<LoginUser>((event, emit) async {
      if (state is AuthConfirmed) return;
      User? res = await AuthenticationService.loginWithEmailAndPassword(event.email, event.password);

      if (res == null) return;

      self_module.User user = self_module.User(
        id: res.uid,
        username: res.displayName ?? "",
        credits: const [],
        favoriteStores: const [],
        lastModified: Timestamp.now()
      );

      await AuthenticationService.setUserInfo();
      
      emit(AuthConfirmed(user: user));
    });

    on<RegisterUser>((event, emit) async {
      if (state is AuthConfirmed) return;
      User? res = await AuthenticationService.registerWithEmailAndPassword(event.email, event.password, event.username);

      if (res == null) return;

      self_module.User user = self_module.User(
        id: res.uid,
        username: res.displayName ?? "",
        credits: const [],
        favoriteStores: const [],
        lastModified: Timestamp.now()
      );

      await AuthenticationService.setUserInfo();

      emit(AuthConfirmed(user: user));
    });

    on<GoogleLoginUser>((event, emit) async {
      if (state is AuthConfirmed) return;

      User? res = await AuthenticationService.loginWithGoogle();
      if (res == null) return;

      // TODO: Update global user data
      self_module.User user = self_module.User(
        id: res.uid, 
        username: res.displayName!, // TODO: this needs to change
        credits: const [],
        favoriteStores: const [],
        lastModified: Timestamp.now()
      );

      await AuthenticationService.setUserInfo();

      emit(AuthConfirmed(user: user));
    });

    on<LogoutUser>((event, emit) async {
      AuthenticationService.firebaseLogout();
      emit(AuthMissing());
    });
  }
}
