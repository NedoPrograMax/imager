import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:imager/constants/strings.dart';
import 'package:imager/views/auth/auth_card.dart';

class AuthView extends StatelessWidget {
  AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text("Auth"),
    );
    //is used for computating height on widgets 
    final availableHeight = media.size.height - appBar.preferredSize.height;
    return Scaffold(
      appBar: appBar,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Center(
          child: AuthCard(availableHeight: availableHeight),
        ),
      ),
    );
  }
}
