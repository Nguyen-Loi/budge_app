import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:flutter/material.dart';

class NewLimitView extends StatelessWidget {
  const NewLimitView({Key? key}) : super(key: key);
  final TextEditingController _nameController;
  final 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BText.h2('New limit'),
        centerTitle: true,
        backgroundColor: ColorManager.purple12,
      ),
      body: ColoredBox(
        color: ColorManager.purple12,
        child: Column(
          children: [
            const SizedBox(height: 100),
            Expanded(
              child: _body(),
            )
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        child: );
  }

  Widget _form(){
return BForm(onSubmit: onSubmit, titleSubmit: titleSubmit,children: const [
  BFormFieldText(controller, label: label)
  
], );
  }
}
