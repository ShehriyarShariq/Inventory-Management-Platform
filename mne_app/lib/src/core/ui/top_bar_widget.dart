import 'package:flutter/material.dart';

class TopBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBack, hasNotifIcon, isDisabled;
  final Function onClick;

  const TopBarWidget({
    Key? key,
    this.title = "",
    this.isBack = true,
    required this.onClick,
    this.hasNotifIcon = false,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      toolbarHeight: 60.0,
      automaticallyImplyLeading: false,
      backgroundColor:
          isDisabled ? Colors.black.withOpacity(0.6) : Colors.white,
      title: Container(
        height: 60.0,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: MediaQuery.of(context).size.width * 0.05,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromRGBO(238, 38, 49, 1),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: isDisabled ? () => {} : () => onClick(),
                      child: SizedBox(
                        width: 35,
                        height: 35,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            isBack
                                ? "assets/images/back_icon.png"
                                : "assets/images/menu_icon.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isDisabled
                ? Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    left: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  )
                : const SizedBox(),
            hasNotifIcon
                ? Positioned(
                    top: 0,
                    bottom: 0,
                    right: MediaQuery.of(context).size.width * 0.05,
                    width: 34.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Image.asset("assets/images/notif_icon.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
