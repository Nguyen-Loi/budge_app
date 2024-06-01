import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/models/models_widget/icon_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconManagerData {
  const IconManagerData._();
  // Icon special
  static const IconData _moneyIn = FontAwesomeIcons.moneyBillTrendUp;
  static const IconData _moneyOut = FontAwesomeIcons.moneyBill;
  static const IconData _wallet = FontAwesomeIcons.wallet;
  static const int idWallet = 100;
  static const int idMoneyIn = 101;
  static const int idMoneyOut = 102;

  static const IconData _accomodation = Icons.home;
  static const IconData _categoryEating = FontAwesomeIcons.utensils;
  static const IconData _shopping = Icons.shopify_sharp;
  static const IconData _transportation = FontAwesomeIcons.bus;
  static const IconData _entertainment = FontAwesomeIcons.fan;
  static const IconData _sport = Icons.sports_gymnastics_rounded;
  static const IconData _gift = FontAwesomeIcons.gift;
  static const IconData _water = FontAwesomeIcons.droplet;
  static const IconData _electric = FontAwesomeIcons.bolt;
  static const IconData _phone1 = FontAwesomeIcons.phone;
  static const IconData _phone2 = FontAwesomeIcons.mobileScreenButton;
  static const IconData _house1 = FontAwesomeIcons.house;
  static const IconData _house2 = FontAwesomeIcons.houseChimney;
  static const IconData _gift1 = FontAwesomeIcons.gift;
  static const IconData _gift2 = FontAwesomeIcons.gifts;
  static const IconData _baby = FontAwesomeIcons.baby;
  static const IconData _car1 = FontAwesomeIcons.car;
  static const IconData _car2 = FontAwesomeIcons.carSide;
  static const IconData _star = FontAwesomeIcons.star;
  static const IconData _tiktok = FontAwesomeIcons.tiktok;
  static const IconData _music = FontAwesomeIcons.music;
  static const IconData _bomb = FontAwesomeIcons.bomb;
  static const IconData _poo = FontAwesomeIcons.poo;
  static const IconData _magic = FontAwesomeIcons.wandMagicSparkles;
  static const IconData _pen = FontAwesomeIcons.pen;
  static const IconData _clipboard = FontAwesomeIcons.clipboard;
  static const IconData _book = FontAwesomeIcons.book;
  static const IconData _fire = FontAwesomeIcons.fire;
  static const IconData _plane = FontAwesomeIcons.paperPlane;
  static const IconData _key = FontAwesomeIcons.key;
  static const IconData _code = FontAwesomeIcons.code;
  static const IconData _truck = FontAwesomeIcons.truck;
  static const IconData _wifi = FontAwesomeIcons.wifi;
  static const IconData _fish = FontAwesomeIcons.fish;
  static const IconData _rocket = FontAwesomeIcons.rocket;
  static const IconData _laptop = FontAwesomeIcons.laptop;

  static final List<IconModel> _listIcon = [
    IconModel(idMoneyIn, _moneyIn, Colors.lightBlue),
    IconModel(idMoneyOut, _moneyOut, Colors.teal),
    IconModel(idWallet, _wallet, Colors.teal),
    IconModel(0, _accomodation, Colors.cyan),
    IconModel(1, _categoryEating, ColorManager.yellow),
    IconModel(2, _shopping, Colors.green),
    IconModel(3, _transportation, ColorManager.blue),
    IconModel(4, _entertainment, Colors.indigoAccent),
    IconModel(5, _sport, ColorManager.blue),
    IconModel(6, _gift, ColorManager.orange),
    IconModel(7, _water, ColorManager.blue),
    IconModel(8, _electric, ColorManager.yellow),
    IconModel(9, _phone1, Colors.green),
    IconModel(10, _phone2, Colors.deepPurple),
    IconModel(11, _house1, Colors.black),
    IconModel(12, _house2, Colors.deepPurpleAccent),
    IconModel(13, _gift1, Colors.blue),
    IconModel(14, _gift2, Colors.purple),
    IconModel(15, _baby, Colors.green),
    IconModel(16, _car1, Colors.pink),
    IconModel(17, _car2, Colors.black),
    IconModel(18, _star, Colors.yellow),
    IconModel(19, _tiktok, Colors.black),
    IconModel(20, _music, Colors.black),
    IconModel(21, _bomb, Colors.black),
    IconModel(22, _poo, Colors.grey),
    IconModel(23, _magic, Colors.purple),
    IconModel(24, _pen, Colors.orange),
    IconModel(25, _clipboard, Colors.lime),
    IconModel(26, _book, Colors.cyan),
    IconModel(27, _fire, Colors.red.shade400),
    IconModel(28, _plane, Colors.blueAccent),
    IconModel(29, _key, Colors.yellow),
    IconModel(30, _code, Colors.black),
    IconModel(31, _truck, Colors.indigo),
    IconModel(32, _wifi, Colors.deepPurpleAccent),
    IconModel(33, _fish, Colors.teal),
    IconModel(34, _rocket, Colors.orangeAccent),
    IconModel(35, _laptop, Colors.amberAccent),
  ];

  static List<IconModel> listIconSelect() {
    return _listIcon.where((e) => e.id < 100).toList();
  }

  static IconModel getIconModel(int iconId) {
    return _listIcon.firstWhere((e) => e.id == iconId);
  }
}
