import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wheelsec/others/constants.dart';

class ScanPlateNo extends StatefulWidget {
  const ScanPlateNo({super.key});

  @override
  State<ScanPlateNo> createState() => _ScanPlateNoState();
}

class _ScanPlateNoState extends State<ScanPlateNo> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  CameraController? _cameraController;
  late final Future<void> _future;

  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    _future = _requestCameraPermission();
    WidgetsBinding.instance.addObserver(this);

    // Force landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Reset to all orientations when leaving this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Center(
        child: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Stack(
              children: [
                // Camera Preview
                FutureBuilder<List<CameraDescription>>(
                  future: availableCameras(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _initCameraController(snapshot.data!);
                      return SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: CameraPreview(_cameraController!),
                      );
                    } else {
                      return const LinearProgressIndicator();
                    }
                  },
                ),
                // User instructions
                const Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Text(
                    'Align license plate within the frame',
                    style: TextStyle(color: Colors.white, backgroundColor: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Scan Button - positioned at bottom
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _scanImage,
                      child: const Text("Scan plate number"),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _isPermissionGranted = true;
    }
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);
    await _cameraController!.lockCaptureOrientation(DeviceOrientation.landscapeLeft);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    try {
      final pictureFile = await _cameraController!.takePicture();
      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);

      // Get all lines
      final lines = recognizedText.text.split('\n');
      print(lines);

      // Find the plate number
      String plateNumber = PlateValidator.cleanPlateNumber(lines);

      if (plateNumber.isNotEmpty) {
        _goSearch(plateNumber);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please try scanning again - ensure plate is clearly visible'),
          ),
        );
      }
    } catch (e) {
      // Error handling
    }
  }

  void _goSearch(String plateNo) {
    Navigator.of(context).pushNamed(
      "/search vehicle",
      arguments: plateNo
    );
  }
}

