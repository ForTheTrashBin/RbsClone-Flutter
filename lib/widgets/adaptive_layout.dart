import 'package:flutter/material.dart';

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

/// AdaptiveLayout für Master-Detail-Muster
///
/// Passt die Anzeige automatisch an die Bildschirmgröße an:
/// - Mobile: Ein Panel zur Zeit (Menü oder Liste oder Detail)
/// - Tablet: Menü + Liste oder Liste + Detail nebeneinander
/// - Desktop: Alle drei Panels nebeneinander
class AdaptiveLayout extends StatefulWidget {
  const AdaptiveLayout({
    required this.navigationRail,
    required this.masterListPanel,
    required this.detailPanel,
    required this.onMobileNavigationChanged,
    super.key,
  });

  /// Die NavigationRail für große Bildschirme
  final Widget navigationRail;

  /// Das Master-List-Panel (z.B. Länder-Liste)
  final Widget masterListPanel;

  /// Das Detail-Panel (z.B. Land-Detailansicht)
  final Widget detailPanel;

  /// Callback wenn sich der Mobile-Modus-Status ändert
  /// Werte: 0 = Menü, 1 = Liste, 2 = Detail
  final ValueChanged<int>? onMobileNavigationChanged;

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}

class _AdaptiveLayoutState extends State<AdaptiveLayout> {
  /// Für Mobile/Tablet: Welcher Screen soll angezeigt werden
  /// 0 = Navigation/Menü, 1 = Liste, 2 = Detail
  int _mobileCurrentView = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveBreakpoints.getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return _buildMobileLayout();

      case ScreenSize.tablet:
        return _buildTabletLayout();

      case ScreenSize.desktop:
        return _buildDesktopLayout();
    }
  }

  /// Mobile Layout: Ein Screen zur Zeit
  /// Bottom Navigation ermöglicht schnellen Wechsel
  Widget _buildMobileLayout() {
    return Scaffold(
      body: IndexedStack(
        index: _mobileCurrentView,
        children: [
          // View 0: Navigation Rail / Menü
          widget.navigationRail,

          // View 1: Master List Panel
          PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                setState(() => _mobileCurrentView = 0);
              }
            },
            child: widget.masterListPanel,
          ),

          // View 2: Detail Panel
          PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                setState(() => _mobileCurrentView = 1);
              }
            },
            child: widget.detailPanel,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _mobileCurrentView,
        onTap: (index) {
          setState(() {
            _mobileCurrentView = index;
            widget.onMobileNavigationChanged?.call(index);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menü'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Liste'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Details'),
        ],
      ),
    );
  }

  /// Tablet Layout: Menü + (Liste oder Detail)
  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Menü (Linke Seite)
        SizedBox(width: 100, child: widget.navigationRail),
        const SizedBox(width: 8),
        // Liste oder Detail (Rechte Seite)
        Expanded(
          child: _mobileCurrentView == 0
              ? widget.masterListPanel
              : widget.detailPanel,
        ),
      ],
    );
  }

  /// Desktop Layout: Alle drei Panels nebeneinander
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Navigation Rail (links)
        widget.navigationRail,
        const SizedBox(width: 8),

        // Master List Panel (mitte)
        Expanded(flex: 2, child: widget.masterListPanel),
        const SizedBox(width: 16),

        // Detail Panel (rechts)
        Expanded(flex: 3, child: widget.detailPanel),
      ],
    );
  }
}
