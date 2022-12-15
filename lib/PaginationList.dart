import 'package:flutter/material.dart';

class PaginationList extends StatefulWidget {
  const PaginationList({Key? key}) : super(key: key);

  @override
  State<PaginationList> createState() => _PaginationListState();
}

class _PaginationListState extends State<PaginationList> {
  final ScrollController _scrollController = ScrollController();
  List<String> items = [];
  bool loading = false;
  bool allLoaded = false;

  void getItems() async {
    if (allLoaded) {
      return;
    }

    setState(() {
      loading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    List<String> newData = items.length >= 60
        ? []
        : List.generate(20, (index) => "List no.${index + 1}");
    if (newData.isNotEmpty) {
      items.addAll(newData);
    }
    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    getItems();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        getItems();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Pagination Test')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (items.isNotEmpty) {
              return Stack(
                children: [
                  ListView.separated(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(items[index]),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                            height: 1,
                          ),
                      itemCount: items.length),
                  if (loading) ...[
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: SizedBox(
                          width: constraints.maxWidth,
                          child:
                              const Center(child: CircularProgressIndicator())),
                    )
                  ]
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