class PlateValidator {
  // Static data - you'll need to populate these with actual values
  static final Map<String, List<String>> _stateLGAs = {
    'ABIA': ['EZA', 'ABA', 'ACH', 'BND', 'KWU', 'KPU', 'MBA', 'MBL', 'NGK', 'HAF', 'SSM', 'GWB', 'KKE', 'KEK', 'UMA', 'APR', 'UNC'],
    'ADAMAWA': ['DSA', 'FUR', 'GAN', 'GRE', 'GMB', 'GUY', 'HNG', 'JAD', 'JMT', 'LMR', 'MDG', 'MAH', 'MWA', 'MCH', 'MUB', 'GYL', 'NUM', 'SHG', 'SNG', 'TNG', 'YLA'],
    'AKWA-IBOM': ['ABK', 'KRT', 'KET', 'KST', 'AFH', 'AEE', 'ETN', 'PNG', 'NGD', 'BMT', 'NYA', 'KKN', 'KTS', 'KTE', 'DRK', 'TTU', 'ENW', 'MKP', 'AFG', 'KTD', 'TAI', 'NTE', 'KPD', 'ABT', 'RNN', 'KTM', 'EYF', 'KPK', 'UFG', 'DUU', 'UYY'],
    'ANAMBRA': ['AGU', 'AAH', 'NZM', 'NEN', 'ACA', 'AWK', 'NKK', 'KPP', 'ZBL', 'GDD', 'JJT', 'HAL', 'ABN', 'NNE', 'UKP', 'ATN', 'NSH', 'FGG', 'AJL', 'UMZ', 'HTE'],
    'BAUCHI': ['ALK', 'BAU', 'BGR', 'DBM', 'DRZ', 'DAS', 'GAM', 'GJW', 'GYD', 'TSG', 'JMA', 'KTG', 'KRF', 'MSA', 'NNG', 'SHR', 'TFB', 'TRR', 'WRJ', 'ZAK'],
    'BAYELSA': ['BRS', 'KMR', 'KMK', 'NEM', 'GBB', 'SAG', 'SPR', 'YEN'],
    'BENUE': ['GMU', 'GTU', 'GKP', 'BKB', 'GBK', 'YGJ', 'ALD', 'NAK', 'KAL', 'TSE', 'WDP', 'GBG', 'MKD', 'BRT', 'BGT', 'DKP', 'JUX', 'PKG', 'TKP', 'WNN', 'UKM', 'SEL', 'VDY'],
    'BORNO': ['ADM', 'ASU', 'BAM', 'BAY', 'BBU', 'CBK', 'DAM', 'DKW', 'GUB', 'GZM', 'GZA', 'HWL', 'JRE', 'KGG', 'KBG', 'KDG', 'KWA', 'KWY', 'MAF', 'MGM', 'MAG', 'MAR', 'MBR', 'MNG', 'NGL', 'NGZ', 'SHN'],
    'CROSS RIVER': ['TGD', 'RAM', 'KTA', 'BKS', 'ABE', 'AKP', 'BJE', 'CAL', 'ANA', 'EFE', 'KMM', 'BNS', 'BRA', 'UDU', 'DUK', 'GGJ', 'GEP', 'CKK'],
    'DELTA': ['SLK', 'GWK', 'BMA', 'BUR', 'SKL', 'GRA', 'AGB', 'AYB', 'DSZ', 'LEH', 'ABH', 'KWC', 'KPE', 'AKU', 'ASB', 'PTN', 'SAP', 'ALA', 'UGH', 'JRT', 'BKW', 'EFR', 'GBJ', 'KLK', 'WWR'],
    'EBONYI': ['AKL', 'AFK', 'EDA', 'UGB', 'EBJ', 'NKE', 'CHR', 'ZLL', 'SKA', 'BKL', 'HKW', 'BZR', 'NCA'],
    'EDO': ['GAR', 'USL', 'RRU', 'URM', 'UBJ', 'EKP', 'FUG', 'AGD', 'AUC', 'GUE', 'DGE', 'BEN', 'ABD', 'AKA', 'GBZ', 'AFZ', 'SGD', 'HER'],
    'EKITI': ['ADK', 'EFY', 'MUE', 'LAW', 'AMK', 'EMR', 'SSE', 'DEA', 'DEK', 'JER', 'KER', 'RLE', 'YEK', 'GED', 'TUN', 'YEE'],
    'ENUGU': ['DBR', 'AWG', 'NKW', 'ENU', 'UWN', 'AGW', 'GBD', 'ENZ', 'BBG', 'KEM', 'MGL', 'AGN', 'NSK', 'JRV', 'BLF', 'UDD', 'UMU'],
    'FCT': ['ABJ', 'ABC', 'BWR', 'GWA', 'KUJ', 'KWL'],
    'GOMBE': ['AKK', 'BLG', 'BLR', 'DKU', 'FKY', 'GME', 'KLT', 'KWM', 'NFD', 'SHM', 'YDB'],
    'IMO': ['ABB', 'AFR', 'EHM', 'ETU', 'URU', 'DFB', 'EKE', 'KED', 'UML', 'UMD', 'NWA', 'NGN', 'UMK', 'NKR', 'AMG', 'TTK', 'GUA', 'EBM', 'KGE', 'KWE', 'RLU', 'AWT', 'MMA', 'NGB', 'WER', 'RRT', 'UMG'],
    'JIGAWA': ['AUY', 'BBR', 'BNW', 'BKD', 'BUJ', 'DUT', 'GGW', 'GRK', 'GML', 'GRR', 'GRM', 'GWW', 'HJA', 'JHN', 'KHS', 'KGM', 'KZR', 'KKM', 'MGR', 'MMR', 'MGA', 'RNG', 'RRN', 'STK', 'TAR', 'YKS', 'KYW'],
    'KADUNA': ['BNG', 'KJM', 'GKW', 'TRK', 'KAR', 'KWB', 'KAF', 'KCH', 'DKA', 'KGK', 'KJR', 'KRA', 'MKA', 'KRU', 'ANC', 'HKY', 'SNK', 'MKR', 'SBG', 'GWT', 'MGN', 'ZKW', 'ZAR'],
    'KANO': ['AJG', 'ABS', 'BGW', 'BBJ', 'BCH', 'BNK', 'DAL', 'DBT', 'DKD', 'DTF', 'DGW', 'FGE', 'DSW', 'GAK', 'GNM', 'GYA', 'GZW', 'GWL', 'GRZ', 'KMC', 'KRY', 'KBY', 'KKU', 'KBT', 'KNC', 'KUR', 'MDB', 'MKK', 'MJB', 'NSR', 'RAN', 'RMG', 'RGG', 'SNN', 'SML', 'TAK', 'TRN', 'TEA', 'TYW', 'TWD', 'UGG', 'WRA', 'WDL', 'KBK'],
    'KATSINA': ['BKR', 'BAT', 'BTR', 'BRE', 'BDW', 'CRC', 'DMS', 'DDM', 'DJA', 'DRA', 'DTS', 'DTM', 'FSK', 'FTA', 'NGW', 'JBY', 'KFR', 'KAT', 'KKR', 'KNK', 'KTN', 'KUF', 'KSD', 'MDW', 'MNF', 'MAN', 'MSH', 'MTZ', 'MSW', 'RMY', 'SBA', 'SFN', 'SDM', 'ZNG'],
    'KEBBI': ['ALR', 'KGW', 'ARG', 'AUG', 'BGD', 'BRK', 'BNZ', 'KMB', 'MHT', 'GWN', 'JEG', 'KLG', 'BES', 'MYM', 'WRR', 'DRD', 'SNA', 'DKG', 'RBH', 'YLW', 'ZUR'],
    'KOGI': ['DAV', 'AJA', 'KPA', 'BAS', 'KNA', 'NDG', 'DAH', 'AJK', 'JMU', 'KAB', 'KKF', 'LKJ', 'MPA', 'KFU', 'KPF', 'KKH', 'KNE', 'LAM', 'BJK', 'ERE', 'SAN'],
    'KWARA': ['AFN', 'KSB', 'LAF', 'ARP', 'SHA', 'KEY', 'FUF', 'LRN', 'MUN', 'WSN', 'KMA', 'BDU', 'FFA', 'LFF', 'LEM', 'PTG'],
    'LAGOS': ['GGE', 'AGL', 'KTU', 'FST', 'APP', 'BDG', 'EPE', 'EKY', 'AKD', 'FKJ', 'KJA', 'KRD', 'KSF', 'AAA', 'LND', 'MUS', 'JJJ', 'LSD', 'SMK', 'LSR'],
    'NASARAWA': ['AKW', 'AWE', 'DMA', 'KRV', 'KEN', 'KEF', 'GRU', 'LFA', 'NSW', 'NEG', 'NBB', 'WAM', 'NTT'],
    'NIGER': ['AGA', 'AGR', 'BDA', 'NBS', 'MAK', 'MNA', 'ENG', 'LMU', 'GWU', 'KHA', 'KNT', 'LAP', 'KUG', 'NAS', 'BMG', 'MSG', 'MKW', 'SRP', 'PAK', 'KAG', 'RJA', 'KUT', 'SUL', 'WSE', 'WSU'],
    'OGUN': ['AKM', 'AAB', 'OTA', 'TRE', 'FFF', 'AYE', 'LAR', 'GBE', 'JGB', 'JNE', 'JBD', 'KNN', 'MEK', 'PKA', 'WDE', 'DED', 'DGB', 'ABG', 'JRM', 'SMG'],
    'ONDO': ['KAK', 'ANG', 'SUA', 'KAA', 'AKR', 'JTA', 'GKB', 'WEN', 'FGB', 'GBA', 'LEL', 'REL', 'REF', 'KTP', 'NND', 'BDR', 'FFN', 'WWW'],
    'OSUN': ['SSU', 'PRN', 'GBN', 'LGB', 'TAN', 'RGB', 'EDE', 'EDT', 'AAW', 'EJG', 'PMD', 'FTD', 'FFE', 'FEE', 'FDY', 'KNR', 'LRG', 'LES', 'LEW', 'RLG', 'KRE', 'APM', 'WWD', 'BKN', 'DTN', 'BDS', 'GNN', 'JJS', 'FNN', 'SGB'],
    'OYO': ['JBL', 'MNY', 'FMT', 'TDE', 'EGB', 'BDJ', 'AGG', 'MRK', 'MAP', 'LUY', 'RUW', 'AYT', 'IRP', 'DDA', 'KSH', 'SEY', 'TUT', 'WEL', 'KEH', 'YNF', 'KNH', 'AME', 'AJW', 'GBY', 'YRE', 'AKN', 'GBH', 'KKY', 'JND', 'YYY', 'GMD', 'SHK', 'RSD'],
    'PLATEAU': ['BLD', 'BSA', 'BKK', 'ANW', 'JJN', 'BUU', 'DNG', 'KWK', 'LGT', 'MBD', 'MGU', 'TNK', 'PKN', 'QAP', 'RYM', 'SHD', 'WAS'],
    'RIVERS': ['ABU', 'AHD', 'KNM', 'ABM', 'NDN', 'BGM', 'BNY', 'DEG', 'NCH', 'MHA', 'KHE', 'KPR', 'SKP', 'BRR', 'RUM', 'RGM', 'GGU', 'KRK', 'BER', 'PBT', 'AFM', 'PHC', 'SKN'],
    'SOKOTO': ['BJN', 'DBN', 'DGS', 'GAD', 'GRY', 'BLE', 'GWD', 'LLA', 'SAA', 'KBE', 'KWR', 'RBA', 'SBN', 'SGR', 'SLM', 'SKK', 'SRZ', 'TBW', 'TGZ', 'TRT', 'WMK', 'WRN', 'YYB'],
    'TARABA': ['ARD', 'BAL', 'DGA', 'GKA', 'GAS', 'BBB', 'JAL', 'KLD', 'KRM', 'LAU', 'SDA', 'TTM', 'USS', 'WKR', 'YRR', 'TZG'],
    'YOBE': ['GSH', 'DPH', 'DTR', 'FKA', 'FUN', 'GDM', 'GJB', 'GLN', 'JAK', 'KRS', 'MCN', 'NNR', 'NGU', 'PKM', 'TMW', 'YUN', 'YSF'],
    'ZAMFARA': ['ANK', 'BKA', 'BKM', 'BUG', 'GMM', 'GUS', 'KRN', 'BMJ', 'MRD', 'MRR', 'SKF', 'TMA', 'TSF', 'ZRM']
  };

