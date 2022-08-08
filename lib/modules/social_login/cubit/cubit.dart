import 'package:flutter/material.dart';
import 'package:social_app/modules/social_login/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitialState());
  static SocialLoginCubit get(context) => BlocProvider.of(context);

  void userLogin( {
    required String email,
    required String password,
  }) {
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(SocialLoginSuccessState(value.user!.uid));
    }).catchError((error) {
      emit(SocialLoginErrorState(error.toString()));
    });
  }

  IconData suffix = IconBroken.Hide;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? IconBroken.Hide: IconBroken.Show;
    emit(SocialLoginChangePasswordVisibilityState());
  }

}