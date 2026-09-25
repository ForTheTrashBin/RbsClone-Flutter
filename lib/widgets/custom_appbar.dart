import 'package:flutter/material.dart';

//------------------------------------------------------------------------------

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar(this.caption, {this.drawerEnabled = true, super.key});

  final String caption;
  final bool drawerEnabled;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<StatefulWidget> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final hasDrawer = Scaffold.of(context).hasDrawer;

    return AppBar(
      iconTheme: hasDrawer && !widget.drawerEnabled
          ? IconTheme.of(context)
                .copyWith(color: IconTheme.of(context).color?.withAlpha(64))
          : null,
      leading: hasDrawer && !widget.drawerEnabled ? Icon(Icons.menu) : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("RbsClone"),
          Opacity(
            opacity: 0.7,
            child: Text(
              widget.caption,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize:
                    Theme.of(context).textTheme.titleLarge!.fontSize! * 0.7,
              ),
            ),
          ),
        ],
      ),
      // scrolledUnderElevation: 0,
      // backgroundColor: Colors.transparent,
      // elevation: 0,
    );
  }
}
