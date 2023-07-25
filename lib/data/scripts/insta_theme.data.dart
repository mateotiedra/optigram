import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:optigram/data/config/theme.data.dart';

class Scripts {
  static UserScript restyle() {
    String setColorPropertiesScript = "";

    ThemeConfig.colorPalette.forEach((key, value) {
      setColorPropertiesScript += "dom.style.setProperty('--$key', '${value.red}, ${value.green}, ${value.blue}');";
    });

    return UserScript(
        groupName: "myUserScripts",
        source: """
        window.addEventListener('load', function(event) {
          var dom = document.documentElement;
          $setColorPropertiesScript
        });

        const observer = new MutationObserver((_, __)=>{
          // Change the background color of the messages
          document.querySelectorAll('div[style*="rgb(55, 151, 240)"').forEach((elem)=>{elem.style.backgroundColor = "${ThemeConfig.colorPalette['ig-primary-button']?.red}, ${ThemeConfig.colorPalette['ig-primary-button']?.green}, ${ThemeConfig.colorPalette['ig-primary-button']?.blue}"});

          // Change the icon colors
          document.querySelectorAll('svg[color*="rgb(0, 149, 246)"').forEach((elem)=>{elem.style.color = "rgb(${ThemeConfig.colorPalette['ig-primary-button']?.red}, ${ThemeConfig.colorPalette['ig-primary-button']?.green}, ${ThemeConfig.colorPalette['ig-primary-button']?.blue})"});

          // Remove all posts
          const postContainer = document.querySelector('div[style*="max-width: 470px;"]');
          postContainer.style.display='none' 

          // Remove the svg loading animation
          const loadingSvg = document.querySelector('svg[aria-label*="Loading..."]');
          if(loadingSvg) loadingSvg.style.display = "none";

          //Remove the 'Use the App' button
          document.querySelectorAll('button[type="button"]').forEach((elem)=>{
            if(elem.innerHTML.contains('Use the App')) elem.style.display = "none";
          });
        });
        observer.observe(document.documentElement, {
          childList: true,
          subtree: true
        });
        """,
        //dom.innerHTML = (dom.innerHTML.replace('style="background-color: rgb(55, 151, 240); padding: 7px 12px;"', 'style="background-color: rgb(125, 106, 246); padding: 7px 12px;"'));
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START);
  }
}
