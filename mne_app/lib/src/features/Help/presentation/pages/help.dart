import 'package:flutter/material.dart';
import '../../../../core/ui/top_bar_widget.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  Widget _getHelpRowItem(
    context, {
    required iconPath,
    required title,
    required subTitle,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.15,
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            iconPath,
            width: 24,
          ),
          const SizedBox(width: 15),
          Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                subTitle,
                style: const TextStyle(
                  fontSize: 17.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBarWidget(
        isBack: true,
        title: "Help",
        onClick: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _getHelpRowItem(
              context,
              iconPath: "assets/images/message_icon.png",
              title: "Write an Email to Us",
              subTitle: "someone@something.com",
            ),
            _getHelpRowItem(
              context,
              iconPath: "assets/images/phone_icon.png",
              title: "Call Us 09:00-11:59",
              subTitle: "+971 12345678996",
            ),
            Column(
              children: [
                const Text(
                  "Follow Us",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(36.0),
                      child: Image.asset(
                        "assets/images/facebook_icon.png",
                        width: 36,
                      ),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(36.0),
                      child: Image.asset(
                        "assets/images/linkedin_icon.png",
                        width: 36,
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
