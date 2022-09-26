import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/modules/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/components/components.dart';

import '../../models/social_app/comment_model.dart';
import '../../models/social_app/post_model.dart';
import '../../models/social_app/social_message_model.dart';
import '../../models/social_app/social_user_model.dart';
import '../../shared/components/constants.dart';
import '../../shared/networks/local/cache_helper.dart';
import '../chats/chats_screen.dart';
import '../feeds/feeds_screen.dart';
import '../profile/profile_screen.dart';


class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);


  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(SocialChangePasswordVisibilityState());
  }


  bool isDark=true;
  void changeAppMode( { bool? fromShared}){
    if(fromShared!=null)
    {
      isDark=fromShared;
      emit(AppChangeModeState());
    }
    else {
      isDark =!isDark;
      CacheHelper.sharedPreferences.setBool('isDark', isDark).then((value) {
        emit(AppChangeModeState());
      });
    }

  }


  SocialUserModel? userModel;
  void getUserData() {
    emit(SocialGetUserLoadingState());
    if (kDebugMode) {
      print('here is uid');
    }
    if (kDebugMode) {
      print(uId);
    }
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;
  PageController pageController=PageController(initialPage: 0);


  List<Widget> screens = const[
    FeedsScreen(),
    ChatsScreen(),
    //NewPostScreen(),
    //UsersScreen(),
    ProfileScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    //'Post',
    //'Users',
    'Settings',
  ];

  void changeIndexBottomNav(int index) {
    if(index==2)
    {
      getMyPosts();
    }
    if(index==1)
    {
      getUsers();
    }


      currentIndex = index;
      emit(SocialChangeBottomNavState());
  }

  File? profileImage;
  final ImagePicker picker = ImagePicker();
  Future<void> getProfileImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    profileImage = File(image!.path);
    emit(SocialProfileImagePickedSuccessState());
  }

  File? coverImage;
  Future<void> getCoverImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    coverImage = File(image!.path);
    emit(SocialCoverImagePickedSuccessState());
  }

  String profileImageUrl = '';
  void uploadProfileImage() {
    emit(SocialUpdateUserImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadProfileImageSuccessState());
        if (kDebugMode) {
          print(value);
        }
        profileImageUrl = value;
        updateUserImage(image: value);
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
        if (kDebugMode) {
          print(error.toString());
        }
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  String coverImageUrl = '';
  void uploadCoverImage() {
    emit(SocialUpdateUserCoverLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadCoverImageSuccessState());
        if (kDebugMode) {
          print(value);
        }
        coverImageUrl = value;
        updateUserCover(cover: value);
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
        if (kDebugMode) {
          print(error.toString());
        }
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }


  void updateUserData({
    required String name,
    required String phone,
    required String bio,
  }) {
    SocialUserModel? model = SocialUserModel(
      phone: phone,
      name: name,
      image: userModel!.image,
      bio: userModel!.bio,
      cover: userModel!.cover,
      isEmailVerified: false,
      uId: userModel!.uId,
      email: userModel!.email,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      showToast(text: "Update Successful", state: ToastStates.SUCCESS);
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  void updateUserName({
    required String name,
  }) {
    emit(SocialUpdateUserNameLoadingState());
    SocialUserModel? model = SocialUserModel(
      name: name,
      isEmailVerified: false,
      uId: userModel!.uId,
      email: userModel!.email,
    );
    FirebaseFirestore.instance.collection('users').doc(userModel!.uId).update({
      'name': name,
    }).then((value) {
      getUserData();
      showToast(text: "Update Successful", state: ToastStates.SUCCESS);
      emit(SocialUpdateUserNameSuccessState());
    }).catchError((error) {
      emit(SocialUpdateUserNameErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  void updateUserBio({
    required String bio,
  }) {
    emit(SocialUpdateUserBioLoadingState());
    SocialUserModel? model = SocialUserModel(
      bio: bio,
      isEmailVerified: false,
      uId: userModel!.uId,
      email: userModel!.email,
    );
    FirebaseFirestore.instance.collection('users').doc(userModel!.uId).update({
      'bio': bio,
    }).then((value) {
      getUserData();
      showToast(text: "Update Successful", state: ToastStates.SUCCESS);
      emit(SocialUpdateUserBioSuccessState());
    }).catchError((error) {
      emit(SocialUpdateUserBioErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  void updateUserPhone({
    required String phone,
  }) {
    emit(SocialUpdateUserPhoneLoadingState());
    SocialUserModel? model = SocialUserModel(
      phone: phone,
      isEmailVerified: false,
      uId: userModel!.uId,
      email: userModel!.email,
    );
    FirebaseFirestore.instance.collection('users').doc(userModel!.uId).update({
      'phone': phone,
    }).then((value) {
      getUserData();
      emit(SocialUpdateUserPhoneSuccessState());
      showToast(text: "Update Successful", state: ToastStates.SUCCESS);
    }).catchError((error) {
      emit(SocialUpdateUserPhoneErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  void updateUserImage({
    required String image,
  }) {
    emit(SocialUpdateUserImageLoadingState());
    SocialUserModel? model = SocialUserModel(
      image: image,
      isEmailVerified: false,
      uId: userModel!.uId,
      email: userModel!.email,
    );
    FirebaseFirestore.instance.collection('users').doc(userModel!.uId).update({
      'image': image,
    }).then((value) {
      getUserData();
      showToast(text: "Update Successful", state: ToastStates.SUCCESS);
      emit(SocialUpdateUserImageSuccessState());
    }).catchError((error) {
      emit(SocialUpdateUserImageErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  void updateUserCover({
    required String cover,
  }) {
    emit(SocialUpdateUserCoverLoadingState());
    SocialUserModel? model = SocialUserModel(
      image: cover,
      isEmailVerified: false,
      uId: userModel!.uId,
      email: userModel!.email,
    );
    FirebaseFirestore.instance.collection('users').doc(userModel!.uId).update({
      'cover': cover,
    }).then((value) {
      getUserData();
      emit(SocialUpdateUserCoverSuccessState());
      showToast(text: "Update Successful", state: ToastStates.SUCCESS);
    }).catchError((error) {
      emit(SocialUpdateUserCoverErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  File? postImage;
  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  Future<void> getPostImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    postImage = File(image!.path);
    emit(SocialPostImagePickedSuccessState());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialCreatePostSuccessState());
        if (kDebugMode) {
          print(value);
        }
        createPost(dateTime: dateTime, text: text, postImage: value);
        createMyPost(dateTime: dateTime, text: text, postImage: value);
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
        if (kDebugMode) {
          print(error.toString());
        }
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());
    PostModel? model = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
      getPosts();
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }



  void createMyPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());
    PostModel? model = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection(model.uId!)
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }


  void uploadStoryImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreateStoryLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('story/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialCreateStorySuccessState());
        if (kDebugMode) {
          print(value);
        }
        createStory(dateTime: dateTime, text: text, postImage: value);
      }).catchError((error) {
        emit(SocialCreateStoryErrorState());
        if (kDebugMode) {
          print(error.toString());
        }
      });
    }).catchError((error) {
      emit(SocialCreateStoryErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  void createStory({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreateStoryLoadingState());
    PostModel? model = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('story')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreateStorySuccessState());
      getStory();
    }).catchError((error) {
      emit(SocialCreateStoryErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }



  late List<PostModel> posts = [];
  late List<CommentModel> comments = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int> nComments = [];

  late List<PostModel> story = [];
  List<String> storyId = [];

  void getStory() {
    storyId = [];
    story = [];
    emit(SocialGetStoryLoadingState());
    FirebaseFirestore.instance
        .collection('story')
        .get()
        .then((value)
    {
      for (var element in value.docs) {
        story.add(PostModel.fromJson(element.data()));
        storyId.add(element.id);
        emit(SocialGetStorySuccessState());
      }
    })
        .catchError((error){
      emit(SocialGetStoryErrorState(error.toString()));
    });
  }



  void getPosts() {
    posts = [];
    postsId = [];
    likes = [];
    nComments = [];
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value)
    {
      for (var element in value.docs) {
            element.reference.collection('likes').get().then((value) {
                  likes.add(value.docs.length);
              posts.add(PostModel.fromJson(element.data()));
              postsId.add(element.id);
                  //************for test comments number
                  // element.reference.collection('comments').get().then((value) {
                  //   nComments.add(value.docs.length);
                  // }).catchError((error){});
              //***end
                  emit(SocialGetPostsSuccessState());
            }).catchError((error){

        });

      }

    })
        .catchError((error){
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  int? getPostCommentNumber(postId) {
    nComments = [];
    emit(SocialGetCommentsNumberLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value)
    {
      emit(SocialGetCommentsNumberSuccessState());
      return value.docs.length;
    })
        .catchError((error){
      emit(SocialGetCommentsNumberErrorState(error.toString()));
    });
    return null;
  }




  late List<PostModel> myPosts = [];

  void getMyPosts()
  {
    myPosts = [];
    FirebaseFirestore.instance
        .collection(userModel!.uId!)
        .get()
        .then((value)
    {
      for (var element in value.docs) {
        myPosts.add(PostModel.fromJson(element.data()));
        emit(SocialGetPostsSuccessState());
      }

    })
        .catchError((error){
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }










  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostsSuccessState());
      getPosts();
    }).catchError((error) {
      emit(SocialLikePostsErrorState(error.toString()));
    });
  }

  void commentPost(String postId,comment){
    CommentModel? commentModel = CommentModel(
      name: userModel!.name,
      image: userModel!.image,
      dateTime: DateTime.now().toString(),
      comment: comment,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(
      commentModel.toMap(),
    ).then((value) {
      emit(SocialCommentPostsSuccessState());
      getPostComments(postId);
    }).catchError((error) {
      emit(SocialCommentPostsErrorState(error.toString()));
    });

  }


  void getPostComments(String postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        comments.add(CommentModel.fromJson(element.data()));
        emit(SocialGetCommentsSuccessState());

      });
    }).catchError((error){
      showToast(state: ToastStates.ERROR,text: error.toString());
    });

  }




  List<SocialUserModel> users=[];

  void getUsers(){
    users=[];
    FirebaseFirestore.instance.collection('users').get().then((value)
    {
      for (var element in value.docs) {
        if(element.data()['uId']!= userModel!.uId) {
          users.add(SocialUserModel.fromJson(element.data()));
        }

      }
      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      emit(SocialGetAllUsersErrorState(error.toString()));
    });

  }


//*************************************************/
  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    // set my chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    // set receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];

      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }

      emit(SocialGetMessageSuccessState());
    });
  }


  void updateUserPassword({
    required String password,
  }) {

    emit(SocialUpdateUserPasswordLoadingState());
    FirebaseAuth.instance.currentUser?.updatePassword(password).then((value) {
      showToast(
        state: ToastStates.SUCCESS,
        text: 'Update Successful',
      );
      emit(SocialUpdateUserPasswordSuccessState());
      getUserData();
    }).catchError((error){
      showToast(
        state: ToastStates.ERROR,
        text: 'process failed\nYou Should Re-login Before Change Password',
      );
      emit(SocialUpdateUserPasswordErrorState(error.toString()));
      if (kDebugMode) {
        print(error.toString());
      }
    });

  }

}
