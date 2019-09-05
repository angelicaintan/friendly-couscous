import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'records.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

class FileRow {
  
  List<Record> files;

  FileRow(List<Record> list) {
    files = list;
  }

  Widget _buildFileList(BuildContext context, int index) {
    return Card(
      child: Row(
        children: <Widget>[
          Text("2019-07-22-19:31:55-2046-tommy-$index"),
          FlatButton(child: Text("delete"),
          onPressed: () {
            files.remove(files[index]);
          }
          ),
        ],
      ),
    );
  }

}