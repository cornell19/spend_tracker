import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/icons/icons_page.dart';

typedef void OnIconChange(IconData iconData);

class IconHolder extends StatelessWidget {
  const IconHolder({
    Key key,
    @required this.newIcon,
    @required this.onIconChange,
    this.tagId,
    this.tagUrlId,
  }) : super(key: key);

  final IconData newIcon;
  final OnIconChange onIconChange;
  final int tagId;
  final String tagUrlId;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var iconData = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IconsPage(),
          ),
        );

        onIconChange(iconData);
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.blueAccent,
          ),
        ),
        child: Hero(
          tag: tagId == null ? tagUrlId : tagId,
          child: Icon(
            newIcon == null ? Icons.add : newIcon,
            size: 60,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}
