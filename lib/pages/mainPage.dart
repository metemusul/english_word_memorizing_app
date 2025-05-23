

import 'package:english_word_app/colors/generallyColors.dart';
import 'package:english_word_app/global_widget/app_bar.dart';
import 'package:english_word_app/pages/lists_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';


class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {

static const _url = "https://flutter.dev";

Lang? _chooseLang = Lang.english;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

late PackageInfo packageInfo;
String version = " ";

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    package_info_init();
  }

void package_info_init() async{
  

   packageInfo = await PackageInfo.fromPlatform();
   setState(() {
     version = packageInfo.version;
   });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer:SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width*0.5,
          color: firsColors.primaryWhiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
              Image.asset("assets/images/logo.png",),
              Text("Qwordazy",style: TextStyle(fontSize: 26),),
              Text("İtediğini Öğren",style: TextStyle(fontSize: 16),),
              SizedBox(width:MediaQuery.of(context).size.width*0.35 ,child: Divider(color: Colors.black,)),
              Container(margin: EdgeInsets.only(top: 50,right: 8,left: 8),child: Text("Bu uygulamanın nasıl yapışdığını öğrenmek ve bu tarz uygulamalar geliştirmek için ",style: TextStyle(fontSize: 16),textAlign: TextAlign.center,)),
              InkWell(onTap: () async{
                await canLaunch(_url) ? launch(_url) : throw "Couldn not launch $_url";
              },child: Text("Tıkla",style: TextStyle(fontSize: 16,color: Colors.blue),)),
                ],
              ),

              Text("v"+version+"\nmusulmete129@gmail.com",style: TextStyle(fontSize: 16,color: Colors.blue,),textAlign: TextAlign.center),
            ],
          ),
          ),
      ) ,
      appBar: appBar(context,
       left: FaIcon(FontAwesomeIcons.bars,color: Colors.black,size: 20,),
        center:  Text("QWorDaZy",style: TextStyle(color: Colors.black,fontFamily: "lucky",fontSize: 25),),
        leftWidgetonClick:()=>{_scaffoldKey.currentState!.openDrawer()}
         ),

    
      body: SafeArea(
        child: Container(
          color: firsColors.primaryWhiteColor,
          child: Center(
            child: Column(
              children: [
                langRadioButton(text: "English - Türkçe",group: _chooseLang,value: Lang.turkish),
                langRadioButton(text: "Türkçe - English",group: _chooseLang,value: Lang.english),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ListsPage()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text("Listelerim",style: TextStyle(fontSize: 24,color: firsColors.primaryWhiteColor,fontFamily: "carter")),
                    width: MediaQuery.of(context).size.width*0.8,
                   
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          const Color.fromARGB(255, 68, 16, 151),
                          const Color.fromARGB(255, 34, 10, 66),
                         
                      
                  
                        ]
                      ),
                      
                      
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    
                    
                    children: [
                       mainPageCard(startColor: Color.fromARGB(255, 27, 204, 166),endColor:Color.fromARGB(255, 17, 105, 93) ,title: "Kelime Kartları",icon: Icon(Icons.file_copy,color: firsColors.primaryWhiteColor,)),
                       mainPageCard(startColor: Color.fromARGB(32, 204, 25, 228),endColor:Color.fromARGB(255, 75, 6, 75) ,title: "Çoktan Seçmeli",icon: Icon(Icons.radio_button_checked,color: firsColors.primaryWhiteColor,))
                     

                    ],
                  ),
                )
              ],
            ),
          ),
          
        ),
      ),
    );
  }

  Container mainPageCard({required Color startColor, required Color endColor,required String title , required Icon icon}) {
    return Container(
                  alignment: Alignment.centerLeft,
                  height: 200,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(title,style: TextStyle(fontSize: 24,color: firsColors.primaryWhiteColor,fontFamily: "carter"),textAlign: TextAlign.center,),
                     icon
                    ],
                  ),
                  
                   
                  width: MediaQuery.of(context).size.width*0.36,
                 
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
                );
  }

  SizedBox langRadioButton({required String text,required Lang value,required Lang ?group}) {
    return SizedBox(width: 200,
                child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                  title: Text(text!,style:TextStyle(fontFamily: "carter",fontSize: 15) ),
                  leading: Radio<Lang>(
                    value: value,
                    groupValue: group,
                    onChanged: (Lang? value) {
                      setState(() {
                        _chooseLang = value;
                      });
                    }
                  )
                ),
              );
  }
}


enum Lang { english, turkish }