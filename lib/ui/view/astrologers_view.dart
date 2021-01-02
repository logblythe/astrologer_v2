import 'package:astrologer/core/data_model/astrologer_model.dart';
import 'package:astrologer/core/view_model/view/astrologer_view_model.dart';
import 'package:astrologer/ui/base_widget.dart';
import 'package:astrologer/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AstrologersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<AstrologerViewModel>(
      model: AstrologerViewModel(
          homeService: Provider.of(context)),
      onModelReady: (model) => model.fetchAstrologers(),
      builder: (context, model, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: ListView(
            children: <Widget>[
              _buildHeader(context),
              _buildAstrologerList(model, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(context) {
    return Card(
      margin: EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: Image.asset(
                  'assets/images/crystal_ball.gif',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            UIHelper.verticalSpaceMedium,
            Text(
              'Our astrologers are genuine professionals trained to treat astrology like a sacred science. In their own lives in Nepal, they are known to combine simple, honest living with high thinking',
              style: Theme.of(context).textTheme.subtitle1,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAstrologerList(AstrologerViewModel model, BuildContext context) {
    return model.busy
        ? const Center(child: const CircularProgressIndicator())
        : (model.astrologers == null || model.astrologers.isEmpty)
            ? const Center(
                child: const Text('No astrologer found at the moment'))
            : Card(
                margin: EdgeInsets.all(12),
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).disabledColor,
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Our Astrologers',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    ListView.separated(
                      separatorBuilder: (context, index) =>
                          index == model.astrologers.length - 1
                              ? Container()
                              : Divider(),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: model.astrologers.length,
                      itemBuilder: (context, index) {
                        AstrologerModel _astrologer = model.astrologers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage(
                                _astrologer.profileImageUrl ??
                                    'https://via.placeholder.com/150'),
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text(
                              "${_astrologer.firstName} ${_astrologer.lastName}"),
                        );
                      },
                    ),
                  ],
                ),
              );
  }
}
