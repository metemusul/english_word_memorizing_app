import 'package:english_word_app/colors/generallyColors.dart';
import 'package:english_word_app/global_variable.dart';
import 'package:english_word_app/global_widget/app_bar.dart';
import 'package:english_word_app/pages/lists_page.dart';
import 'package:english_word_app/pages/multiple_choice.dart';
import 'package:english_word_app/pages/words_card.dart';
import 'package:english_word_app/pages/create_list.dart';
import 'package:english_word_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:english_word_app/widgets/custom_bottom_nav_bar.dart';
import 'package:english_word_app/pages/ai_translate_page.dart';
import 'package:english_word_app/screens/story_builder_page.dart';
import 'package:english_word_app/screens/ai_sentence_builder_page.dart';
import 'package:english_word_app/screens/profile_page.dart';
import 'dart:math';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  static const _url = "https://flutter.dev";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late PackageInfo packageInfo;
  String version = " ";

  // Bottom Navigation Bar için gerekli değişkenler
  int _bottomNavIndex = 0;
  final List<IconData> _icons = [
    Icons.home,
    Icons.list,
    Icons.auto_stories,
    Icons.psychology,
    Icons.translate,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
    _initializeMobileAds();
    package_info_init();
  }

  Future<void> _initializeMobileAds() async {
    try {
      print('Initializing MobileAds...');
      await MobileAds.instance.initialize();
      print('MobileAds initialized successfully');
      _loadBannerAd();
    } catch (e) {
      print('Error initializing MobileAds: $e');
    }
  }

  void _loadBannerAd() {
    try {
      print('Starting to load banner ad...');
      _bannerAd = BannerAd(
        adUnitId: "ca-app-pub-3940256099942544/6300978111", // Test banner ID
        size: AdSize.banner, // En basit banner boyutu
        request: AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            print('Banner ad loaded successfully');
            setState(() {
              _isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('Banner ad failed to load: ${error.message}');
            print('Banner ad failed to load error code: ${error.code}');
            print('Banner ad failed to load domain: ${error.domain}');
            ad.dispose();
            setState(() {
              _isAdLoaded = false;
            });
            // Hata durumunda 5 saniye sonra tekrar dene
            Future.delayed(Duration(seconds: 5), () {
              if (mounted) {
                print('Retrying to load banner ad...');
                _loadBannerAd();
              }
            });
          },
          onAdOpened: (Ad ad) => print('Banner ad opened'),
          onAdClosed: (Ad ad) => print('Banner ad closed'),
          onAdImpression: (Ad ad) => print('Banner ad impression'),
          onAdClicked: (Ad ad) => print('Banner ad clicked'),
        ),
      );

      print('Calling load() on banner ad...');
      _bannerAd?.load();
    } catch (e) {
      print('Error loading banner ad: $e');
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void package_info_init() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(
        context,
        left: Icon(Icons.menu, color: firsColors.primaryBlackColor, size: 22),
        center: Text("QWorDaZy", style: TextStyle(color: Colors.black, fontFamily: "lucky", fontSize: 25)),
        right: Image.asset("assets/images/logo.png"),
        leftWidgetonClick: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: drawer(),
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _bottomNavIndex,
        icons: _icons,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        backgroundColor: Colors.black87,
        activeColor: const Color.fromARGB(255, 233, 132, 16),
        inactiveColor: Colors.grey,
      ),
    );
  }

  Widget _buildBody() {
    switch (_bottomNavIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return ListsPage();
      case 2:
        return const StoryBuilderPage();
      case 3:
        return const AISentenceBuilderPage();
      case 4:
        return AiTranslatePage();
      case 5:
        return const ProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColors = [
      [Color(0xFF6C63FF), Color(0xFFB388FF)],
      [Color(0xFFFFB300), Color(0xFFFFE082)],
      [Color(0xFF26C6DA), Color(0xFFB2EBF2)],
      [Color(0xFF66BB6A), Color(0xFFC8E6C9)],
      [Color(0xFFEF5350), Color(0xFFFFCDD2)],
      [Color(0xFFAB47BC), Color(0xFFE1BEE7)],
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    langRadioButton(text: "İngilizce-Türkçe", value: Lang.english, group: chooseLang),
                    langRadioButton(text: "Türkçe-İngilizce", value: Lang.turkish, group: chooseLang),
                  ],
                ),
              ),
              Text("QWorDaZy", style: TextStyle(color: theme.colorScheme.primary, fontFamily: "lucky", fontSize: 40)),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _AnimatedMainCard(
                  startColor: cardColors[0][0],
                  endColor: cardColors[0][1],
                  title: "Kelime Kartları",
                  icon: Icons.file_copy,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WordsCardPage()));
                  },
                ),
                _AnimatedMainCard(
                  startColor: cardColors[1][0],
                  endColor: cardColors[1][1],
                  title: "Çoktan Seçmeli",
                  icon: Icons.radio_button_checked,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MultipleChoice()));
                  },
                ),
              ],
            ),
          ),
          if (_isAdLoaded && _bannerAd != null)
            Container(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
        ],
      ),
    );
  }

  InkWell mainPageCard({required Color startColor, required Color endColor, required String title, required Icon icon, required VoidCallback func}) {
    return InkWell(
      onTap: func,
      child: Container(
        alignment: Alignment.centerLeft,
        height: 200,
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(title, style: TextStyle(fontSize: 24, color: firsColors.primaryWhiteColor, fontFamily: "carter"), textAlign: TextAlign.center,),
            icon
          ],
        ),

        width: MediaQuery.of(context).size.width * 0.36,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              startColor,
              endColor,
            ]
          ),
        ),
      ),
    );
  }

  SizedBox langRadioButton({required String text, required Lang value, required Lang ?group}) {
    return SizedBox(width: 200,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(text!, style: TextStyle(fontFamily: "carter", fontSize: 15)),
        leading: Radio<Lang>(
          value: value,
          groupValue: group,
          onChanged: (Lang? value) {
            setState(() {
              chooseLang = value;
            });
          }
        )
      ),
    );
  }

  Widget drawer() {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Image.asset("assets/images/logo.png"),
                Text("Qwordazy", style: TextStyle(fontSize: 26)),
                Text("İstediğini Öğren", style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Divider(color: Colors.black)
                ),
                Container(
                  margin: EdgeInsets.only(top: 50, right: 8, left: 8),
                  child: Text(
                    "Bu uygulamanın nasıl yapışdığını öğrenmek ve bu tarz uygulamalar geliştirmek için ",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  )
                ),
                InkWell(
                  onTap: () async {
                    await canLaunch(_url) ? launch(_url) : throw "Couldn not launch $_url";
                  },
                  child: Text("Tıkla", style: TextStyle(fontSize: 16, color: Colors.blue))
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "v" + version,
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 8),
                Text(
                  "musulmete129@gmail.com",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Çıkış yapma işlemi
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text('Çıkış Yap'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedMainCard extends StatefulWidget {
  final Color startColor;
  final Color endColor;
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _AnimatedMainCard({required this.startColor, required this.endColor, required this.title, required this.icon, required this.onTap});

  @override
  State<_AnimatedMainCard> createState() => _AnimatedMainCardState();
}

class _AnimatedMainCardState extends State<_AnimatedMainCard> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _controller.addListener(() {
      setState(() {
        _scale = 1 - _controller.value * 0.07;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          alignment: Alignment.center,
          height: 180,
          width: MediaQuery.of(context).size.width * 0.38,
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(widget.title, style: TextStyle(fontSize: 22, color: theme.colorScheme.onPrimary, fontFamily: "carter"), textAlign: TextAlign.center,),
              Icon(widget.icon, color: theme.colorScheme.onPrimary, size: 48),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                widget.startColor,
                widget.endColor,
              ]
            ),
            boxShadow: [
              BoxShadow(
                color: widget.startColor.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


