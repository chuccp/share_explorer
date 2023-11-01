import 'package:flutter/material.dart';

import '../api/user.dart';

class SourceData extends DataTableSource {
  final _dataRowList = <DataRow>[];
  var _rowCount = 0;

  updateDataRow(int rowCount) {
    _dataRowList.clear();
    for (var i = 0; i < 10; i++) {
      _dataRowList.add(DataRow(
        cells: <DataCell>[DataCell(Text("test$i")), DataCell(Text("test001$i"))],
      ));
    }
    _rowCount = rowCount;
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (_dataRowList.isEmpty) {
      return const DataRow(
        cells: <DataCell>[DataCell.empty, DataCell.empty],
      );
    }
    return _dataRowList.elementAt(index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rowCount;

  @override
  int get selectedRowCount => 1;
}

class DataPageTable extends StatefulWidget {
  DataPageTable({super.key, this.pageNo, this.pageSize});

  int? pageNo;
  int? pageSize;

  @override
  State<StatefulWidget> createState() => _DataPageTableState();
}

class _DataPageTableState extends State<DataPageTable> {
  @override
  Widget build(BuildContext context) {
    SourceData sourceData = SourceData();
    widget.pageNo ??= 1;
    widget.pageSize ??= 10;
    UserOperate.queryPath(pageNo: widget.pageNo!, pageSize: widget.pageSize!).then((value) {
      sourceData.updateDataRow(10);
    });

    return PaginatedDataTable(
        showCheckboxColumn: true,
        columns: const <DataColumn>[
          DataColumn(
            label: Text('名称'),
          ),
          DataColumn(
            label: Text('路径'),
          ),
        ],
        source: sourceData,
        onPageChanged: (index) {
          sourceData._dataRowList.clear();
          UserOperate.queryPath(pageNo: widget.pageNo!, pageSize: widget.pageSize!);
        },
        onRowsPerPageChanged: (index) {
          print("onRowsPerPageChanged$index");
        });
  }
}
