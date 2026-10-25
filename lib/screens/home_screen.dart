import 'package:flutter/cupertino.dart';

import '../app_theme.dart';
import '../models/booking.dart';
import '../models/stay.dart';
import '../data/stays_data.dart';
import '../widgets/stay_card.dart';
import 'placeholder_page.dart';
import 'stay_detail_screen.dart';
import 'trips_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CupertinoTabController _tabController = CupertinoTabController();

  final ScrollController _exploreScrollController = ScrollController();

  String selectedCategory = 'All';
  String searchQuery = '';

  final Set<String> favorites = {};
  final List<Booking> _bookings = [];

  final categories = const [
    ('All', CupertinoIcons.compass),
    ('Amazing views', CupertinoIcons.sun_max),
    ('Beachfront', CupertinoIcons.drop),
    ('Cabins', CupertinoIcons.house),
    ('Amazing pools', CupertinoIcons.drop),
  ];

  List<Stay> get filteredStays {
    final query = searchQuery.trim().toLowerCase();

    return stays.where((stay) {
      final categoryMatch =
          selectedCategory == 'All' || stay.category == selectedCategory;

      final searchMatch =
          query.isEmpty ||
          stay.location.toLowerCase().contains(query) ||
          stay.name.toLowerCase().contains(query);

      return categoryMatch && searchMatch;
    }).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _exploreScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        activeColor: coral,
        inactiveColor: CupertinoColors.systemGrey,
        backgroundColor: CupertinoColors.systemBackground.withValues(
          alpha: 0.96,
        ),
        border: const Border(
          top: BorderSide(color: Color(0xFFE8E8E8), width: 0.5),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            activeIcon: Icon(CupertinoIcons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            activeIcon: Icon(CupertinoIcons.heart_fill),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.ticket),
            activeIcon: Icon(CupertinoIcons.ticket_fill),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (_) => _buildExplore());

          case 1:
            return CupertinoTabView(builder: (_) => _buildWishlist());

          case 2:
            return CupertinoTabView(
              builder: (_) => TripsScreen(
                bookings: _bookings,
                onExplore: () => _tabController.index = 0,
              ),
            );

          default:
            return const CupertinoTabView(builder: _buildProfilePage);
        }
      },
    );
  }

  static Widget _buildProfilePage(BuildContext context) {
    return const PlaceholderPage(
      icon: CupertinoIcons.person_crop_circle,
      title: 'Your profile',
      message: 'Your account and settings will live here.',
    );
  }

  Widget _buildExplore() {
    return CupertinoPageScaffold(
      backgroundColor: pageBackground,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          key: const PageStorageKey<String>('explore-scroll'),
          controller: _exploreScrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEEEE),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        CupertinoIcons.house_fill,
                        color: coral,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'stayly',
                      style: TextStyle(
                        color: coral,
                        fontSize: 29,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.3,
                      ),
                    ),
                    const Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 40),
                      onPressed: () {
                        _tabController.index = 3;
                      },
                      child: const Icon(
                        CupertinoIcons.person_crop_circle,
                        color: ink,
                        size: 29,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: _buildSearchBar()),

            SliverToBoxAdapter(child: _buildCategories()),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Places to stay',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: ink,
                          letterSpacing: -0.7,
                        ),
                      ),
                    ),
                    Text(
                      '${filteredStays.length} stays',
                      style: const TextStyle(color: muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            if (filteredStays.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(36),
                  child: Text(
                    'No stays found. Try another destination.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 15),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final stay = filteredStays[index];

                      return StayCard(
                        key: ValueKey(stay.name),
                        stay: stay,
                        isFavorite: favorites.contains(stay.name),
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute<void>(
                              builder: (_) => StayDetailScreen(
                                stay: stay,
                                isFavorite: favorites.contains(stay.name),
                                onBookingConfirmed: (booking) {
                                  setState(() {
                                    _bookings.add(booking);
                                  });
                                },
                                onFavoriteChanged: (isFavorite) {
                                  if (isFavorite !=
                                      favorites.contains(stay.name)) {
                                    _toggleFavorite(stay);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        onFavoritePressed: () {
                          _toggleFavorite(stay);
                        },
                      );
                    },
                    childCount: filteredStays.length,
                    findChildIndexCallback: (key) {
                      if (key is ValueKey<String>) {
                        final index = filteredStays.indexWhere(
                          (stay) => stay.name == key.value,
                        );

                        return index == -1 ? null : index;
                      }

                      return null;
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.search, color: ink, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: CupertinoTextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              placeholder: 'Where do you want to go?',
              placeholderStyle: const TextStyle(color: muted, fontSize: 14),
              style: const TextStyle(color: ink, fontSize: 15),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(color: Color(0x00000000)),
              clearButtonMode: OverlayVisibilityMode.editing,
              textInputAction: TextInputAction.search,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: coral,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              CupertinoIcons.slider_horizontal_3,
              color: CupertinoColors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 91,
      child: ListView.separated(
        key: const PageStorageKey<String>('explore-categories'),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 23),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = selectedCategory == category.$1;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                selectedCategory = category.$1;
              });
            },
            child: SizedBox(
              width: 78,
              child: Column(
                children: [
                  Icon(category.$2, size: 27, color: selected ? coral : muted),
                  const SizedBox(height: 9),
                  Text(
                    category.$1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? ink : muted,
                    ),
                  ),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 2,
                    width: selected ? 44 : 0,
                    color: selected ? coral : const Color(0x00000000),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _toggleFavorite(Stay stay) {
    setState(() {
      if (!favorites.add(stay.name)) {
        favorites.remove(stay.name);
      }
    });
  }

  Widget _buildWishlist() {
    final saved = stays.where((stay) => favorites.contains(stay.name)).toList();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Wishlist')),
      child: SafeArea(
        child: saved.isEmpty
            ? const PlaceholderPage(
                icon: CupertinoIcons.heart,
                title: 'Your wishlist',
                message: 'Tap the heart on a stay to save it here.',
              )
            : ListView.builder(
                key: const PageStorageKey<String>('wishlist-scroll'),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                itemCount: saved.length,
                itemBuilder: (context, index) {
                  final stay = saved[index];

                  return StayCard(
                    key: ValueKey('wishlist-${stay.name}'),
                    stay: stay,
                    isFavorite: favorites.contains(stay.name),
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute<void>(
                          builder: (_) => StayDetailScreen(
                            stay: stay,
                            isFavorite: favorites.contains(stay.name),
                            onBookingConfirmed: (booking) {
                              setState(() {
                                _bookings.add(booking);
                              });
                            },
                            onFavoriteChanged: (isFavorite) {
                              if (isFavorite != favorites.contains(stay.name)) {
                                _toggleFavorite(stay);
                              }
                            },
                          ),
                        ),
                      );
                    },
                    onFavoritePressed: () {
                      _toggleFavorite(stay);
                    },
                  );
                },
              ),
      ),
    );
  }
}
