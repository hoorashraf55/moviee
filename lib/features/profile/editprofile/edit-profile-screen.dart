// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// const kYellow = Color(0xFFF5B800);
// const kRed = Color(0xFFE52521);
// const kBg = Color(0xFF121212);
// const kField = Color(0xFF282A28);
//
// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});
//
//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _user = FirebaseAuth.instance.currentUser!;
//   late final DocumentReference<Map<String, dynamic>> _ref =
//   FirebaseFirestore.instance.collection('users').doc(_user.uid);
//
//   final _nameCtrl = TextEditingController();
//   final _phoneCtrl = TextEditingController();
//   int _avatarId = 1;
//   bool _showPicker = false;
//   bool _loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }
//
//   Future<void> _load() async {
//     final doc = await _ref.get();
//     final data = doc.data() ?? {};
//     _nameCtrl.text = data['name'] ?? '';
//     _phoneCtrl.text = data['phone'] ?? '';
//     _avatarId = data['avatarId'] ?? 1;
//     if (mounted) setState(() => _loading = false);
//   }
//
//   void _msg(String text) =>
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
//
//   Future<void> _update() async {
//     try {
//       await _ref.set({
//         'name': _nameCtrl.text.trim(),
//         'phone': _phoneCtrl.text.trim(),
//         'avatarId': _avatarId,
//       }, SetOptions(merge: true));
//       _msg('Data updated');
//       if (mounted) Navigator.pop(context);
//     } catch (e) {
//       _msg('Error: $e');
//     }
//   }
//
//   Future<void> _resetPassword() async {
//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(email: _user.email!);
//       _msg('Reset link sent to ${_user.email}');
//     } catch (e) {
//       _msg('Error: $e');
//     }
//   }
//
//   Future<void> _deleteAccount() async {
//     final ok = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: kField,
//         title: const Text('Delete Account',
//             style: TextStyle(color: Colors.white)),
//         content: const Text('Are you sure? This cannot be undone.',
//             style: TextStyle(color: Colors.white70)),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text('Cancel')),
//           TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: const Text('Delete', style: TextStyle(color: kRed))),
//         ],
//       ),
//     );
//     if (ok != true) return;
//     try {
//       await _ref.delete();
//       await _user.delete();
//       if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'requires-recent-login') {
//         _msg('Please login again then retry deleting your account');
//       } else {
//         _msg(e.message ?? 'Error');
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _phoneCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBg,
//       appBar: AppBar(
//         backgroundColor: kBg,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: kYellow),
//         title: const Text('Pick Avatar',
//             style: TextStyle(color: kYellow, fontSize: 16)),
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator(color: kYellow))
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Opacity(
//               opacity: _showPicker ? 0.4 : 1,
//               child: Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () => setState(() => _showPicker = !_showPicker),
//                     child: CircleAvatar(
//                       radius: 60,
//                       backgroundColor: Colors.transparent,
//                       backgroundImage:
//                       AssetImage('assets/avatars/avatar$_avatarId.png'),
//                     ),
//                   ),
//                   const SizedBox(height: 28),
//                   _field(_nameCtrl, Icons.person, TextInputType.name),
//                   const SizedBox(height: 16),
//                   _field(_phoneCtrl, Icons.phone, TextInputType.phone),
//                   const SizedBox(height: 16),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: TextButton(
//                       onPressed: _resetPassword,
//                       child: const Text('Reset Password',
//                           style: TextStyle(
//                               color: Colors.white, fontSize: 16)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (_showPicker) _avatarGrid() else const SizedBox(height: 180),
//             const SizedBox(height: 24),
//             if (!_showPicker) ...[
//               _button('Delete Account', kRed, Colors.white, _deleteAccount),
//               const SizedBox(height: 12),
//               _button('Update Data', kYellow, Colors.black, _update),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _field(TextEditingController c, IconData icon, TextInputType type) {
//     return TextField(
//       controller: c,
//       keyboardType: type,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.white),
//         filled: true,
//         fillColor: kField,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
//
//   Widget _button(String text, Color bg, Color fg, VoidCallback onTap) {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: bg,
//           foregroundColor: fg,
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         onPressed: onTap,
//         child: Text(text, style: const TextStyle(fontSize: 16)),
//       ),
//     );
//   }
//
//   Widget _avatarGrid() {
//     return Container(
//       margin: const EdgeInsets.only(top: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: kField,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: 9,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           mainAxisSpacing: 10,
//           crossAxisSpacing: 10,
//         ),
//         itemBuilder: (_, i) {
//           final id = i + 1;
//           final selected = id == _avatarId;
//           return GestureDetector(
//             onTap: () => setState(() {
//               _avatarId = id;
//               _showPicker = false;
//             }),
//             child: Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: selected ? kYellow.withOpacity(0.6) : Colors.transparent,
//                 border: Border.all(color: kYellow),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Image.asset(
//                 "assets/Avatars/Avatar2.png"
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// // 'assets/avatars/avatar$id.png'

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _user = FirebaseAuth.instance.currentUser!;
  late final DocumentReference<Map<String, dynamic>> _ref = FirebaseFirestore
      .instance
      .collection('users')
      .doc(_user.uid);

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  int _avatarId = 1;
  bool _showPicker = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final doc = await _ref.get();
    final data = doc.data() ?? {};
    _nameCtrl.text = data['name'] ?? '';
    _phoneCtrl.text = data['phone'] ?? '';
    _avatarId = ((data['avatarId'] ?? 1) as int).clamp(1, avatars.length);
    if (mounted) setState(() => _loading = false);
  }

  void _msg(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _update() async {
    try {
      await _ref.set({
        'name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'avatarId': _avatarId,
      }, SetOptions(merge: true));
      _msg('Data updated');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _msg('Error: $e');
    }
  }

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _user.email!);
      _msg('Reset link sent to ${_user.email}');
    } catch (e) {
      _msg('Error: $e');
    }
  }

  Future<void> _deleteAccount() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kField,
        title: const Text(
          'Delete Account',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure? This cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: kRed)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _ref.delete();
      await _user.delete();
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _msg('Please login again then retry deleting your account');
      } else {
        _msg(e.message ?? 'Error');
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kYellow),
        title: const Text(
          'Pick Avatar',
          style: TextStyle(color: kYellow, fontSize: 16),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kYellow))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Opacity(
                    opacity: _showPicker ? 0.4 : 1,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              setState(() => _showPicker = !_showPicker),
                          child: ClipOval(
                            child: Image.asset(
                              avatars[_avatarId - 1],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 120,
                                height: 120,
                                color: Colors.white24,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _field(_nameCtrl, Icons.person, TextInputType.name),
                        const SizedBox(height: 16),
                        _field(_phoneCtrl, Icons.phone, TextInputType.phone),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: _resetPassword,
                            child: const Text(
                              'Reset Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_showPicker)
                    _avatarGrid()
                  else
                    const SizedBox(height: 180),
                  const SizedBox(height: 24),
                  if (!_showPicker) ...[
                    _button(
                      'Delete Account',
                      kRed,
                      Colors.white,
                      _deleteAccount,
                    ),
                    const SizedBox(height: 12),
                    _button('Update Data', kYellow, Colors.black, _update),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _field(TextEditingController c, IconData icon, TextInputType type) {
    return TextField(
      controller: c,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: kField,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _button(String text, Color bg, Color fg, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _avatarGrid() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kField,
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: avatars.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (_, i) {
          final id = i + 1;
          final selected = id == _avatarId;
          return GestureDetector(
            onTap: () => setState(() {
              _avatarId = id;
              _showPicker = false;
            }),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: selected ? kYellow.withOpacity(0.6) : Colors.transparent,
                border: Border.all(color: kYellow),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset(
                avatars[i],
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
