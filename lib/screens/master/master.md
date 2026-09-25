RbsCloneApp                                                                     Stateless
    MaterialApp
        ConnectionGateKeeper                                                    Stateful
            ValueListenableBuilder
            -   WaitScreen
                    Scaffold
                        SaveArea
            -   ErrorScreen
                    Scaffold
                        SaveArea
            -   AppScreen                                                        Stateful
                -   Scaffold (AppBar, Drawer)                                    _buildMobileLayout
                        SafeArea
                            Padding
                                Row
                                    Expanded
                                        _buildMainContent (Single)
                -   Scaffold (AppBar, Drawer)                                   _buildTabletLayout
                        SafeArea
                            Padding
                                Row
                                    Expanded
                                        _buildMainContent (Both)
                -   Scaffold (AppBar)                                           _buildDesktopLayout
                        SafeArea
                            Padding
                                Row
                                +   SizedBox
                                        HierarchicalNavigationMenu
                                +   SizedBox
                                +   Expanded
                                        _buildMainContent (Both)
