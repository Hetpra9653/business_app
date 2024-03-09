import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitialState()) {
    on<LoginEvent>(_handleLogin);
  }

  Future<void> _handleLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // Check if the authentication was successful
      if (userCredential.user != null) {
        emit(AuthSuccessState());
      } else {
        emit(AuthErrorState(error: 'Authentication failed'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(error: e.message ?? 'Authentication failed'));
    }
  }
}