  static final List<String> _stateNames = [
    'ABIA',
    'ADAMAWA',
    'AKWA IBOM',
    'ANAMBRA',
    'BAUCHI',
    'BAYELSA',
    'BENUE',
    'BORNO',
    'CROSS RIVER',
    'DELTA',
    'EBONYI',
    'EDO',
    'EKITI',
    'ENUGU',
    'GOMBE',
    'IMO',
    'JIGAWA',
    'KADUNA',
    'KANO',
    'KATSINA',
    'KEBBI',
    'KOGI',
    'KWARA',
    'LAGOS',
    'NASARAWA',
    'NIGER',
    'OGUN',
    'ONDO',
    'OSUN',
    'OYO',
    'PLATEAU',
    'RIVERS',
    'SOKOTO',
    'TARABA',
    'YOBE',
    'ZAMFARA',
    'FCT'
  ];

  // Common OCR error substitutions
  static final Map<String, String> _commonTextErrors = {
    '0': 'O',
    '1': 'I',
    '2': 'Z',
    '5': 'S',
    '4': 'A',
    '6': 'G',
    '8': 'B',
    'C': 'G',
    'E': 'F',
    'D': '0',
    'I': 'L',
    'J': 'I',
    'M': 'N',
    'O': 'Q',
    'P': 'R',
    'U': 'V',
    'Y': 'V',
    'H': 'A',
    'K': 'X',
    'T': 'I',
    'W': 'VV',
  };

