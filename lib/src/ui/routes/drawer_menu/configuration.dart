import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raco/src/resources/global_translations.dart';


class Configuration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConfigurationState();
  }
}

class ConfigurationState extends State<Configuration> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('configuration')),

      ),
      body: Text('asdf')
    );
  }
}
