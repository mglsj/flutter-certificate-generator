import 'package:certificate/helpers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:certificate/certificate/certificate.dart';

class PdfViewer extends ConsumerStatefulWidget {
  const PdfViewer({super.key});

  @override
  ConsumerState<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends ConsumerState<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    String name = ref.watch(nameProvider);
    String course = ref.watch(courseProvider);
    String date = ref.watch(dateProvider);
    String club = ref.watch(clubProvider);
    String event = ref.watch(eventProvider);
    String id = ref.watch(idProvider);

    return Expanded(
      child: PdfPreview(
        build: (format) {
          return Designs.design1.build(
            format,
            name: name,
            course: course,
            id: id,
            date: date,
            club: club,
            event: event,
          );
        },
        useActions: false,
        shouldRepaint: true,
        dynamicLayout: false,
        maxPageWidth: 700,
      ),
    );
  }
}
