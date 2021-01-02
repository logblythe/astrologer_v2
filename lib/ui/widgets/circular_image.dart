import 'dart:io';

import 'package:astrologer/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class CircularImage extends StatefulWidget {
  final Function(File image) onImageCaptured;
  final String imageUrl;
  final bool busy;

  const CircularImage({Key key, this.onImageCaptured, this.imageUrl, this.busy})
      : super(key: key);

  @override
  _CircularImageState createState() => _CircularImageState();
}

class _CircularImageState extends State<CircularImage> {
  File _image;
  String _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkResponse(
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 56,
            child: _imageUrl != null
                ? Container(
                    width: 190.0,
                    height: 190.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill, image: NetworkImage(_imageUrl)),
                    ),
                  )
                : _image == null
                    ? Icon(Icons.person_outline)
                    : Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill, image: FileImage(_image)),
                        ),
                      ),
          ),
          onTap: () => _handleCircleAvatarClick(context),
        ),
        Positioned(
          top: 38,
          left: 38,
          child: widget.busy
              ? CircularProgressIndicator(
                  strokeWidth: 4,
                  backgroundColor: Colors.white54,
                )
              : Container(),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.imageUrl;
  }

  @override
  void didUpdateWidget(CircularImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        _imageUrl = widget.imageUrl;
      });
    }
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = image;
        _imageUrl = null;
      });
      widget.onImageCaptured(image);
    }
  }

  void _handleCircleAvatarClick(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (context) => Card(
        child: Container(
          padding: EdgeInsets.only(top: 16),
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
              ]),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "Select your avatar",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
              UIHelper.verticalSpaceSmall,
              Divider(color: Colors.red),
              UIHelper.verticalSpaceSmall,
              InkWell(
                child: Text(
                  "Take a picture",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.camera);
                },
              ),
              UIHelper.verticalSpaceMedium,
              InkWell(
                child: Text(
                  "Select from files",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.gallery);
                },
              ),
              UIHelper.verticalSpaceMedium,
              InkWell(
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
