

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../models/social_app/social_message_model.dart';
import '../../models/social_app/social_user_model.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel? userModel;
  ChatDetailsScreen({Key? key, this.userModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context){
        var cubit=SocialCubit.get(context);
        var color = cubit.isDark ? Colors.white : Colors.black;
        SocialCubit.get(context).getMessages(receiverId: userModel!.uId!);
        return BlocConsumer<SocialCubit,SocialStates>(
          listener: (context,state){},
          builder: (context,state){
            var messageController=TextEditingController();
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('${userModel!.image}'),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text('${userModel!.name}'),
                  ],
                ),


              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context,index){
                          var message=SocialCubit.get(context).messages[index];
                          if(SocialCubit.get(context).userModel!.uId==message.senderId) {
                            return buildMyMessage(message);
                          }
                          return buildMessage(message);
                        },
                        separatorBuilder: (context,state)=> const SizedBox(
                          height: 15,
                        ),
                        itemCount: SocialCubit.get(context).messages.length,
                      ),
                    ),

                    //Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextFormField(
                              style: TextStyle(
                                color: color,
                              ),
                              controller: messageController,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: color,
                                ),
                                prefixIcon: Icon(
                                  Icons.emoji_emotions,
                                  color: Colors.deepOrange[400],
                                ),
                                border: InputBorder.none,
                                hintText: 'Message',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Container(
                          //height: 40,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange[400],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: MaterialButton(
                            onPressed: ()
                            {
                              SocialCubit.get(context).sendMessage(
                                receiverId: userModel!.uId!,
                                dateTime: DateTime.now().toString(),
                                text: messageController.text,
                              );
                            },
                            minWidth: 1,
                            child: const Icon(
                              IconBroken.Send,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),



                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



  Widget buildMessage(MessageModel model)=> Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        decoration: BoxDecoration(
          color: HexColor('#415d50'),
          borderRadius: const BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(10),
            topStart: Radius.circular(10),
            topEnd: Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${model.text}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,/*TrackingCubit.get(context).isDark?Colors.white:Colors.black,*/
              ),
            ),
            Text(
                  '${model.dateTime.toString().substring(11,16)}',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    ),
  );
  Widget buildMyMessage(MessageModel model)=> Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        decoration:  const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          color: Colors.black54,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${model.text}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,/*TrackingCubit.get(context).isDark?Colors.white:Colors.black,*/
              ),

            ),
            Text(
                  '${model.dateTime.toString().substring(11,16)}',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

