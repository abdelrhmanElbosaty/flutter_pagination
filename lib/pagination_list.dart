import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PaginationListWithPackage extends StatefulWidget {
  const PaginationListWithPackage({super.key});

  @override
  State<PaginationListWithPackage> createState() =>
      _PaginationListWithPackageState();
}

class _PaginationListWithPackageState extends State<PaginationListWithPackage> {
  static const _pageSize = 20;
  late List<String> newData = [];


  final PagingController<int, String> _pagingController =
      PagingController(firstPageKey: 0);

  void getItems(pageKey) async {

    await Future.delayed(const Duration(milliseconds: 500));

    newData = await generateNewData(pageKey);

    final isLastPage = newData.length < _pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(newData);
    } else {
      final nextPageKey = pageKey + newData.length;
      _pagingController.appendPage(newData, nextPageKey);
    }

    setState(() {
    });
  }

  Future<List<String>> generateNewData(pageKey) async {
    newData = [];
    return List.generate(pageKey, (index) => "List no.${index + 1}");
  }

  @override
  void initState() {
    super.initState();

    // getItems(_pageSize);

    _pagingController.addPageRequestListener((pageKey) {
      getItems(pageKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagination Test')),
      body: RefreshIndicator(
        onRefresh: () async {
          _pagingController.refresh();
        },
        child: PagedListView<int, String>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<String>(
            itemBuilder: (context, item, index) {
              return ListTile(
                title: Text(item),
              );
            },
          ),
        ),
      ),
    );
  }
}
