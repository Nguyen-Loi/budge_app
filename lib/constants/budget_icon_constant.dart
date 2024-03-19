import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/models/models_widget/icon_model.dart';


class BudgetIconConstant {
  static final List<IconModel> _listIcon = [
    IconModel(0, IconConstants.categoryAccomodation, ColorManager.purple12),
    IconModel(1, IconConstants.categoryEating, ColorManager.yellow),
    IconModel(2, IconConstants.categoryShopping, ColorManager.green2),
    IconModel(3, IconConstants.categoryTransportation, ColorManager.blue),
    IconModel(4, IconConstants.categoryEntertainment, ColorManager.purple24),
    IconModel(5, IconConstants.categorySport, ColorManager.blue),
    IconModel(6, IconConstants.categoryGift, ColorManager.orange),
    IconModel(7, IconConstants.categoryWater, ColorManager.blue),
    IconModel(8, IconConstants.categoryElectric, ColorManager.yellow),
  ];

  static List<IconModel> get listIcon => _listIcon;

  static IconModel getIconModel(int iconId) {
    return listIcon.firstWhere((e) => e.id == iconId);
  }
}
