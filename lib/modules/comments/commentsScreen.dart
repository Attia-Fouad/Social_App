import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/models/social_app/comment_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import '../../layout/social_layout.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class CommentsScreen extends StatelessWidget {
  CommentsScreen(
    this.index,
    this.postId,
  );
  int index;
  String postId;

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        var color = cubit.isDark ? Colors.white : Colors.black;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Comments'),
          ),
          body: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Conditional.single(
                            context: context,
                            conditionBuilder: (BuildContext context) =>
                                cubit.comments.isNotEmpty,
                            widgetBuilder: (BuildContext context) {
                              List<CommentModel> model = cubit.comments;
                              cubit.comments = [];
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    buildCommentItem(
                                        context, color, model[index]),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 12.0,
                                ),
                                itemCount: model.length,
                              );
                            },
                            fallbackBuilder: (BuildContext context) =>  Center(
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                )),
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  style: TextStyle(
                    color: color,
                  ),
                  controller: commentController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'comment must be not empty';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: color,
                    ),
                    errorStyle: TextStyle(
                      color: color,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: color,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          SocialCubit.get(context).commentPost(
                              SocialCubit.get(context).postsId[index],
                              commentController.text);
                          commentController.text = '';
                          showToast(
                              state: ToastStates.SUCCESS, text: 'Commented');
                          //navigateAndFinish(context, const SocialLayout());

                        }
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    hintText: 'Write Comment',
                    hintStyle: TextStyle(
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildCommentItem(context, color, CommentModel m) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                /* '${SocialCubit.get(context).userModel!.image}',*/
                m.image!,
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // 'My comment ...',
                  m.name!,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  // 'My comment ...',
                  m.comment!,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        color: color,
                      ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  m.dateTime.toString().substring(0, 16),
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        color: SocialCubit.get(context).isDark
                            ? Colors.white60
                            : Colors.black45,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ],
        ),
      );
}
