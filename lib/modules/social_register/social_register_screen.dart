import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/networks/local/cache_helper.dart';
import '../../layout/social_layout.dart';
import '../../shared/styles/colors.dart';
import '../cubit/cubit.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SocialRegisterScreen extends StatelessWidget {
  const SocialRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              uId = state.uId;
              navigateAndFinish(context, const SocialLayout());
              SocialCubit.get(context).getUserData();
            });
          }
          if (state is SocialRegisterErrorState) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color:  SocialCubit.get(context).isDark?Colors.white:Colors.black, 
                          ),
                        ),
                        const SizedBox(height: 5,),
                        const Text(
                          'Register now to communicate with others',
                          style: TextStyle(
                            //fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        designedFormField(
                          fontColor: SocialCubit.get(context).isDark?Colors.white:Colors.black,

                          controller: nameController,
                          type: TextInputType.name,
                          label: 'User Name',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'name must be not empty';
                            }
                          },
                          prefixIcon: IconBroken.Add_User,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        designedFormField(
                          fontColor: SocialCubit.get(context).isDark?Colors.white:Colors.black,

                          controller: emailController,
                          type: TextInputType.emailAddress,
                          label: 'Email Address',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'email must be not empty';
                            }
                          },
                          prefixIcon: IconBroken.Message,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        designedFormField(
                          fontColor: SocialCubit.get(context).isDark?Colors.white:Colors.black,
                          function: () {
                            SocialRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          label: 'Password',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'password must be not empty';
                            }
                          },
                          prefixIcon: IconBroken.Unlock,
                          suffixIcon: SocialRegisterCubit.get(context).suffix,
                          isPassword:
                              SocialRegisterCubit.get(context).isPassword,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        designedFormField(
                          fontColor: SocialCubit.get(context).isDark?Colors.white:Colors.black,
                          controller: phoneController,
                          type: TextInputType.phone,
                          label: 'Phone',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'phone must be not empty';
                            }
                          },
                          prefixIcon: IconBroken.Call,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (BuildContext context) =>
                              state is! SocialRegisterLoadingState,
                          widgetBuilder: (BuildContext context) =>
                              defaultButton(
                                radius: 6,
                                  text: 'Register',
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      SocialRegisterCubit.get(context)
                                          .userRegister(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: nameController.text,
                                        phone: phoneController.text,
                                      );
                                    }
                                  }),
                          fallbackBuilder: (BuildContext context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
