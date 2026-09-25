import 'package:flutter/material.dart';
import 'package:rbsclone_flutter/widgets/custom_appbar.dart';
import 'package:rbsclone_flutter/widgets/hierarchical_navigation_menu.dart';
import 'package:rbsclone_flutter/widgets/placeholder_page.dart';

import 'master/country/country_module.dart';
import 'master/custodian/custodian_module.dart';
import 'master/exchange/exchange_module.dart';

/// Breakpoints for responsive Design
/// - Mobile: < 600 dp (Smartphones)
/// - Tablet: 600 - 1200 dp
/// - Desktop: >= 1200 dp
class ResponsiveBreakpoints {
  static const double mobileMax = 800;
  static const double tabletMax = 1200;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileMax;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMax && width < tabletMax;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletMax;
  }

  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileMax) return ScreenSize.mobile;
    if (width < tabletMax) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }
}

enum ScreenSize { mobile, tablet, desktop }

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  NavigationId _navigationId = NavigationId.welcome;

  String _caption = "Bitte wählen Sie ein Funktion aus!";

  bool menuEnabled = true;

  void onMenuEnable(bool enable) {
    setState(() {
      menuEnabled = enable;
    });
  }

  Widget _buildMainContent(bool mobileMode) {
    switch (_navigationId) {
      case NavigationId.welcome:
        return const PlaceholderPage(title: 'Willkommen!');

      case NavigationId.country:
        return CountryDataModule(mobileMode, menuEnableCallback: onMenuEnable);

      case NavigationId.custodian:
        return CustodianDataModule(
          mobileMode,
          menuEnableCallback: onMenuEnable,
        );

      case NavigationId.exchange:
        return ExchangeDataModule(mobileMode, menuEnableCallback: onMenuEnable);

      default:
        return const PlaceholderPage(title: 'In Arbeit');
    }
  }

  //----------------------------------------------------------------------------

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(_caption, drawerEnabled: menuEnabled),
      drawer: Drawer(
        child: NavigationMenu(
          menuEnabled: menuEnabled,
          onItemSelected: (item) {
            if (item.children.isEmpty) {
              setState(() {
                _navigationId = item.navigationId;
                _caption = item.caption;
              });
            }
            Navigator.pop(context); // Menü schließen
          },
          selectedNavigationId: _navigationId,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(children: [Expanded(child: _buildMainContent(true))]),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(_caption, drawerEnabled: menuEnabled),
      drawer: Drawer(
        child: NavigationMenu(
          menuEnabled: menuEnabled,
          onItemSelected: (item) {
            if (item.children.isEmpty) {
              setState(() {
                _navigationId = item.navigationId;
                _caption = item.caption;
              });
            }
            Navigator.pop(context); // Menü schließen
          },
          selectedNavigationId: _navigationId,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(children: [Expanded(child: _buildMainContent(false))]),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(_caption, drawerEnabled: menuEnabled),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 250,
                child: NavigationMenu(
                  menuEnabled: menuEnabled,
                  onItemSelected: (item) {
                    if (item.children.isEmpty) {
                      setState(() {
                        _navigationId = item.navigationId;
                        _caption = item.caption;
                      });
                    }
                  },
                  selectedNavigationId: _navigationId,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildMainContent(false)),
            ],
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveBreakpoints.getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return _buildMobileLayout(context);
      case ScreenSize.tablet:
        return _buildTabletLayout(context);
      case ScreenSize.desktop:
        return _buildDesktopLayout(context);
    }
  }
}
