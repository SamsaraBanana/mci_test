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

  //TextControllers for the UI
  final TextEditingController setsTextController = TextEditingController();
  final TextEditingController repsTextController = TextEditingController();
  final TextEditingController weightTextController = TextEditingController();

  //local trainingPlan to display in UI
  late TrainingPlan trainingPlan;

  //Main Training Session object that the UI is listening to
  var trainingSession = Rxn<TrainingSession>();

  //Simple State observables to control the UI.
  var isLoading = false.obs;
  RxBool enableRepsWeightInput = false.obs;
  RxBool enableSetInput = false.obs;
  RxBool isTraining = false.obs;

  //Pause Timer Duration
  var pauseDuration = const Duration(seconds: 5).obs;
  var progressValue = 1.0.obs;
  var isPaused = false.obs;
  Timer? _pauseTimer; //Private pause timer

  //Fetches TrainingSession after Firebase is loaded
  @override
  void onReady() {
    super.onReady();
    getTrainingPlan();
    getActiveSession();
  }

  ///Go to next Exercise and store progress.
  void nextExercise() async {
    // Cancel Timer if you are too fast
    _pauseTimer?.cancel();
    progressValue.value = 1.0;

    if (trainingSession.value != null) {
      enableSetInput(false);
      trainingSession.value!.nextExercise();
      await updateTrainingSession(trainingSession.value!);
      goToCurrentExercise(trainingSession.value!);
    }
    trainingSession.refresh();
  }

  ///Displays the Current Exercise before starting
  void goToCurrentExercise(TrainingSession session) {
    isTraining(false);
    enableRepsWeightInput(false);
    enableSetInput(true);
    setTextController(session);
  }

  ///Starts the Exercise and locks in the selected Set count
  void startExercise() {
    isTraining(true);
    enableSetInput(false);
    enableRepsWeightInput(false);
    trainingSession.value!.trainingPlan.exercises[trainingSession.value!.currentExerciseIndex].sets = int.parse(setsTextController.text);
  }

  ///Resets Observables when stopping Exercising
  void stopExercise() {
    isTraining(false);
    enableSetInput(true);
    enableRepsWeightInput(false);
  }

  ///Starts an Exercise Set and calculates the E1RM after the Exercise is done.
  void startExerciseSet() {
    enableRepsWeightInput(true);
    isPaused(false);
  }

  ///Finish Exercise Set and calculate E1RM
  void finishExerciseSet() {
    int weight = int.parse(weightTextController.text);
    int reps = int.parse(repsTextController.text);
    trainingSession.value!.trainingPlan.exercises[trainingSession.value!.currentExerciseIndex].calculateE1RM(weight, reps);
    trainingSession.refresh();
    enableRepsWeightInput(false);
    startPauseTimer();
  }

  ///Pause Timer that updated the progressBar
  void startPauseTimer() {
    _pauseTimer?.cancel();
    progressValue.value = 1.0;

    isPaused(true);
    int totalMilliseconds = pauseDuration.value.inMilliseconds;
    int interval = 50;
    int elapsed = 0;

    _pauseTimer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      elapsed += interval;
      double progress = 1.0 - (elapsed / totalMilliseconds);
      progressValue.value = progress.clamp(0.0, 1.0);

      if (elapsed >= totalMilliseconds) {
        timer.cancel();
      }
    });
  }

  ///Helper function to set the TextControllers
  void setTextController(TrainingSession session) {
    setsTextController.text=session.trainingPlan.exercises[session.currentExerciseIndex].sets.toString();
    repsTextController.text=session.trainingPlan.exercises[session.currentExerciseIndex].reps.toString();
    weightTextController.text=session.trainingPlan.exercises[session.currentExerciseIndex].weight.toString();
  }

  //-----------------------Assets-----------------------//

  ///Load Training Plan from assets
  Future<TrainingPlan> getTrainingPlan() async {
    isLoading(true);
    try {
      final String jsonString = await rootBundle.loadString('assets/trainingsplan.json');
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      return trainingPlan = TrainingPlan.fromJson(jsonData);
    } catch (e){
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }

  //-------------------------FireBase-------------------------//

  ///Updates the current Session and stores it in Firebase
  ///After saving, fetches the newly saves Session with getActiveSession()
  Future<void> updateTrainingSession(TrainingSession updatedSession) async {
    isLoading(true);
    try {
      var user = auth.firebaseUser.value;

      if (user == null) return; // User not Authenticated

      // Fetches the active Session
      final sessionRef = await firestore.collection('users').doc(user.uid).collection('sessions').where('isDone', isEqualTo: false).get();

      if (sessionRef.docs.isNotEmpty) {
        final activeSessionDoc = sessionRef.docs.first;
        final docId = activeSessionDoc.id;

        // Updates the fetched Session in firebase
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

      // Fetches the active Session
      final sessionRef = await firestore.collection('users').doc(user.uid).collection('sessions').where('isDone', isEqualTo: false).get();


      if (sessionRef.docs.isNotEmpty) {
        // Gets the first entry from the document (There should only be one)
        final activeSessionDoc = sessionRef.docs.first;
        final docId = activeSessionDoc.id;

        // Deletes the fetched Session from firebase
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('sessions')
            .doc(docId)
            .delete();

        // Updates the local TrainingSession (Deletion)
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

  ///Fetches all finished Training Sessions from Firebase
  Future<List<TrainingSession>> getTrainingSessionsHistory() async {
    try {
      var user = auth.firebaseUser.value;
      if (user==null) return[];

      // Fetch Documents of all finished Sessions from Firebase
      final sessionsSnapshot  = await firestore.collection('users').doc(user.uid).collection('sessions').where('isDone', isEqualTo: true).get();

      if (sessionsSnapshot.docs.isEmpty) {
        return [];
      }

      // Creates a list of TrainingSession objects from the fetched documents
      List<TrainingSession> sessions = sessionsSnapshot.docs.map((doc) {
        return TrainingSession.fromJson(doc.data());
      }).toList();

      return sessions;
    } catch (e) {
      print('Error fetching training sessions: $e');
      return [];
    }
  }

  ///Finds a unfinished Training Session from Firebase and
  ///updates the local observable TrainingSession
  Future<void> getActiveSession() async {
    try {
      var user = auth.firebaseUser.value;
      if (user == null) return; // User not Authenticated

      isLoading(true);

      // Check for the only active session
      final activeSessionQuery = await firestore.collection('users').doc(user.uid).collection('sessions').where('isDone', isEqualTo: false).get();

      if (activeSessionQuery.docs.isNotEmpty) {
        // Get the first entry from the document
        // The Query should always just return 1 entry
        final sessionData = activeSessionQuery.docs.first.data();

        // loads the TrainingPlan from fetched Session as a object
        final trainingPlan = TrainingPlan.fromJson(sessionData['trainingPlan']);

        // Updates the local TrainingSession with the fetched Session
        trainingSession.value =  TrainingSession(
          trainingPlan: trainingPlan,
          currentExerciseIndex: sessionData['currentExerciseIndex'],
          isDone: sessionData['isDone'],
        );

        // Refresh UI to display the current Exercise based on the ExerciseIndex
        goToCurrentExercise(trainingSession.value!);

      }else {
        trainingSession.value = null; // No active session found
      }
    } catch (e) {
      throw Exception(e);
    } finally {

      isLoading(false);
    }
  }

  ///Creates and stores a new unfinished Training Session in Firebase.
  ///Also updates local observable TrainingSession
  ///Calls goToCurrentExercise() to display the first Exercise
  Future<void> createNewSession() async {
    isLoading(true);
    try {

      var user = auth.firebaseUser.value;
      if (user == null) return; // User not Authenticated

      // Check if there is no active session
      final sessionsSnapshot  = await firestore.collection('users').doc(user.uid).collection('sessions').where('isDone', isEqualTo: false).get();

      if (sessionsSnapshot.docs.isNotEmpty) {
        print('There is already an active session');
        return;
      }

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
      ); // Updates the active session

      if (trainingSession.value != null) goToCurrentExercise(trainingSession.value!);

    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }

}