  static final Map<String, String> _commonNumberErrors = {
    'O': '0',
    'I': '1',
    'S': '5',
    'A': '4',
    'B': '8',
    'Z': '2',
    'G': '6',
  };

  static String cleanPlateNumber(List<String> lines) {
    if (lines.isEmpty) return '';

    print('Input lines: $lines');

    // Step 1: Try to detect state from first line
    String detectedState = _detectStateFromFirstLine(lines);
    print('State from first line: $detectedState');

    // Step 2: Find plate number candidate
    String plateCandidate = _findPlateCandidateInLines(lines);
    print('Found plate candidate: $plateCandidate');

    if (plateCandidate.isEmpty) return '';

    // Step 3: If no state detected from first line, try to infer from LGA
    if (detectedState.isEmpty) {
      detectedState = _inferStateFromLGA(plateCandidate);
      print('State inferred from LGA: $detectedState');
    }

    if (detectedState.isEmpty) return '';

    // Step 4: Clean and validate the plate number
    String cleanedPlate = _cleanAndValidatePlate(plateCandidate, detectedState);
    print('Cleaned plate: $cleanedPlate');

    return cleanedPlate;
  }

  static String _detectStateFromFirstLine(List<String> lines) {
    if (lines.isEmpty) return '';

    String firstLine = lines.first.trim().toUpperCase();
    print('Checking first line for state: $firstLine');

    // First check for exact matches
    for (String state in _stateNames) {
      if (firstLine == state || firstLine.contains(state) || state.contains(firstLine)) {
        print('Found exact state match: $state');
        return state;
      }
    }

    // Then try with common text error corrections
    String cleanedLine = firstLine;
    for (var entry in _commonTextErrors.entries) {
      cleanedLine = cleanedLine.replaceAll(entry.key, entry.value);
    }

    for (String state in _stateNames) {
      if (cleanedLine == state || cleanedLine.contains(state) || state.contains(cleanedLine)) {
        print('Found state match after cleaning: $state');
        return state;
      }
    }

    // Finally try fuzzy matching
    String? bestMatch;
    int bestDistance = double.maxFinite.toInt();

    for (String state in _stateNames) {
      int distance = _levenshteinDistance(firstLine, state);
      if (distance < bestDistance && distance <= state.length ~/ 2) {
        bestDistance = distance;
        bestMatch = state;
      }
    }

    if (bestMatch != null) {
      print('Found state through fuzzy matching: $bestMatch');
      return bestMatch;
    }

    return '';
  }

