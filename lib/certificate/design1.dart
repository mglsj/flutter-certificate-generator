import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class Design1 {
  static const primaryColor = PdfColor(.11, .459, .737);
  static const secondaryColor = PdfColor(.937, .255, .212);

  static late final String sideDesign, orgLogo, clubLogo;
  static late final Font poppinsSemiboldFont, lazydogFont;
  static late final MemoryImage signature1, signature2, signature3, signature4;

  static var _initialized = false;

  const Design1();

  Future<void> init() async {
    sideDesign = await rootBundle.loadString('assets/icons/side.svg');
    orgLogo =
        await rootBundle.loadString('assets/icons/gehu-haldwani-logo.svg');
    clubLogo = await rootBundle.loadString('assets/icons/club.svg');
    poppinsSemiboldFont =
        Font.ttf(await rootBundle.load('assets/fonts/Poppins-SemiBold.ttf'));
    lazydogFont = Font.ttf(await rootBundle.load('assets/fonts/lazy_dog.ttf'));

    signature1 = MemoryImage(
        (await rootBundle.load('assets/images/cc.png')).buffer.asUint8List());

    signature2 = MemoryImage(
        (await rootBundle.load('assets/images/hod_cse.png'))
            .buffer
            .asUint8List());
    signature3 = MemoryImage(
        (await rootBundle.load('assets/images/hod_soc.png'))
            .buffer
            .asUint8List());

    signature4 = MemoryImage(
        (await rootBundle.load('assets/images/hld_dir.png'))
            .buffer
            .asUint8List());

    _initialized = true;
  }

  Future<Uint8List> build(
    PdfPageFormat pageFormat, {
    required String name,
    required String course,
    required String event,
    required String club,
    required String date,
    required String id,
  }) async {
    if (!_initialized) {
      await init();
    }

    final pdf = Document();
    pdf.addPage(
      Page(
        pageFormat: pageFormat,
        margin: const EdgeInsets.all(0),
        build: (context) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgImage(
                svg: sideDesign,
                width: 100,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgImage(svg: orgLogo, height: 100),
                          SvgImage(svg: clubLogo, height: 100),
                        ],
                      ),
                      Spacer(flex: 1),
                      SizedBox(
                        height: 80,
                        child: _regularText(
                          'Certificate',
                          80,
                          primaryColor,
                        ),
                      ),
                      _regularText(
                        'Of Participation',
                        44,
                        secondaryColor,
                      ),
                      Spacer(flex: 1),
                      _regularText(
                        "This certificate is proudly presented to:",
                        15,
                        primaryColor,
                      ),
                      Spacer(flex: 1),
                      _dottedUnderlineText(
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            _handwrittenText(name, 35),
                            _handwrittenText(id.isNotEmpty ? "($id) " : "", 25)
                          ],
                        ),
                      ),
                      Spacer(flex: 1),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _regularText("of ", 15, primaryColor),
                          Expanded(
                            child: _dottedUnderlineText(
                              _handwrittenText(
                                course,
                                30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(flex: 1),
                      _regularText(
                        "For participating at the",
                        15,
                        primaryColor,
                      ),
                      Spacer(flex: 1),
                      _dottedUnderlineText(
                        _handwrittenText(
                          event,
                          30,
                        ),
                      ),
                      Spacer(flex: 1),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _regularText(
                            "organized by ",
                            15,
                            primaryColor,
                          ),
                          Expanded(
                            child: _dottedUnderlineText(
                              _handwrittenText(club, 30),
                            ),
                          ),
                        ],
                      ),
                      Spacer(flex: 1),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _regularText(
                            "on ",
                            15,
                            primaryColor,
                          ),
                          Expanded(
                            child: _dottedUnderlineText(
                              _handwrittenText(
                                date,
                                30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(flex: 1),
                      _signatureColumn(
                        signature1,
                        "Event Coordinator",
                      ),
                      Spacer(flex: 1),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _signatureColumn(
                            signature2,
                            "Head Of Department\n(CSE)",
                          ),
                          Spacer(flex: 1),
                          _signatureColumn(
                            signature3,
                            "Head Of Department\n(SOC)",
                          ),
                          Spacer(flex: 1),
                          _signatureColumn(
                            signature4,
                            "Director,\nHaldwani Campus",
                          ),
                        ],
                      ),
                      Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Widget _signatureColumn(MemoryImage? signature, String role) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (signature != null)
          Image(
            signature,
            height: 50,
          ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: primaryColor,
                width: 2,
              ),
            ),
          ),
          padding: const EdgeInsets.only(top: 5),
          child: _regularText(
            role,
            12,
            primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _regularText(String text, double fontSize, PdfColor color) {
    return Text(
      text,
      style: TextStyle(
        font: poppinsSemiboldFont,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _dottedUnderlineText(Widget text) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        _dottedTextFill(6.7),
        text,
      ],
    );
  }

  Widget _handwrittenText(String text, double fontSize) {
    return Text(
      " $text",
      style: TextStyle(
        font: lazydogFont,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: PdfColors.black,
      ),
    );
  }

  Widget _dottedTextFill(double dotSpacing) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double dotsWidth = constraints?.maxWidth ?? 0;
        // const double dotSpacing = 6.7; // Adjust for space between dots
        String dots = '';
        for (double i = 0; i < dotsWidth; i += dotSpacing) {
          dots += '.';
        }
        return Text(
          dots,
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
            color: const PdfColor(.11, .459, .737),
          ),
        );
      },
    );
  }
}
