import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/networks/local/cache_helper.dart';
import '../../shared/styles/icon_broken.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../edit_password/edit_password_screen.dart';
import '../edit_profile/edit_profile_screen.dart';
import '../social_login/social_login_screen.dart';

class SettingsScreen extends StatelessWidget {

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit=SocialCubit.get(context);
        var color=cubit.isDark?Colors.white:Colors.black;
        return  Scaffold(
          appBar: AppBar(
            title: const Text(
                'Settings'
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    navigateTo(context, const EditProfileScreen());                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding:  const EdgeInsets.all(8.0),
                      child: Row(
                        children:  [
                          Icon(
                            IconBroken.Edit,
                            color: color,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 20,
                              color: cubit.isDark?Colors.white:Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Icon(IconBroken.Arrow___Right_2,
                            color: cubit.isDark?Colors.white:Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                fullDivider(),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    navigateTo(context, const EditPasswordScreen());
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding:  const EdgeInsets.all(8.0),
                      child: Row(
                        children:  [
                          Icon(
                            IconBroken.Unlock,
                            color: cubit.isDark?Colors.white:Colors.black,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Edit Password',
                            style: TextStyle(
                              fontSize: 20,
                              color: cubit.isDark?Colors.white:Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Icon(IconBroken.Arrow___Right_2,
                            color: cubit.isDark?Colors.white:Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                fullDivider(),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: (){
                    cubit.changeAppMode();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children:  [
                          Conditional.single(
                            context: context,
                            conditionBuilder: (BuildContext context) =>  cubit.isDark,
                            widgetBuilder: (BuildContext context) => Icon(
                              Icons.light_mode_outlined,
                              color: cubit.isDark?Colors.white:Colors.black,
                            ),
                            fallbackBuilder: (BuildContext context) => Icon(
                              Icons.dark_mode_outlined,
                              color: cubit.isDark?Colors.white:Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Conditional.single(
                            context: context,
                            conditionBuilder: (BuildContext context) =>  cubit.isDark,
                            widgetBuilder: (BuildContext context) => Text(
                              'Light Mode ',
                              style: TextStyle(
                                fontSize: 20,
                                color: cubit.isDark?Colors.white:Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            fallbackBuilder: (BuildContext context) => Text(
                              'Dark Mode',
                              style: TextStyle(
                                fontSize: 20,
                                color: cubit.isDark?Colors.white:Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 10,),
                          Icon(IconBroken.Arrow___Right_2,
                            color: cubit.isDark?Colors.white:Colors.black,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                fullDivider(),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child:InkWell(
                    onTap: () {
                      navigateAndFinish(context, const SocialLoginScreen());
                      uId = '';
                      showToast(text: "Logout", state: ToastStates.ERROR);
                      CacheHelper.removeData(key: 'uId');
                      cubit.currentIndex=0;
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children:  [
                            Icon(IconBroken.Logout,
                              color: color,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'LOGOUT',
                              style: TextStyle(
                                color: color,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Icon(IconBroken.Arrow___Right_2,
                              color: color,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ),
                fullDivider(),

              ],
            ),
          ),
        );
      },
    );

  }
}