  static String _inferStateFromLGA(String plateCandidate) {
    if (plateCandidate.length < 3) return '';

    String lgaCode = plateCandidate.substring(0, 3);
    print('Checking LGA code: $lgaCode');

    // First check if LGA exists as-is in any state
    for (var entry in _stateLGAs.entries) {
      if (entry.value.contains(lgaCode)) {
        print('Found exact LGA match in state: ${entry.key}');
        return entry.key;
      }
    }

    return '';
  }

  static String _findPlateCandidateInLines(List<String> lines) {
    final patterns = [
      // Original patterns
      RegExp(r'[A-Z]{3}[-\s]?[0-9]{3}[A-Z]{2}'),
      RegExp(r'[A-Z]{3}[-\s]?[0-9]{3}[-\s]?[A-Z]{2}'),
      RegExp(r'[A-Z0-9]{3}[-\s]?[0-9]{3}[-\s]?[A-Z0-9]{2}'),
      // New patterns for handling OCR errors
      RegExp(r'[A-Z0-9]{3,4}[-\s]?[0-9]{2,3}[A-Z0-9]{1,2}'),
      // Pattern specifically for cases where numbers might be mixed in the letters section
      RegExp(r'[A-Z]{3}[A-Z0-9]{1,2}[0-9]{2,3}[A-Z0-9]{1,2}')
    ];

    for (String line in lines) {
      String cleanedLine = line.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9-\s]'), '');
      print('Checking line: $cleanedLine');

      for (var pattern in patterns) {
        var match = pattern.firstMatch(cleanedLine);
        if (match != null) {
          String candidate = match.group(0) ?? '';
          print('Found match with pattern: ${pattern.pattern}');
          return candidate;
        }
      }
    }

    // Try joining adjacent lines
    for (int i = 0; i < lines.length - 1; i++) {
      String combined = '${lines[i]} ${lines[i + 1]}'.trim().toUpperCase();
      combined = combined.replaceAll(RegExp(r'[^A-Z0-9-\s]'), '');
      print('Checking combined lines: $combined');

      for (var pattern in patterns) {
        var match = pattern.firstMatch(combined);
        if (match != null) {
          return match.group(0) ?? '';
        }
      }
    }

