import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import '../../models/social_app/post_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/networks/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';
import '../../shared/styles/style.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../edit_password/edit_password_screen.dart';
import '../edit_profile/edit_profile_screen.dart';
import '../new_story/new_story_screen.dart';
import '../social_login/social_login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit=SocialCubit.get(context);
        var userModel = SocialCubit.get(context).userModel;
        var color=cubit.isDark?Colors.white:Colors.black;
        return Conditional.single(
          context: context,
          conditionBuilder: (BuildContext context) => userModel!.name!.isNotEmpty,
          widgetBuilder: (BuildContext context) =>  Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 190,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Container(
                            height: 140.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  '${userModel!.cover}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 63,
                          backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundImage: NetworkImage(
                              '${userModel.image}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${userModel.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${userModel.bio}',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                      color: color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  '100',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  'posts',
                                  style: Theme.of(context).textTheme.caption!.copyWith(
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  '230',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  'Photos',
                                  style: Theme.of(context).textTheme.caption!.copyWith(
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  '64k',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  'Followers',
                                  style: Theme.of(context).textTheme.caption!.copyWith(
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  '2k',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  'Following',
                                  style: Theme.of(context).textTheme.caption!.copyWith(
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 5,),
                      Expanded(child: Container(
                        child: MaterialButton(
                          onPressed: () {
                            navigateTo(context, const NewStoryScreen());
                          },
                          child:  Row(
                            children: const [
                              Expanded(
                                child: Icon(
                                  IconBroken.Image_2,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Add Story',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      ),
                      const SizedBox(width: 5,),
                      Expanded(child: Container(
                        child: MaterialButton(
                          onPressed: () {
                            navigateTo(context, const SettingsScreen());
                          },
                          child:  Row(
                            children: const [
                              Expanded(
                                child: Icon(
                                  IconBroken.Setting,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Settings',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      ),

                    ],
                  ),
                  //////////////////////////////


              /*
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

                  */
                  /////////////////////////////////////
                  const SizedBox(
                    height: 25,
                  ),

              Conditional.single(
                context: context,
                conditionBuilder: (BuildContext context) =>  cubit.myPosts.isNotEmpty,
                widgetBuilder: (BuildContext context) =>  ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>buildPostItem(context,color,cubit.myPosts[index]),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8.0,
                  ),
                  itemCount: cubit.myPosts.length,
                ),
                fallbackBuilder: (BuildContext context) =>  Center(child: Text('No Posts Yet, \nShare some Posts.',
                style: TextStyle(
                  color: color,
                ),)),
              ),

                  const SizedBox(
                    height: 25,
                  ),

                ],
              ),
            ),
          ),
          fallbackBuilder: (BuildContext context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
  Widget buildPostItem(context,color,PostModel model)=> Card(
    color: SocialCubit.get(context).isDark? HexColor('454545'):Colors.white,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: const EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  model.image!,
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          model.name!,
                          style: TextStyle(
                            color: color,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Icon(
                          Icons.check_circle,
                          color: defaultColor,
                          size: 16.0,
                        ),
                      ],
                    ),
                    Text(
                      model.dateTime.toString().substring(0,16),
                      style: Theme.of(context).textTheme.caption!.copyWith(
                        color:  SocialCubit.get(context).isDark?Colors.white: Colors.black,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_horiz,
                  size: 16.0,
                ),
                onPressed: () {},
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          Text(
            model.text!,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
              color:  SocialCubit.get(context).isDark?Colors.white: Colors.black,
            ),
          ),
          if(model.postImage!='')
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 5),
              child:
              Container(
                height: 140.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    4.0,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      model.postImage!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      child: Row(
                        children:  [
                          const Icon(
                            IconBroken.Heart,
                            size: 16.0,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            //'${SocialCubit.get(context).likes[index]}',
                            '0',
                            style: Theme.of(context).textTheme.caption?.copyWith(
                              color: color,
                            ),
                          ),

                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:  [
                          const Icon(
                            IconBroken.Chat,
                            size: 16.0,
                            color: Colors.amber,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            //'${SocialCubit.get(context).comments[index]} comments',
                            '0 Comments',
                            style: Theme.of(context).textTheme.caption?.copyWith(
                              color: color,
                            ),
                          ),

                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18.0,
                        backgroundImage: NetworkImage(
                          SocialCubit.get(context).userModel!.image!,
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        'write a comment ...',
                        style:
                        Theme.of(context).textTheme.caption!.copyWith(
                          color:  SocialCubit.get(context).isDark?Colors.white: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                  },
                ),
              ),
              InkWell(
                child: Row(
                  children: [
                    const Icon(
                      IconBroken.Heart,
                      size: 16.0,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'Like',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                onTap: () {
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
