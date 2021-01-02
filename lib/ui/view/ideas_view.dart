import 'package:astrologer/core/constants/what_to_ask.dart';
import 'package:astrologer/core/data_model/idea_model.dart';
import 'package:astrologer/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class IdeasView extends StatelessWidget {
  final Function onTap;

  const IdeasView({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          _buildIdeas(context),
        ],
      ),
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
                  'assets/images/idea.gif',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            UIHelper.verticalSpaceMedium,
            Text(
              'There are some question samples to inspire you with ideas what type and kind of questions you may ask. Of course, there are imaginary questions, our customer data is strictly confidential.',
              style: Theme.of(context).textTheme.subtitle1,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeas(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        itemCount: ideaModelList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.5,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () => _showIdeasDialog(index, context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(
                    ideaModelList[index].iconData,
                    size: 60,
                    color: RandomColor()
                        .randomColor(colorBrightness: ColorBrightness.dark),
                  ),
                  Text(ideaModelList[index].title),
                ],
              ),
            ),
          );
        });
  }

  _showIdeasDialog(int index, BuildContext context) {
    IdeaModel _idea = ideaModelList[index];
    showDialog(
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              padding: EdgeInsets.all(16),
              child: Text(
                'Select your query',
                textAlign: TextAlign.center,
                textScaleFactor: 1.2,
              ),
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        height: (index == _idea.children.length - 1) ? 0 : 1,
                      ),
                  shrinkWrap: true,
                  itemCount: _idea.children.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_idea.children[index]),
                      trailing: const Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        onTap(_idea.children[index]);
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
      context: context,
    );
  }
}
