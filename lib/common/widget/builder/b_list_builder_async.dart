import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

enum _TypeListBuilder { column, listView, listViewSeparated }


/// Default this list is type column
class BListBuilderAsync<T> extends StatelessWidget {
  const BListBuilderAsync({
    super.key,
    required this.data,
    required this.itemBuilder,
  }) : _typeBuilder = _TypeListBuilder.column;

  const BListBuilderAsync.listView({
    super.key,
    required this.data,
    required this.itemBuilder,
  }) : _typeBuilder = _TypeListBuilder.listView;

    const BListBuilderAsync.listViewSeparated({
    super.key,
    required this.data,
    required this.itemBuilder,
  }) : _typeBuilder = _TypeListBuilder.listViewSeparated;

  final AsyncValue<List<T>> data;
  final ItemWidgetBuilder<T> itemBuilder;
  final _TypeListBuilder _typeBuilder;

  Widget _type(BuildContext context, {required List<T> list}) {
    switch (_typeBuilder) {
      case _TypeListBuilder.column:
        return _column(context, list: list);
      case _TypeListBuilder.listView:
        return _listView(context, list: list);
      case _TypeListBuilder.listViewSeparated:
        return _listViewSeparated(context, list: list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return data.when(
      data: (items) => items.isNotEmpty
          ? _type(context, list: items)
          : const BStatus.empty(text: 'No data'),
      loading: () => const BStatus.loading(text: 'Loading'),
      error: (error, __) {
        logError(error.toString());
        return const BStatus.error(text: 'Something went wrong');
      },
    );
  }

  Widget _listView(BuildContext context, {required List<T> list}) {
    return ListView(
      children: list.map((e) => itemBuilder(context, e)).toList(),
    );
  }

  Widget _column(BuildContext context, {required List<T> list}) {
    return ColumnWithSpacing(
      children: list.map((e) => itemBuilder(context, e)).toList(),
    );
  }

  Widget _listViewSeparated(BuildContext context, {required List<T> list}) {
    return ListView.separated(
      itemCount: list.length + 2,
      separatorBuilder: (context, index) => const Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == list.length + 1) {
          return const SizedBox.shrink();
        }
        return itemBuilder(context, list[index - 1]);
      },
    );
  }
}
