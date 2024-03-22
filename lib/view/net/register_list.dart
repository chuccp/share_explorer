import 'package:flutter/cupertino.dart';
import 'package:share_explorer/entry/node.dart';

import '../../api/discover.dart';
import '../../component/ex_table.dart';

class RegisterList extends StatefulWidget {
  const RegisterList({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterListState();
}

class _RegisterListState extends State<RegisterList> {
  DataTableController dataTableController = DataTableController(columnNames: ["类型", "服务名", "地址", "最后心跳时间"]);


  late int pageNo;

  List<ExNode>? list;

  void query(int pageNo) {
    this.pageNo = pageNo;
    DiscoverOperate.nodeNatServerList(pageNo: pageNo, pageSize: dataTableController.page.pageSize!).then((value) {
      list = value.data!.list;
      var total = value.data!.total;
      var dataList = <List<dynamic>>[
        for (var ele in list!) <dynamic>[ele.nodeType, ele.id, ele.address,ele.lastLiveTime]
      ];
      dataTableController.updateTable(dataList, total!, pageNo);
    });
  }
  @override
  void initState() {
    query(1);
  }

  @override
  Widget build(BuildContext context) {
    return ExTable(
      dataTableController: dataTableController,
      onPageChanged: (int value) {},
    );
  }
}
