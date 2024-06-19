import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_handler/utils/Utils.dart';
import '../models/expense_model.dart';
import '../models/income_model.dart';
import '../models/user_model.dart';

class FirebaseUtils {
  FirebaseUtils._();

  static String expenses = "Expenses";
  static String incomes = "Incomes";
  static var cu = FirebaseAuth.instance.currentUser;

  static void addUser(User? users) {
    AuthUser authUser = AuthUser(
      name: users?.displayName ?? '',
      image: users?.photoURL ?? '',
      email: users?.email ?? '',
    );

    FirebaseFirestore.instance
        .collection("Users")
        .doc(users?.uid)
        .set(authUser.toJson());
    cu = users;
  }

  static void addExpenses(Expense expense) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(cu?.uid ?? '')
        .collection(expenses)
        .add(
      {
        "title": expense.title,
        "amount": expense.amount,
        "date": expense.date,
        "type": expense.type,
      },
    ).then((value) {
    });
  }

  static void addIncomes(Income income) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(cu?.uid ?? '')
        .collection(incomes)
        .add(
      {
        "title": income.title,
        "amount": income.amount,
        "date": income.date,
        "type": income.type,
      },
    ).then((value) {
    });
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getIncome() async {
    var result = await FirebaseFirestore.instance
        .collection("Users")
        .doc(cu?.uid)
        .collection("Incomes")
        .get();

    return result.docs;
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getExpense() async {
    var result = await FirebaseFirestore.instance
        .collection("Users")
        .doc(cu?.uid)
        .collection("Expenses")
        .get();

    return result.docs;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUser() async {
    var result =
        await FirebaseFirestore.instance.collection("Users").doc(cu?.uid).get();
    return result;
  }

  static Future<void> deleteIncomeExpense(String id, String type) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(type)
        .doc(id)
        .delete();
  }

  static Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Utils.showSnackbar(
        "Password Reset Email sent",
        const Duration(seconds: 2),
        Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      Utils.showSnackbar(
        "Something went wrong ${e.code}",
        const Duration(seconds: 2),
        Colors.red,
      );
    }
  }

  static Future<UserCredential> googleLogin() async {
    var googleSingIn = await GoogleSignIn().signIn();
    var auth = await googleSingIn?.authentication;
    var credential = GoogleAuthProvider.credential(
        accessToken: auth?.accessToken, idToken: auth?.idToken);
    var data = await FirebaseAuth.instance.signInWithCredential(credential);
    return data;
  }
}
