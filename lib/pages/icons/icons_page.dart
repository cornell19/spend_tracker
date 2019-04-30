import 'package:flutter/material.dart';
import './icon_list.dart';

class IconsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icons'),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: icons
              .map(
                (iconData) => InkWell(
                      child: Opacity(
                        opacity: .7,
                        child: Icon(
                          iconData,
                          size: 60,
                          color: color,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop<IconData>(iconData);
                      },
                    ),
              )
              .toList(),
        ),
      ),
    );
  }
}
