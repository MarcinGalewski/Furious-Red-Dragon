import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:furious_red_dragon/constants.dart';
import 'package:furious_red_dragon/pages/global_states.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class BarcodeReader extends StatefulWidget {
  const BarcodeReader({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarcodeReaderState();
}

class BarcodeReaderState extends State<BarcodeReader> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey barcodeKey = GlobalKey(debugLabel: 'Barcode');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Column(
        children: <Widget>[
          Expanded(flex: 4, child: buildBarcodeReader(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text('Value: ${result!.code}')
                  else
                    const Text('Scanning...'),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildBarcodeReader(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 450.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: barcodeKey,
      onQRViewCreated: onBarcodeReaderCreated,
      overlay: QrScannerOverlayShape(
          borderColor: kFuriousRedColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (controller, permission) =>
          onPermissionSet(context, controller, permission),
    );
  }

  void onBarcodeReaderCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        // pause a camera when code detected

        // check if code is in database
        //  controller.pauseCamera();
        //  controller.resumeCamera();
      });
    });
  }

  void onPermissionSet(
      BuildContext context, QRViewController controller, bool permission) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $permission');
    isPhotoPermission = permission;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
