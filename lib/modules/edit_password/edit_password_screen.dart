

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/icon_broken.dart';
import '../../shared/styles/style.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class EditPasswordScreen extends StatelessWidget {
  const EditPasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var newPasswordController = TextEditingController();
    var newPasswordController2 = TextEditingController();
    return  BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit=SocialCubit.get(context);
        var userModel = SocialCubit.get(context).userModel;
        var color=cubit.isDark?Colors.white:Colors.black;
        var formKey = GlobalKey<FormState>();
        return  Conditional.single(
          context: context,
          conditionBuilder: (BuildContext context) => userModel!=null,
          widgetBuilder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Edit Password'),
                actions: const [
                  Icon(
                    IconBroken.Edit_Square,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You Should Re-login Before Change Password',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        designedFormField(
                          isPassword: cubit.isPassword,
                          fontColor: color,
                          function: () {
                            cubit.changePasswordVisibility();
                          },
                          controller: newPasswordController,
                          type: TextInputType.visiblePassword,
                          label: 'New Password',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'password must be not empty';
                            }
                            if (value!=newPasswordController2.text) {
                              return 'new Password is not the same';
                            }
                          },
                          prefixIcon: IconBroken.Unlock,
                          suffixIcon: cubit.suffix,
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        designedFormField(
                          function: () {
                            cubit.changePasswordVisibility();
                          },
                          suffixIcon: cubit.suffix,
                          isPassword: cubit.isPassword,
                          fontColor: color,
                          controller: newPasswordController2,
                          type: TextInputType.visiblePassword,
                          label: 'Retype New Password',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'password must be not empty';
                            }
                            if (value!=newPasswordController.text) {
                              return 'new Password is not the same';
                            }
                          },
                          prefixIcon: IconBroken.Unlock,
                        ),
                        const SizedBox(
                          height: 55,
                        ),
                        Center(
                          child: defaultButton(
                            background: dColor,
                            radius: 25,
                            width: 150,
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.updateUserPassword(
                                  password: newPasswordController.text,
                                );
                              }
                            },
                            text: 'UPDATE',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            );
          },
          fallbackBuilder: (BuildContext context) => const Center(child: CircularProgressIndicator()),
        );


      },
    );




  }
}
