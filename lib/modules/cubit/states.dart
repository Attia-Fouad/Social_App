abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates {
  String error;
  SocialGetUserErrorState(this.error);
}

class SocialGetAllUsersLoadingState extends SocialStates {}

class SocialGetAllUsersSuccessState extends SocialStates {}

class SocialGetAllUsersErrorState extends SocialStates {
  String error;
  SocialGetAllUsersErrorState(this.error);
}



class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates {
  String error;
  SocialGetPostsErrorState(this.error);
}

class SocialLikePostsSuccessState extends SocialStates {}

class SocialLikePostsErrorState extends SocialStates {
  String error;
  SocialLikePostsErrorState(this.error);
}


class SocialCommentPostsSuccessState extends SocialStates {}

class SocialCommentPostsErrorState extends SocialStates {
  String error;
  SocialCommentPostsErrorState(this.error);
}

class SocialChangeBottomNavState extends SocialStates {}

class SocialNewPostState extends SocialStates {}

class SocialCoverImagePickedSuccessState extends SocialStates {}

class SocialPostImagePickedSuccessState extends SocialStates {}

class SocialCoverImagePickedErrorState extends SocialStates {}

class SocialProfileImagePickedSuccessState extends SocialStates {}

class SocialProfileImagePickedErrorState extends SocialStates {}

class SocialUploadProfileImageSuccessState extends SocialStates {}

class SocialUploadProfileImageErrorState extends SocialStates {}

class SocialUploadCoverImageSuccessState extends SocialStates {}

class SocialUploadCoverImageErrorState extends SocialStates {}

class SocialUserUpdateLoadingState extends SocialStates {}

class SocialUserUpdateErrorState extends SocialStates {}

class SocialUpdateUserNameLoadingState extends SocialStates {}

class SocialUpdateUserNameSuccessState extends SocialStates {}

class SocialUpdateUserNameErrorState extends SocialStates {}

class SocialUpdateUserBioLoadingState extends SocialStates {}

class SocialUpdateUserBioSuccessState extends SocialStates {}

class SocialUpdateUserBioErrorState extends SocialStates {}

class SocialUpdateUserPhoneLoadingState extends SocialStates {}

class SocialUpdateUserPhoneSuccessState extends SocialStates {}

class SocialUpdateUserPhoneErrorState extends SocialStates {}

class SocialUpdateUserImageLoadingState extends SocialStates {}

class SocialUpdateUserImageSuccessState extends SocialStates {}

class SocialUpdateUserImageErrorState extends SocialStates {}

class SocialUpdateUserCoverLoadingState extends SocialStates {}

class SocialUpdateUserCoverSuccessState extends SocialStates {}

class SocialUpdateUserCoverErrorState extends SocialStates {}

class SocialCreatePostLoadingState extends SocialStates {}

class SocialCreatePostSuccessState extends SocialStates {}

class SocialCreatePostErrorState extends SocialStates {}

class SocialRemovePostImageState extends SocialStates {}

//chats
class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {}

class SocialGetMessageSuccessState extends SocialStates {}



class AppChangeModeState extends SocialStates {}
class SocialChangePasswordVisibilityState extends SocialStates {}




class SocialUpdateUserPasswordLoadingState extends SocialStates {}

class SocialUpdateUserPasswordSuccessState extends SocialStates {}

class SocialUpdateUserPasswordErrorState extends SocialStates {
  String error;
  SocialUpdateUserPasswordErrorState(this.error);
}


class SocialGetCommentsSuccessState extends SocialStates {}


class SocialGetCommentsNumberLoadingState extends SocialStates {}

class SocialGetCommentsNumberSuccessState extends SocialStates {}

class SocialGetCommentsNumberErrorState extends SocialStates {
  String error;
  SocialGetCommentsNumberErrorState(this.error);
}


class SocialCreateStoryLoadingState extends SocialStates {}

class SocialCreateStorySuccessState extends SocialStates {}

class SocialCreateStoryErrorState extends SocialStates {}


class SocialGetStoryLoadingState extends SocialStates {}

class SocialGetStorySuccessState extends SocialStates {}

class SocialGetStoryErrorState extends SocialStates {
  String error;
  SocialGetStoryErrorState(this.error);
}




