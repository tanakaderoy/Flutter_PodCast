import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pod_cast_app/Util/Constants.dart';
import 'package:pod_cast_app/models/ItunesSearchResultModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webfeed/domain/rss_feed.dart';

class FirebaseHelper {
  static final instance = FirebaseHelper();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  static final Firestore _firestore = Firestore.instance;
  FirebaseUser _currentUser;

  FirebaseUser get currentUser => _currentUser;
  FirebaseAuth get auth => _auth;

  set currentUser(FirebaseUser value) {
    _currentUser = value;
  }

  Future<bool> canSignInOnStart() async{
    final prefs = await SharedPreferences.getInstance();

    String accessToken = prefs.getString(kAccessToken);
    String idToken = prefs.getString(kIdToken);
    if(accessToken != null && idToken !=null) {
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final AuthResult authResult = await _auth.signInWithCredential(
          credential).catchError((e){
            print('tanaka e $e');
            throw(Exception('Nope'));
      });

      if (authResult == null) {
        print('tanaka e');

      }

      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      this.currentUser = currentUser;
      return true;
    }else{
      return false;
    }
  }


  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    this.currentUser = currentUser;
    final prefs = await SharedPreferences.getInstance();


    prefs.setString(kAccessToken, googleSignInAuthentication.accessToken);
    prefs.setString(kIdToken, googleSignInAuthentication.idToken);


    return user;
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
this.currentUser= null;
    print("User Sign Out");
  }

  static Future<FirebaseUser> handleSignIn(
      String email, String password) async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user;
  }

  static Future<FirebaseUser> handleRegister(
      String email, String password) async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    return user;
  }

  static Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  static Future<void> logout() async {
    return await _auth.signOut();
  }
  
   void saveFavePodCast(iTunesSearchResults podData){
    _firestore.collection(kFavePodCasts).document('${_currentUser.email}').collection(kPodCasts).document('${podData.collectionName}: ${podData.artistName}').setData(podData.toJson());
  }
  void deleteFavePodCast(iTunesSearchResults podData){
    _firestore.collection(kFavePodCasts).document('${_currentUser.email}').collection(kPodCasts).document('${podData.collectionName}: ${podData.artistName}').delete();
  }

  Stream<QuerySnapshot> getFavePodcasts() {
    final favePodCasts =  _firestore.collection(kFavePodCasts).document('${_currentUser.email}').collection(kPodCasts).snapshots();
    return favePodCasts;

  }
}
