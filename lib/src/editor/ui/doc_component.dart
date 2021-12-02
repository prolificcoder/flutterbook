import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutterbook/src/editor/ui/copy_text.dart';
import 'package:flutterbook/src/editor/ui/styled_icon_button.dart';
import 'package:flutterbook/src/utils/extensions.dart';
import 'package:flutterbook/src/utils/radii.dart';

class DocPanel extends StatefulWidget {
  final Widget component;
  final String? docs;
  final String stateName;

  const DocPanel({
    Key? key,
    required this.component,
    this.docs,
    required this.stateName,
  }) : super(key: key);

  @override
  _DocPanelState createState() => _DocPanelState();
}

class _DocPanelState extends State<DocPanel> {
  bool expanded = false;
  double _zoom = 1;
  get zoom => _zoom;

  void zoomIn() {
    setState(() {
      _zoom += 0.25;
    });
  }

  void zoomOut() {
    setState(() {
      _zoom = (_zoom - 0.25).clamp(0.5, 999);
    });
  }

  void resetZoom() {
    setState(() {
      _zoom = 1;
    });
  }

  void toggleExpansion() {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle tabStyle = Theme.of(context).textTheme.subtitle1!.copyWith(
          color: context.theme.hintColor,
          fontWeight: FontWeight.bold,
        );

    TransformationController _transformation = TransformationController();
    _transformation.value = Matrix4.identity()..scale(zoom);
    return Container(
      width: 900,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: context.theme.shadowColor.withOpacity(0.075),
          ),
        ],
        borderRadius: canvasBorderRadius,
        color: context.colorScheme.surface,
      ),
      margin: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(widget.stateName, style: tabStyle),
                  ),
                  VerticalDivider(),
                  StyledTextButton(
                    icon: FeatherIcons.zoomIn,
                    onPressed: zoomIn,
                  ),
                  const SizedBox(width: 8),
                  StyledTextButton(
                    icon: FeatherIcons.zoomOut,
                    onPressed: zoomOut,
                  ),
                  const SizedBox(width: 8),
                  StyledTextButton(
                    onPressed: resetZoom,
                    icon: FeatherIcons.refreshCcw,
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              color: context.theme.dividerColor.withOpacity(0.5),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: InteractiveViewer(
                boundaryMargin: EdgeInsets.all(double.infinity),
                panEnabled: true,
                transformationController: _transformation,
                child: widget.component,
              ),
            ),
            widget.docs != null
                ? Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: toggleExpansion,
                          child: Text(expanded ? 'Hide Code' : 'Show Code'),
                        ),
                        if (expanded)
                          CopyText(
                            textCopied: widget.docs!,
                            textTooltip: 'Copy Code!',
                          )
                      ],
                    ))
                : SizedBox.shrink(),
            expanded
                ? Container(
                    child: SingleChildScrollView(
                    child: HighlightView(
                      widget.docs!,
                      language: 'dart',
                      padding: EdgeInsets.all(10),
                      theme: atomOneDarkTheme,
                    ),
                  ))
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
