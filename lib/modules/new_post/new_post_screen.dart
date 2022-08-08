import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/icon_broken.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is SocialCreatePostSuccessState)
          {
            navigateAndFinish(context, const SocialLayout());
            showToast(state: ToastStates.SUCCESS,
            text: 'Post Shared');
          }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        var color=cubit.isDark?Colors.white:Colors.black;
        var userModel = cubit.userModel;

        return
          Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Create Post',
            actions: [
              defaultTextButton(
                  text: 'Post',
                  function: () {
                    var now = DateTime.now();
                    if (cubit.postImage == null) {
                      cubit.createPost(
                        dateTime: now.toString(),
                        text: textController.text,
                      );
                      cubit.createMyPost(
                        dateTime: now.toString(),
                        text: textController.text,
                      );

                    } else {
                      cubit.uploadPostImage(
                          dateTime: now.toString(), text: textController.text);
                    }
                  }),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is SocialCreatePostLoadingState)
                  const LinearProgressIndicator(),
                if (state is SocialCreatePostLoadingState)
                  const SizedBox(
                    height: 15,
                  ),
                Row(
                  children: [
                     CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(userModel!.image!
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
                                '${userModel.name}',
                                style:  TextStyle(
                                  color: color,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    style: TextStyle(
                      color: color,
                    ),
                    controller: textController,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color:color,
                      ),
                      labelStyle: TextStyle(
                        color: color,
                      ),
                      hintStyle: TextStyle(
                        color: color,
                      ),
                      hintText: 'What is on your mind ${userModel.name} ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 140.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: FileImage(cubit.postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20,
                          child: IconButton(
                            onPressed: () {
                              cubit.removePostImage();
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            cubit.getPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                IconBroken.Image,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('add photo'),
                            ],
                          )),
                    ),
                    Expanded(
                        child: TextButton(
                            onPressed: () {}, child: const Text('# tags'))),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
