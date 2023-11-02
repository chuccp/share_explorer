import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Page {
  Page();

  int? rowCount = 0;

  int? pageNo = 1;

  int? pageSize = 10;

  List<List<dynamic>>? dataList = <List<dynamic>>[];

  List<dynamic> elementAt(int index) {
    return dataList!.elementAt(index);
  }

  int length() {
    return dataList!.length;
  }
}

class DataTableController extends ChangeNotifier {
  DataTableController({required this.columnNames});

  final List<String> columnNames;

  final Page _page = Page();

  void updateTable(List<List<dynamic>> dataList, int total, int pageNo) {
    _page.dataList = dataList;
    _page.rowCount = total;
    _page.pageNo = pageNo;
    notifyListeners();
  }



  Page get page => _page;
}

class ExTable extends StatelessWidget {
  ExTable({super.key, required this.dataTableController, required this.onPageChanged, this.addCallback, this.deleteCallback, this.editCallback});

  final DataTableController dataTableController;

  final ValueChanged<int> onPageChanged;

  VoidCallback? addCallback;

  ValueChanged<int>? deleteCallback;

  ValueChanged<int>? editCallback;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => dataTableController,
      child: _TableView(
        onPageChanged: onPageChanged,
        addVoidCallback: addCallback,
        deleteCallback: deleteCallback,
        editCallback: editCallback,
      ),
    );
  }
}

class _PageView extends StatelessWidget {
  _PageView({required this.total, required this.current, required this.pageSize, required this.onPageChanged});

  int total;

  int current;

  int pageSize;

  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(child: Text("总数:$total  当前页:$current")),
          Expanded(
              child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: current <= 1
                      ? null
                      : () {
                          onPageChanged(current - 1);
                        },
                  child: const Text("上一页", textAlign: TextAlign.end),
                ),
                TextButton(
                  onPressed: ((total / pageSize).ceil() <= current)
                      ? null
                      : () {
                          onPageChanged(current + 1);
                        },
                  child: const Text("下一页", textAlign: TextAlign.end),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class _OperateView extends StatelessWidget {
  _OperateView({this.addVoidCallback, this.deleteCallback, this.editCallback});

  VoidCallback? addVoidCallback;

  VoidCallback? deleteCallback;

  VoidCallback? editCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Row(
          children: [
            if (addVoidCallback != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("添加"),
                onPressed: addVoidCallback,
              ),
            if (deleteCallback != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("编辑"),
                  onPressed: editCallback,
                ),
              ),
            if (editCallback != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ElevatedButton.icon(
                  style:  ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.pinkAccent)),
                  icon: const Icon(Icons.delete),
                  label: const Text("删除 "),
                  onPressed:deleteCallback ,
                ),
              ),
          ],
        ));
  }
}

class _TableView extends StatefulWidget {
  _TableView({required this.onPageChanged, this.deleteCallback, this.addVoidCallback, this.editCallback});

  final ValueChanged<int> onPageChanged;

  VoidCallback? addVoidCallback;

  ValueChanged<int>? deleteCallback;

  ValueChanged<int>? editCallback;

  @override
  State<StatefulWidget> createState() => _TableViewState();
}

class _TableViewState extends State<_TableView> {
  int _selectIndex = -1;

  _updateSelectIndex(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectIndex < 0) {
      _selectIndex = 0;
    }
    var page = Provider.of<DataTableController>(context).page;
    var columnNames = Provider.of<DataTableController>(context, listen: false).columnNames;
    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var columns = <DataColumn>[
            for (var column in columnNames)
              DataColumn(
                label: Text(column),
              )
          ];
          return SingleChildScrollView(
            child: Column(
              children: [
                if (widget.addVoidCallback != null || widget.deleteCallback != null || widget.editCallback != null)
                  _OperateView(
                      addVoidCallback: widget.addVoidCallback,
                      deleteCallback: () {
                        if (widget.deleteCallback != null) {
                          widget.deleteCallback!(_selectIndex);
                        }
                      },
                      editCallback: () {
                        if (widget.editCallback != null) {
                          widget.editCallback!(_selectIndex);
                        }
                      }),
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columns: columns,
                    showBottomBorder: true,
                    decoration: const BoxDecoration(),
                    rows: List<DataRow>.generate(
                      page.length(),
                      (int index) {
                        List<dynamic> elementList = page.elementAt(index);
                        var dataCells = [for (var v in elementList) DataCell(Text('$v'))];
                        return DataRow(
                          cells: dataCells,
                          selected: index == _selectIndex,
                          onSelectChanged: (bool? value) {
                            if (value!) {
                              _updateSelectIndex(index);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                _PageView(
                  total: page.rowCount!,
                  current: page.pageNo!,
                  onPageChanged: (int pageNo) {
                    widget.onPageChanged(pageNo);
                  },
                  pageSize: page.pageSize!,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
