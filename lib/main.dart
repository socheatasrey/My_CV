import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Srey Socheata Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();

  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final skillsKey = GlobalKey();
  final portfolioKey = GlobalKey();
  final contactKey = GlobalKey();

  late AnimationController helloCtrl;
  late AnimationController subTextCtrl;
  late AnimationController lineCtrl;
  late AnimationController contactCtrl;

  int activeIndex = 0; // 0 = Home, 1 = About
  bool showMore = false;

  @override
  void initState() {
    super.initState();

    helloCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    subTextCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    lineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    contactCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final positions = {
      0: homeKey,
      1: aboutKey,
      2: skillsKey,
      3: portfolioKey,
      4: contactKey,
    };

    for (final entry in positions.entries) {
      final context = entry.value.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero).dy;

      if (offset <= 150 && offset + box.size.height > 150) {
        if (activeIndex != entry.key) {
          setState(() => activeIndex = entry.key);
        }
        break;
      }
    }
  }

  @override
  void dispose() {
    helloCtrl.dispose();
    subTextCtrl.dispose();
    lineCtrl.dispose();
    contactCtrl.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // MENU CLICK HANDLER (FIXED)
  void onMenuTap(int index) {
    setState(() => activeIndex = index);

    GlobalKey targetKey;

    switch (index) {
      case 0:
        targetKey = homeKey;
        break;
      case 1:
        targetKey = aboutKey;
        break;
      case 2:
        targetKey = skillsKey;
        break;
      case 3:
        targetKey = portfolioKey;
        break;
      case 4:
        targetKey = contactKey;
        break;
      default:
        return;
    }

    Scrollable.ensureVisible(
      targetKey.currentContext!,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          _TopNav(activeIndex: activeIndex, onTap: onMenuTap),

          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  // HOME
                  SizedBox(
                    key: homeKey,
                    height: size.height,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: Row(
                        children: [
                          Expanded(child: _HomeText(this)),
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                'assets/home.jpg',
                                height: 380,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 100),

                  // ABOUT
                  Container(
                    key: aboutKey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 60,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 600),
                            opacity: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(160),
                              child: Image.asset(
                                'assets/about_me.jpg',
                                width: 320,
                                height: 320,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(text: 'About '),
                                    TextSpan(
                                      text: 'Me',
                                      style: TextStyle(
                                        color: Color(0xff00bcd4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                showMore
                                    ? 'I am a third-year Telecommunication and Network Engineering student at the Institute of Technology of Cambodia. I am hands-on experience in software development, telecommunication, and computer networks. Skilled in Python, Java, C programming, Flutter, and JavaFX, with practical experience building applications that implement scheduling algorithms, hybrid systems, and user-friendly interfaces. Passionate about problem-solving, learning new technologies, and contributing to innovative software and network solutions. Strong team player with experience in collaborative projects and project management.'
                                    : 'I am a third-year Telecommunication and Network Engineering student at the Institute of Technology of Cambodia. I am hands-on experience in software development,',
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _HoverButton(
                                text: showMore ? 'Show Less' : 'Show More',
                                onTap: () =>
                                    setState(() => showMore = !showMore),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 250),

                  // SKILLS
                  Container(
                    key: skillsKey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 60,
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: 'My '),
                              TextSpan(
                                text: 'Skills',
                                style: TextStyle(color: Color(0xff00bcd4)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        Column(
                          children: [
                            // FIRST ROW
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _SkillCard(
                                  title: 'Programming',
                                  image: 'assets/skills/programming.webp',
                                  items: const [
                                    'C / C++',
                                    'Python',
                                    'Java',
                                    'HTML / CSS',
                                    'JavaScript',
                                  ],
                                ),
                                const SizedBox(width: 30),
                                _SkillCard(
                                  title: 'Microcontroller',
                                  image: 'assets/skills/microcontroller.png',
                                  items: const [
                                    'Arduino',
                                    'Sensors',
                                    'Actuator Interfacing',
                                  ],
                                ),
                                const SizedBox(width: 30),
                                _SkillCard(
                                  title: 'Tools',
                                  image: 'assets/skills/tools.png',
                                  items: const ['MATLAB', 'MS Office', 'Cisco'],
                                ),
                              ],
                            ),

                            // SPACE BEFORE MORE
                            const SizedBox(height: 30),

                            // SECOND ROW (ONLY WHEN "MORE" IS CLICKED)
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: showMore
                                  ? Row(
                                      key: const ValueKey(1),
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _SkillCard(
                                          title: 'Operating Systems',
                                          image: 'assets/skills/os.png',
                                          items: const ['Ubuntu'],
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        _HoverButton(
                          text: showMore ? 'Show Less' : 'More',
                          onTap: () => setState(() => showMore = !showMore),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 250),

                  // PORTFOLIO
                  Container(
                    key: portfolioKey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 60,
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: 'My '),
                              TextSpan(
                                text: 'Portfolio',
                                style: TextStyle(color: Color(0xff00bcd4)),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _PortfolioCard(
                              title: 'Smart Home Arduino Project',
                              image: 'assets/portfolio/arduino.png',
                              description:
                                  'A smart home is a house that uses internet-connected devices to automatically control and monitor systems such as lighting, security, temperature, and appliances. These devices can be controlled remotely using a smartphone or voice assistant. Smart homes improve convenience, security, and energy efficiency, making daily life more comfortable and safe.',
                            ),

                            const SizedBox(width: 40),

                            _PortfolioCard(
                              title: 'Tic-Tac-Toe Game',
                              image: 'assets/portfolio/tic_tac_toe.png',
                              description:
                                  'Tic Tac Toe is a simple two-player game played on a 3×3 grid. Players take turns marking a cell with X or O. The goal is to be the first to place three of your marks in a row—horizontally, vertically, or diagonally. The game ends when one player wins or when all cells are filled, resulting in a draw.',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 250),

                  // CONTACT

                  // CONTACT (TITLE + SECTION SHARE THE SAME KEY)
                  Container(
                    key: contactKey,
                    width: double.infinity,
                    child: Column(
                      children: [
                        // TITLE (white background)
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: 'My '),
                              TextSpan(
                                text: 'Contact',
                                style: TextStyle(color: Color(0xff00bcd4)),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 60),

                        // BLUE CONTACT SECTION
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 80,
                          ),
                          color: const Color(0xff00bcd4),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _ContactCard(
                                    icon: Icons.email,
                                    title: 'Email',
                                    subtitle: 'sreysocheataa@gmail.com',
                                    url:
                                        'https://mail.google.com/mail/u/1/#sent?compose=CllgCJvpbSxzLtzsQfPwrdlGLHNkpThHXJWQpzNnLVRgTCsjGjbSNSWNjbnkSrkcLhJzxvFlgtL',
                                  ),
                                  const SizedBox(width: 30),
                                  _ContactCard(
                                    icon: Icons.phone,
                                    title: 'Phone',
                                    subtitle: '+855 119 068 78',
                                    url: 'tel:+85511906878',
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              // LOCATION (WIDER)
                              _ContactCard(
                                width: 520,
                                icon: Icons.location_on,
                                title: 'Location',
                                subtitle:
                                    'Russian Federation Blvd (110), Phnom Penh 120404',
                                url:
                                    'https://www.google.com/maps/search/?api=1&query=Russian+Federation+Blvd+110+Phnom+Penh',
                              ),

                              const SizedBox(height: 30),

                              // SOCIAL ICONS BELOW LOCATION
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  _SocialIcon(
                                    icon: Icons.facebook,
                                    url:
                                        'https://www.facebook.com/pey.chhouy.3',
                                  ),
                                  _SocialIcon(
                                    icon: Icons.camera_alt, // Instagram
                                    url:
                                        'https://www.instagram.com/pey_chhouyyyyyy/',
                                  ),
                                  _SocialIcon(
                                    icon: Icons.send, // Telegram
                                    url:
                                        'https://web.telegram.org/a/#1187896829',
                                  ),
                                  _SocialIcon(
                                    icon: Icons.code, // GitHub
                                    url: 'https://github.com/socheatasrey',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- HOME TEXT ----------------
class _HomeText extends StatelessWidget {
  final _PortfolioHomeState state;
  const _HomeText(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AnimatedBuilder(
        //   animation: state.lineCtrl,
        //   builder: (_, __) => Container(
        //     margin: const EdgeInsets.only(top: 8),
        //     width: 4,
        //     height: 120 * state.lineCtrl.value,
        //     color: const Color(0xff00bcd4),
        //   ),
        // ),
        const SizedBox(width: 20),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideTransition(
              position: Tween(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(state.helloCtrl),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: 'Hello, I\'m\n'),
                    TextSpan(
                      text: 'Srey Socheata',
                      style: TextStyle(color: Color(0xff00bcd4)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SlideTransition(
              position: Tween(
                begin: const Offset(-0.6, 0),
                end: Offset.zero,
              ).animate(state.subTextCtrl),
              child: const Text(
                'Telecommunication\nand Network Student',
                style: TextStyle(fontSize: 20, color: Color(0xff00bcd4)),
              ),
            ),
            const SizedBox(height: 30),
            SlideTransition(
              position: Tween(
                begin: const Offset(1.5, 0),
                end: Offset.zero,
              ).animate(state.contactCtrl),
              child: Row(
                children: const [
                  _HoverButton(
                    text: 'Contact Me',
                    url:
                        'https://mail.google.com/mail/u/1/#sent?compose=DmwnWstqwxJgRJVNXQchQSlrCNKhcDClxLdjkgWLvmVtlGPVHqVLcqBlWmZwpvnzVvtBMSnKQhlv',
                  ),

                  _SocialIcon(
                    icon: Icons.facebook,
                    url: 'https://www.facebook.com/pey.chhouy.3',
                  ),
                  _SocialIcon(
                    icon: Icons.camera_alt, // Instagram
                    url: 'https://www.instagram.com/pey_chhouyyyyyy/',
                  ),
                  _SocialIcon(
                    icon: Icons.send, // Telegram
                    url: 'https://web.telegram.org/a/#1187896829',
                  ),
                  _SocialIcon(
                    icon: Icons.code, // GitHub
                    url: 'https://github.com/socheatasrey',
                  ),
                  _SocialIcon(
                    icon: Icons.email,
                    url:
                        'https://mail.google.com/mail/u/1/#sent?compose=DmwnWstqwxJgRJVNXQchQSlrCNKhcDClxLdjkgWLvmVtlGPVHqVLcqBlWmZwpvnzVvtBMSnKQhlv',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------- NAVBAR ----------------
class _TopNav extends StatefulWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;
  const _TopNav({required this.activeIndex, required this.onTap});

  @override
  State<_TopNav> createState() => _TopNavState();
}

class _TopNavState extends State<_TopNav> {
  int hoverIndex = -1;
  final menus = ['Home', 'About', 'Skills', 'Portfolio', 'Contact'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 80),
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => widget.onTap(0), // HOME
            child: Row(
              children: const [
                Text(
                  'Srey',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  ' Socheata',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00bcd4),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
          ...List.generate(menus.length, (i) {
            final active = widget.activeIndex == i;
            final hover = hoverIndex == i;

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => hoverIndex = i),
              onExit: (_) => setState(() => hoverIndex = -1),
              child: GestureDetector(
                onTap: () => widget.onTap(i),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        menus[i],
                        style: TextStyle(
                          fontSize: 16,
                          color: active || hover
                              ? const Color(0xff00bcd4)
                              : Colors.black,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2,
                        width: active ? 28 : 0,
                        color: const Color(0xff00bcd4),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------- BUTTON ----------------
class _HoverButton extends StatefulWidget {
  final String text;
  final String? url; // Optional URL
  final VoidCallback? onTap; // Optional custom callback

  const _HoverButton({required this.text, this.url, this.onTap, Key? key})
    : super(key: key);

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool hover = false;

  Future<void> _handleTap() async {
    if (widget.onTap != null) {
      widget.onTap!();
    } else if (widget.url != null) {
      final uri = Uri.parse(widget.url!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: hover ? Colors.black : const Color(0xff00bcd4),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(widget.text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;

  const _SocialIcon({required this.icon, required this.url, Key? key})
    : super(key: key);

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool hover = false;

  Future<void> _handleTap() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open the link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(left: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hover ? Colors.white : Colors.transparent,
            border: Border.all(color: Colors.white),
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: hover ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final String title;
  final String image;
  final List<String> items;

  const _SkillCard({
    required this.title,
    required this.image,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 340, //
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xff00bcd4)),
        color: const Color(0xfff3fcfd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE HEADER
          Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xff00bcd4),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ),

          // CONTENT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00bcd4),
                  ),
                ),
                const SizedBox(height: 10),

                ...items.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $e', style: const TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final String title;
  final String image;
  final String description;

  const _PortfolioCard({
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xff00bcd4)),
        color: const Color(0xfff3fcfd),
      ),
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xff00bcd4),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00bcd4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String url;
  final double width;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.url,
    this.width = 320, // default width
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool hover = false;

  Future<void> _open() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xff00bcd4),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.15)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: hover
                    ? Colors.white
                    : Colors.white.withOpacity(0.25),
                child: Icon(
                  widget.icon,
                  color: hover ? Colors.black : Colors.white,
                ),
              ),

              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(color: Colors.white, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
