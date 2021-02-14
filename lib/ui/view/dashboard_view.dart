import 'package:astrologer/core/data_model/message_model.dart';
import 'package:astrologer/core/view_model/view/dashboard_view_model.dart';
import 'package:astrologer/ui/base_widget.dart';
import 'package:astrologer/ui/widgets/message_item.dart';
import 'package:astrologer/ui/widgets/no_user_dialog.dart';
import 'package:astrologer/ui/widgets/payment_selection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatefulWidget {
  final GlobalKey<AnimatedListState> listKey;

  const DashboardView({Key key, this.listKey}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _messageController;
  FocusNode _messageFocusNode;
  DashboardViewModel _dashboardViewModel;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseWidget(
      model: _dashboardViewModel,
      onModelReady: handleModelReady,
      builder: (context, DashboardViewModel model, child) {
        _messageController
          ..text = model.messageBox
          ..selection =
              TextSelection.collapsed(offset: _messageController.text.length);
        return GestureDetector(
          onTap: () => _messageFocusNode.unfocus(),
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Image.asset(
                  "assets/images/background.png",
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  child: Column(
                    children: <Widget>[
                      buildListMessage(model),
                      buildInput(model),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildListMessage(DashboardViewModel model) {
    return Expanded(
      child: model.fetchingList
          ? const Center(child: CircularProgressIndicator())
          : AnimatedList(
              primary: true,
              key: widget.listKey,
              initialItemCount: model.messages?.length,
              reverse: true,
              shrinkWrap: true,
              padding: EdgeInsets.all(8.0),
              itemBuilder: (context, i, animation) {
                MessageModel _message = model.messages[i];
                return MessageItem(
                  darkMode: false,
                  message: _message,
                  animation: animation,
                  item: i,
                  onTap: () {},
                );
              },
            ),
    );
  }

  buildInput(DashboardViewModel model) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        color: Colors.white.withOpacity(.6),
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              focusNode: _messageFocusNode,
              controller: _messageController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(25.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(25.0)),
                  border: InputBorder.none,
                  hintText: 'Type your question here...'),
            ),
          ),
          AnimatedCrossFade(
            firstChild: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => addMessage(model)),
            secondChild: Container(),
            duration: Duration(milliseconds: 200),
            crossFadeState: _dashboardViewModel.showSendBtn
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            sizeCurve: Curves.easeOutSine,
            firstCurve: Curves.easeOutSine,
            secondCurve: Curves.easeOutSine,
          ),
        ]),
      ),
    );
  }

  void addMessage(DashboardViewModel model) async {
    if (_messageController.text.isNotEmpty) {
      if (await model.getUserInfo() == null) {
        showDialog(
            context: context,
            builder: (context) {
              return NoUserDialog();
            });
      } else {
        var _message =
            MessageModel(message: _messageController.text.trim(), sent: true);
        await model.addMessage(_message);
        await model.askQuestion(_message);
        final _listState = widget.listKey.currentState;
        if (_listState != null)
          _listState.insertItem(0, duration: Duration(milliseconds: 500));
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dashboardViewModel = DashboardViewModel(
      homeService: Provider.of(context),
      userService: Provider.of(context),
    );
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messageFocusNode = FocusNode();
  }

  @override
  bool get wantKeepAlive => true;

  void handleModelReady(DashboardViewModel model) {
    model.init();
    model.showBottomSheet.stream.listen((event) async {
      print('event $event');
      if (event) {
        var response = await showModalBottomSheet(
            context: context,
            builder: (context) {
              return PaymentSelection(
                onEsewaSelect: () => model.handleESewaSelect(),
                onKhaltiSelect: () => model.handleKhaltiSelect(),
              );
            });
        print('the response $response');
      }
    });
  }
}
