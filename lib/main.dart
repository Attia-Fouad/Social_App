import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/cubit/states.dart';
import 'package:social_app/modules/social_login/social_login_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/networks/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bloc_observer.dart';
import 'layout/social_layout.dart';
import 'modules/cubit/cubit.dart';
import 'modules/social_login/cubit/cubit.dart';
import 'modules/social_register/cubit/cubit.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId');
  Widget startWidget;
  bool? isDark = CacheHelper.getData(key: 'isDark');
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');




  // if (onBoarding != null) {
  //   if (uId != null) {
  //     startWidget = const SocialLayout();
  //   } else {
  //     startWidget = const SocialLoginScreen();
  //   }
  // } else {
  //   startWidget = const SocialLoginScreen();
  // }

  if (onBoarding == null) {
    if (uId != null) {
      startWidget = const SocialLayout();
    } else {
      startWidget = const SocialLoginScreen();
    }
  } else {
    startWidget = const SocialLoginScreen();
  }

  runApp( MyApp(
    startWidget:startWidget,
    isDark:isDark,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  Widget startWidget;
  MyApp({Key? key,
    this.isDark,
    required this.startWidget
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SocialCubit()..getUserData()..changeAppMode(fromShared: isDark)..getPosts()..getStory()),
        BlocProvider(create: (context) => SocialLoginCubit()),
        BlocProvider(create: (context) => SocialRegisterCubit()),
      ],
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, states) {},
        builder: (context, states) {
          var cubit=SocialCubit.get(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: cubit.isDark?ThemeMode.dark:ThemeMode.light,
            home:  startWidget,
          );
        },
      ),
    );

  }
}
