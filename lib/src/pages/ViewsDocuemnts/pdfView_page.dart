import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _params = useState<String>(
      ModalRoute.of(context)!.settings.arguments as String,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_params.value.split('/').last),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAAB1),
      ),
      body: Container(child: SfPdfViewer.network(_params.value)),
    );
  }
}
