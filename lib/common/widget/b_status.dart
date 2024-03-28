import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum _Status{
   loading,
   error,
   empty
}

class BStatus extends StatelessWidget {
const BStatus({ Key? key, required this.text, required this._status }) : super(key: key);
  final String text;
  final _Status _status;
  @override
  Widget build(BuildContext context){
    switch(_status){
      
      case _Status.loading:
       return _loading();
      case _Status.error:
       return _error();
      case _Status.empty:
       return _empty();
    }
  }

  Widget _loading{
    return Column(
      children: [
        Lottie.asset(AssetsConstants.lottieLoading),
        gapH16,
        BText.b1(text),
        
      ],
    );
  }

   Widget _error{
    return Column(
      children: [
        Lottie.asset(AssetsConstants.lottieError),
        gapH16,
        BText.b1(text),
        
      ],
    );
  }

   Widget _empty{
    return Column(
      children: [
        Lottie.asset(AssetsConstants.lottieEmpty),
        gapH16,
        BText.b1(text),
        
      ],
    );
  }
}