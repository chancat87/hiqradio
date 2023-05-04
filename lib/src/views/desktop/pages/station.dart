import 'package:flutter/material.dart';
import 'package:hiqradio/src/views/desktop/components/InkClick.dart';
import 'package:hiqradio/src/views/desktop/components/search_option.dart';
import 'package:hiqradio/src/views/desktop/components/station_icon.dart';

class Station extends StatefulWidget {
  const Station({super.key});

  @override
  State<Station> createState() => _StationState();
}

class _StationState extends State<Station> with AutomaticKeepAliveClientMixin {
  TextEditingController searchEditController = TextEditingController();
  bool isOptionShow = false;

  TextEditingController pageSizeEditController = TextEditingController();
  FocusNode pageSizeFocusNode = FocusNode();
  bool isPageSizeEditing = false;

  TextEditingController pageEditController = TextEditingController();
  FocusNode pageFocusNode = FocusNode();
  bool isPageEditing = false;

  int pageSize = 20;
  int page = 1;
  int totalSize = 37002;

  @override
  void initState() {
    super.initState();

    pageSizeFocusNode.addListener(() {
      if (!pageSizeFocusNode.hasFocus) {
        setState(() {
          isPageSizeEditing = !isPageSizeEditing;
        });
      }
    });
    pageFocusNode.addListener(() {
      if (!pageFocusNode.hasFocus) {
        setState(() {
          isPageEditing = !isPageEditing;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchEditController.dispose();

    pageSizeEditController.dispose();
    pageSizeFocusNode.dispose();

    pageEditController.dispose();
    pageFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearch(),
          const SizedBox(
            height: 8.0,
          ),
          _buildJumpInfo(),
          const SizedBox(
            height: 8.0,
          ),
          Expanded(child: _buildContent())
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                '搜索: ',
                style: TextStyle(
                    fontSize: 14.0, color: Colors.white.withOpacity(0.8)),
              ),
            ),
            SizedBox(
              width: 250,
              child: _searchField(searchEditController, (value) {
                print('onsubmit: ${value}');
              }),
            ),
            InkClick(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  isOptionShow ? '隐藏选项' : '显示选项',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  isOptionShow = !isOptionShow;
                });
              },
            )
          ],
        ),
        isOptionShow ? const SearchOption() : Container()
      ],
    );
  }

  Widget _buildJumpInfo() {
    int totalPage = totalSize ~/ pageSize;
    if (totalSize % pageSize > 0) {
      totalPage += 1;
    }
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
      child: Row(
        children: [
          const SizedBox(
            width: 6.0,
          ),
          Text(
            '电台： 共 ',
            style:
                TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13.0),
          ),
          Container(
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              '$totalSize',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9), fontSize: 13.0),
            ),
          ),
          Text(
            ' 个',
            style:
                TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13.0),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '每页 ',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9), fontSize: 13.0),
            ),
          ),
          _buildEditing(isPageSizeEditing, pageSizeEditController,
              pageSizeFocusNode, '$pageSize', (value) {
            int? v = int.tryParse(value);
            if (v != null) {
              pageSize = v;
            }
          }, () {
            isPageSizeEditing = true;
            setState(() {});
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '个 共 ',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9), fontSize: 13.0),
            ),
          ),
          Container(
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              '$totalPage',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9), fontSize: 13.0),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              ' 页 当前第 ',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9), fontSize: 13.0),
            ),
          ),
          _buildEditing(
              isPageEditing, pageEditController, pageFocusNode, '$page',
              (value) {
            int? v = int.tryParse(value);
            if (v != null) {
              page = v;
            }
          }, () {
            isPageEditing = true;
            setState(() {});
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              ' 页',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9), fontSize: 13.0),
            ),
          ),
          const SizedBox(
            width: 6.0,
          )
        ],
      ),
    );
  }

  Widget _buildEditing(
      bool test,
      TextEditingController controller,
      FocusNode focusNode,
      String text,
      ValueChanged<String> onChanged,
      VoidCallback onEditSwitch) {
    return test
        ? SizedBox(
            // padding: const EdgeInsets.symmetric(horizontal: 8.0),
            width: 40.0,
            height: 18.0,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              autofocus: true,
              autocorrect: false,
              obscuringCharacter: '*',
              cursorWidth: 1.0,
              showCursor: true,
              cursorColor: Colors.grey.withOpacity(0.8),
              style: const TextStyle(fontSize: 13.0),
              decoration: InputDecoration(
                // hintText: '10~100',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)),
                    borderRadius: BorderRadius.circular(5.0)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)),
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              onChanged: (value) => onChanged(value),
            ),
          )
        : InkClick(
            onTap: () {
              onEditSwitch.call();
              pageSizeFocusNode.requestFocus();
            },
            child: Container(
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Wrap(
        children: List.generate(100, (index) {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: StationIcon(),
          );
        }).toList(),
      ),
    );
  }

  Widget _searchField(
      TextEditingController controller, ValueChanged valueChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
      height: 26.0,
      child: TextField(
        controller: controller,
        autofocus: true,
        autocorrect: false,
        obscuringCharacter: '*',
        cursorWidth: 1.0,
        cursorColor: Colors.grey.withOpacity(0.8),
        style: TextStyle(fontSize: 12.0, color: Colors.grey.withOpacity(0.8)),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search_outlined,
              size: 18.0, color: Colors.grey.withOpacity(0.8)),
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    controller.text = '';
                    setState(() {});
                  },
                  child: Icon(Icons.close_outlined,
                      size: 16.0, color: Colors.grey.withOpacity(0.8)),
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
          fillColor: Colors.grey.withOpacity(0.2),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)),
            // borderRadius: BorderRadius.circular(50.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)),
            // borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        onChanged: (value) {
          setState(() {});
        },
        onSubmitted: (value) {
          valueChanged.call(value);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
