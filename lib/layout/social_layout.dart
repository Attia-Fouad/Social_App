import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/shared/styles/colors.dart';

import '../modules/chats/chats_screen.dart';
import '../modules/cubit/cubit.dart';
import '../modules/cubit/states.dart';
import '../modules/feeds/feeds_screen.dart';
import '../modules/new_post/new_post_screen.dart';
import '../modules/profile/profile_screen.dart';
import '../shared/components/components.dart';
import '../shared/styles/icon_broken.dart';


class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(listener: (context, state) {
      if (state is SocialNewPostState) {
        navigateTo(context, const NewPostScreen());
      }
    }, builder: (context, state) {
      var cubit = SocialCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          title: Text(cubit.titles[cubit.currentIndex]),
          actions: [
            IconButton(onPressed: () {
            }, icon:  const Icon(IconBroken.Notification,)
            ),
            IconButton(onPressed: () {}, icon: const Icon(IconBroken.Search,)),
            IconButton(onPressed: () {
              cubit.getPosts();
            }, icon: const Icon(Icons.update,)),
          ],
        ),
        body: PageView(
          controller: cubit.pageController,
          onPageChanged: (index){
            cubit.changeIndexBottomNav(index);
          },
          scrollDirection: Axis.horizontal,
          children: const [
            FeedsScreen(),
            ChatsScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: cubit.currentIndex,
          onTap: (index) {
            cubit.pageController.animateToPage(index, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut,);
            cubit.changeIndexBottomNav(index);
          },
          items:  const [
            BottomNavigationBarItem(
              icon: Icon(
                IconBroken.Home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconBroken.Chat,
              ),
              label: 'Chat',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     IconBroken.User,
            //   ),
            //   label: 'Users',
            // ),
            BottomNavigationBarItem(
              icon: Icon(
                IconBroken.Profile,
              ),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
