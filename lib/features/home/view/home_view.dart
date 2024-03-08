import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/common/widget/form/b_image.dart';
import 'package:budget_app/constants/color_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget{
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      actions: const [
        Icon(Icons.notifications),
        Column(
          children: [
            BTextRichSpace(text1: 'Hello ', text2:'Roya!'),
            gapH8,
            BText.caption('Your finances are looking good')
          ],
        )
      ],

    ),
   );
  
  }

  Widget _cardBalance(){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          const BImage.avatar('https://acpro.edu.vn/hinh-nhung-chu-meo-de-thuong/imager_173.jpg'),
          gapH24,
          const BText('Your available lalance is'),
          gapH16,
          BText('\$ 2028',color: ColorConstants.white),
        ],
      ),
    );
  }



}