    return '';
  }

  static String _cleanAndValidatePlate(String plate, String state) {
    String cleaned = plate.replaceAll(RegExp(r'[-\s]'), '');
    if (cleaned.length != 8) return '';

    String lga = cleaned.substring(0, 3);
    String numbers = cleaned.substring(3, 6);
    String letters = cleaned.substring(6);

    print('Splitting plate: LGA=$lga, numbers=$numbers, letters=$letters');

    // Clean each section
    String cleanedLGA = _cleanLGAForState(lga, state);
    String cleanedNumbers = _cleanNumbersSection(numbers);
    String cleanedLetters = _cleanLettersSection(letters);

    print('Cleaned sections: LGA=$cleanedLGA, numbers=$cleanedNumbers, letters=$cleanedLetters');

    // All sections must be valid for the plate to be valid
    if (cleanedLGA.isNotEmpty && cleanedNumbers.isNotEmpty && cleanedLetters.isNotEmpty) {
      return '$cleanedLGA-$cleanedNumbers$cleanedLetters';
    }

    return '';
  }

  static String _cleanLGAForState(String lga, String state) {
    print('Cleaning LGA "$lga" for state "$state"');

    // Check if LGA exists as-is
    if (_stateLGAs[state]?.contains(lga) ?? false) {
      print('LGA exists as-is');
      return lga;
    }

    // Get valid LGAs for the state
    List<String> validLGAs = _stateLGAs[state] ?? [];
    print('Valid LGAs for $state: $validLGAs');

    // Step 1: Find closest matching LGA
    String? bestMatch;
    int bestDistance = double.maxFinite.toInt();

    for (String validLGA in validLGAs) {
      // First try exact character matching
      int matchingChars = 0;
      for (int i = 0; i < min(lga.length, validLGA.length); i++) {
        if (lga[i] == validLGA[i]) matchingChars++;
      }

      // If we have at least 2 matching characters, calculate Levenshtein distance
      if (matchingChars >= 2) {
        int distance = _levenshteinDistance(lga, validLGA);
        print('Comparing $lga with $validLGA: distance=$distance, matching chars=$matchingChars');

        // Update best match if this is better
        if (distance < bestDistance || (distance == bestDistance && matchingChars > 2)) {
          bestDistance = distance;
          bestMatch = validLGA;
          print('New best match: $validLGA (distance: $distance)');
        }
      }
    }

    // Accept match if distance is small enough (relative to length)
    if (bestMatch != null && bestDistance <= 1) {
      print('Found close match: $bestMatch (distance: $bestDistance)');
      return bestMatch;
    }

    // If no close match found, try character substitutions
    String cleaned = lga;
    for (var entry in _commonTextErrors.entries) {
      cleaned = cleaned.replaceAll(entry.key, entry.value);
      if (validLGAs.contains(cleaned)) {
        print('Found match after substitution: $cleaned');
        return cleaned;
      }
    }

    // If still no match but we have a best match with distance <= 2, use it
    if (bestMatch != null && bestDistance <= 2) {
      print('Using best available match: $bestMatch (distance: $bestDistance)');
      return bestMatch;
    }

    print('No valid match found for LGA $lga');
    return lga;  // Return original instead of empty string
  }

  static String _cleanNumbersSection(String numbers) {
    String cleaned = numbers;
    for (var entry in _commonNumberErrors.entries) {
      cleaned = cleaned.replaceAll(entry.key, entry.value);
    }

    return RegExp(r'^[0-9]{3}$').hasMatch(cleaned) ? cleaned : numbers;
  }

  static String _cleanLettersSection(String letters) {
    // Both characters in the letters section must be letters
    // First try to convert any numbers to their letter equivalents
    String cleaned = letters;
    for (var entry in _commonTextErrors.entries) {
      // Only apply number-to-letter conversions
      if (RegExp(r'[0-9]').hasMatch(entry.key)) {
        cleaned = cleaned.replaceAll(entry.key, entry.value);
      }
    }

    // After substitutions, verify that we have only letters
    if (RegExp(r'^[A-Z]{2}$').hasMatch(cleaned)) {
      print('Cleaned letters section from $letters to $cleaned');
      return cleaned;
    }

    print('Failed to clean letters section: $letters');
    return ''; // Return empty if we can't get valid letters
  }

  static int _levenshteinDistance(String s1, String s2) {
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<int> v0 = List<int>.generate(s2.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(s2.length + 1, 0);

    for (int i = 0; i < s1.length; i++) {
      v1[0] = i + 1;

      for (int j = 0; j < s2.length; j++) {
        int cost = (s1[i] == s2[j]) ? 0 : 1;
        v1[j + 1] = [v1[j] + 1, v0[j + 1] + 1, v0[j] + cost].reduce(min);
      }

      List<int> tmp = v0;
      v0 = v1;
      v1 = tmp;
    }

    return v0[s2.length];
  }
}
