import 'package:digi_card/constant/color_pallete.dart';
import 'package:digi_card/home_content/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Contact> _contacts = [];


  @override
  void initState() {
    super.initState();
    _getContacts();
  }
  Future<void> _getContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() {
        _contacts = contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shadowColor: Colors.grey.shade200,
            backgroundColor: Colors.white,
            expandedHeight: 150.0, // Reduced from 180.0
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Colors.white10, Colors.white],
                  ),
                ),
              ),
              expandedTitleScale: 1.0,
              title: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Contacts",
                                    style: TextStyle(
                                        fontSize: 30.0, color: Colors.black87),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.person_add,
                                      size: 30.0,
                                      color: ColorPallete.colorSelect,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: SimpleSearchBar(
                                onSearch: (query) {
                                  print('Searching for: $query');
                                },
                              ),
                            ),
                            const Divider(
                              height: 20.0,
                              thickness: 5.0,
                              color: ColorPallete.bgSearchColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              titlePadding: EdgeInsets.zero,
            ),
            toolbarHeight: 160.0, // Reduced to match new expandedHeight
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final contact = _contacts[index];
                return Column(
                  children: [
                    ListTile(
                      leading: contact.photo != null
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.photo!))
                          : CircleAvatar(child: Text(contact.displayName[0])),
                      title: Text(contact.displayName),
                      subtitle: Text(contact.phones.isNotEmpty
                          ? contact.phones.first.number
                          : ''),
                    ),
                    const Divider(height: 1),
                  ],
                );
              },
              childCount: _contacts.length,
            ),
          ),
        ],
      ),
    );
  }
}
