import 'package:snackk/models/deserializable.dart';
import 'package:snackk/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QueryListBuilder<T extends Deserialized> extends StatefulWidget {
  Query query;
  Widget Function(BuildContext, DocumentSnapshot) builder;
  ScrollController controller;
  ScrollPhysics physics;
  EdgeInsetsGeometry padding;
  bool shrinkWrap;
  Widget ifEmpty;
  Widget ifLoading;
  QueryListBuilder(
      {this.query,
      this.builder,
      this.controller,
      this.physics,
      this.padding,
      this.shrinkWrap = false,
      this.ifEmpty,
      this.ifLoading});

  @override
  _QueryListBuilderState createState() => _QueryListBuilderState<T>();
}

class _QueryListBuilderState<T> extends State<QueryListBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.query.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0)
              return widget.ifEmpty ??
                  Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Nothing to display.",
                          textAlign: TextAlign.center,
                          style: TextStyles.largeLabelGrey),
                      SizedBox(height: 64)
                    ],
                  ));
            return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView.builder(
                    padding: widget.padding,
                    controller: widget.controller,
                    physics: widget.physics,
                    shrinkWrap: widget.shrinkWrap,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, i) =>
                        widget.builder(context, snapshot.data.documents[i])));
          }
          if (snapshot.hasError) {
            print("ERROR in stream from query: " + widget.query.toString());
            print(snapshot.error);
          }
          return widget.ifLoading ??
              Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          BreveColors.brandColor)));
        });
  }
}
