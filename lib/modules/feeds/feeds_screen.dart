import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/modules/comments/commentsScreen.dart';
import 'package:social_app/modules/view_story/view_story_screen.dart';

import '../../models/social_app/post_model.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../new_post/new_post_screen.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Builder(
      builder: (context){
        return   BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            var color = cubit.isDark ? Colors.white : Colors.black;
            return Conditional.single(
              context: context,
              conditionBuilder: (BuildContext context) =>cubit.userModel != null&&cubit.posts.isNotEmpty&&cubit.story.isNotEmpty,
              widgetBuilder: (BuildContext context) => SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        navigateTo(context, const NewPostScreen());
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: cubit.isDark ? HexColor('333739') : Colors.white,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 23,
                                backgroundImage: NetworkImage(
                                  cubit.userModel!.image!,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: cubit.isDark
                                          ? Colors.white60
                                          : Colors.black26,
                                      width: 2,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'What is in your mind?',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                IconBroken.Image_2,
                                size: 25,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    myDivider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Stories',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: cubit.isDark ? Colors.white : Colors.black,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 10,
                        ),
                        itemBuilder: (context, index) {
                          return buildStoryItem(context,cubit.story[index],index,cubit.storyId);
                        },
                        itemCount: cubit.story.length,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildPostItem(
                          context, color, cubit.posts[index], index,cubit.postsId),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 8.0,
                      ),
                      itemCount: cubit.posts.length,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              fallbackBuilder: (BuildContext context) =>
              const Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );



  }

  Widget buildPostItem(context, color, PostModel model, index, List<String> postsId) => Card(
        color:
            SocialCubit.get(context).isDark ? HexColor('454545') : Colors.white,
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
                          model.dateTime.toString().substring(0, 16),
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                color: SocialCubit.get(context).isDark
                                    ? Colors.white
                                    : Colors.black,
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
                      color: SocialCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black,
                    ),
              ),
              if (model.postImage != '')
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 5),
                  child: Container(
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
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
                              '${SocialCubit.get(context).likes[index]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(
                                    color: color,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              IconBroken.Chat,
                              size: 16.0,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              //'${SocialCubit.get(context).getPostCommentNumber(postsId[index])} comments',
                              'comments',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(
                                    color: color,
                                  ),
                            ),
                          ],
                        ),
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
                                      color: SocialCubit.get(context).isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                          ),
                        ],
                      ),
                      onTap: () {
                        SocialCubit.get(context).getPostComments(SocialCubit.get(context).postsId[index]);
                        navigateTo(context, CommentsScreen(index,SocialCubit.get(context).postsId[index]));
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
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                color: color,
                              ),
                        ),
                      ],
                    ),
                    onTap: () {
                      SocialCubit.get(context)
                          .likePost(SocialCubit.get(context).postsId[index]);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildStoryItem(context,PostModel story,index,List<String> storyId) {
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            ViewStoryScreen(
              image:story.postImage!,
              text: story.text,
            ));
      },
      child:Conditional.single(
        context: context,
        conditionBuilder: (BuildContext context) =>  story.postImage!='',
        widgetBuilder: (BuildContext context) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.deepOrange,
          ),
          width: 125,
          height: 200,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network(
                    story.postImage!,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    story.name!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children:  [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                      ),
                      CircleAvatar(
                        radius: 23,
                        backgroundImage: NetworkImage(
                          story.image!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        fallbackBuilder: (BuildContext context) =>Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black45,
          ),
          width: 125,
          height: 200,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(story.text!,style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    story.name!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children:  [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                      ),
                      CircleAvatar(
                        radius: 23,
                        backgroundImage: NetworkImage(
                          story.image!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  /*Widget buildPostItem(PostModel model,context,index) => Card(
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
                  '${model.image}',
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${model.name}',
                          style: TextStyle(
                            height: 1.4,
                          ),
                        ),
                        SizedBox(
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
                      '${model.dateTime}',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              IconButton(
                icon: Icon(
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
            '${model.text}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     bottom: 10.0,
          //     top: 5.0,
          //   ),
          //   child: Container(
          //     width: double.infinity,
          //     child: Wrap(
          //       children: [
          //         Padding(
          //           padding: const EdgeInsetsDirectional.only(
          //             end: 6.0,
          //           ),
          //           child: Container(
          //             height: 25.0,
          //             child: MaterialButton(
          //               onPressed: () {},
          //               minWidth: 1.0,
          //               padding: EdgeInsets.zero,
          //               child: Text(
          //                 '#software',
          //                 style:
          //                     Theme.of(context).textTheme.caption!.copyWith(
          //                           color: defaultColor,
          //                         ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsetsDirectional.only(
          //             end: 6.0,
          //           ),
          //           child: Container(
          //             height: 25.0,
          //             child: MaterialButton(
          //               onPressed: () {},
          //               minWidth: 1.0,
          //               padding: EdgeInsets.zero,
          //               child: Text(
          //                 '#flutter',
          //                 style:
          //                     Theme.of(context).textTheme.caption!.copyWith(
          //                           color: defaultColor,
          //                         ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          if(model.postImage!='')
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 5),
              child: Container(
                height: 140.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    4.0,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      '${model.postImage}',
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
                        children: [
                          Icon(
                            IconBroken.Heart,
                            size: 16.0,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            '${SocialCubit.get(context).likes[index]}',
                            style: Theme.of(context).textTheme.caption,
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
                        children: [
                          Icon(
                            IconBroken.Chat,
                            size: 16.0,
                            color: Colors.amber,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            '${SocialCubit.get(context).comments[index]} comments',
                            style: Theme.of(context).textTheme.caption,
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
                          '${SocialCubit.get(context).userModel!.image}',
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        'write a comment ...',
                        style:
                        Theme.of(context).textTheme.caption!.copyWith(),
                      ),
                    ],
                  ),
                  onTap: () {
                    postId =SocialCubit.get(context).postsId[index];
                    navigateTo(context, CommentsScreen());
                  },
                ),
              ),
              InkWell(
                child: Row(
                  children: [
                    Icon(
                      IconBroken.Heart,
                      size: 16.0,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'Like',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                onTap: () {
                  SocialCubit.get(context).likePost(SocialCubit.get(context).postsId[index]);
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );*/

}
