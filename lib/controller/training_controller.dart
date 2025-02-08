import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mci_test/controller/auth_controller.dart';
import '../model/training_plan/training_plan_model.dart';
import '../model/training_plan/training_session_model.dart';


class TrainingController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthController auth = Get.find();

  final TextEditingController setsController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  var trainingSession = Rxn<TrainingSession>();

  var isLoading = false.obs;
  RxBool isLocked = false.obs;



  @override
  void onInit() {
    super.onInit();
    getTrainingPlan();
    getActiveSession();
  }

  ///Go to next Exercise
  void nextExercise() async {
    if (trainingSession.value != null) {
      if (trainingSession.value!.nextExercise()) {
        await updateTrainingSession(trainingSession.value!);
      }
    }
    setTextController();
    trainingSession.refresh();
  }

  void startExercise() {
    isLocked(true);
    Timer(const Duration(seconds: 5), () {
      int weight = int.parse(weightController.text);
      int reps = int.parse(repsController.text);
      trainingSession.value!.trainingPlan.exercises[trainingSession.value!.currentExerciseIndex].calculateE1RM(weight, reps);
      trainingSession.refresh();
      isLocked(false);
    });
  }

  void setTextController() {
    setsController.text=trainingSession.value!.trainingPlan.exercises[trainingSession.value!.currentExerciseIndex].sets.toString();
    repsController.text=trainingSession.value!.trainingPlan.exercises[trainingSession.value!.currentExerciseIndex].reps.toString();
    weightController.text=trainingSession.value!.trainingPlan.exercises[trainingSession.value!.currentExerciseIndex].weight.toString();
  }


  ///Load Training Plan from assets
  Future<TrainingPlan> getTrainingPlan() async {
    isLoading(true);
    try {
      final String jsonString = await rootBundle.loadString('assets/trainingsplan.json');
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      return TrainingPlan.fromJson(jsonData);
    } catch (e){
      throw Exception(e);
    } finally {
      isLoading(false);
    }

  }



  /// Updates the unfinished Training Session
  Future<void> updateTrainingSession(TrainingSession updatedSession) async {
    isLoading(true);
    try {
      var user = auth.firebaseUser.value;

      if (user == null) return; // User not Authenticated

      final sessionRef = await firestore.collection('users').doc(user.uid).collection('sessions').where('isDone', isEqualTo: false).get();

      if (sessionRef.docs.isNotEmpty) {
        final activeSessionDoc = sessionRef.docs.first;
        final docId = activeSessionDoc.id;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('sessions')
            .doc(docId)
            .update(updatedSession.toJson());

      } else {
        print('No Session found.');
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      getActiveSession();
      trainingSession.refresh();
      isLoading(false);
    }
  }

  ///Deletes the unfinished Training Session
  Future<void> cancelCurrentTrainingSession() async {
    isLoading(true);
    try {
      var user = auth.firebaseUser.value;
      if (user == null) return; // User not Authenticated

      final sessionRef = await firestore.collection('users').doc(user.uid).collection('sessions').where('isDone', isEqualTo: false).get();

      if (sessionRef.docs.isNotEmpty) {
        final activeSessionDoc = sessionRef.docs.first;
        final docId = activeSessionDoc.id;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('sessions')
            .doc(docId)
            .delete();

        trainingSession.value = null;
      } else {
        print('No Session found.');
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
      trainingSession.refresh();
    }

  }

  ///Find a unfinished Training Session from Firebase
  Future<void> getActiveSession() async {
    try {
      var user = auth.firebaseUser.value;
      if (user == null) return; // User not Authenticated

      isLoading(true);

      // Check for the only active session
      final activeSessionQuery = await firestore.collection('users').doc(user.uid).collection('sessions').where('isDone', isEqualTo: false).get();

      if (activeSessionQuery.docs.isNotEmpty) {
        final sessionData = activeSessionQuery.docs.first.data();
        final trainingPlan = TrainingPlan.fromJson(sessionData['trainingPlan']);
        trainingSession.value =  TrainingSession(
          trainingPlan: trainingPlan,
          currentExerciseIndex: sessionData['currentExerciseIndex'],
          isDone: sessionData['isDone'],
        );
        setsController.text=trainingSession.value!.trainingPlan.exercises[trainingSession.value!.currentExerciseIndex].sets.toString();
        repsController.text=trainingSession.value!.trainingPlan.exercises[trainingSession.value!.currentExerciseIndex].reps.toString();
        weightController.text=trainingSession.value!.trainingPlan.exercises[trainingSession.value!.currentExerciseIndex].weight.toString();

      }else {
        trainingSession.value = null; // No active session found
      }
    } catch (e) {
      throw Exception(e);
    } finally {

      isLoading(false);
    }
  }

  ///Create and store a new unfinished Training Session
  Future<void> createNewSession() async {
    isLoading(true);
    try {

      var user = auth.firebaseUser.value;
      if (user == null) return; // User not Authenticated

      //Load TrainingPlan from assets
      TrainingPlan plan = await getTrainingPlan();

      final sessionsRef = firestore.collection('users').doc(user.uid).collection('sessions');

      // Sync with firebase
      await sessionsRef.add({
        'trainingPlan': plan.toJson(),
        'currentExerciseIndex': 0,
        'isDone': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // For local use
      trainingSession.value =  TrainingSession(
        trainingPlan: plan,
        currentExerciseIndex: 0,
        isDone: false,
      ); // Reload the active session
    } catch (e) {
      throw Exception(e);
    } finally {
      setTextController();
      isLoading(false);
    }
  }

}