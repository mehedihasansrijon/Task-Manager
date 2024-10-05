import 'dart:convert';
import 'package:http/http.dart';
import 'package:task_manager/utility/utility.dart';
import '../models/task_list_model.dart';
import '../style/style.dart';

const String baseURL = 'http://152.42.163.176:2006/api/v1';
var header = {'Content-Type': 'application/json'};

Future<bool> loginRequest(String email, String password) async {
  Map<String, String> body = {'email': email, 'password': password};
  Uri loginUri = Uri.parse('$baseURL/Login');
  Response loginResponse = await post(
    loginUri,
    headers: header,
    body: jsonEncode(body),
  );

  if (loginResponse.statusCode == 200) {
    Map<String, dynamic> loginData = jsonDecode(loginResponse.body);
    if (loginData['status'] == 'success') {
      bool profileDetails = await profileDetailsRequest(loginData['token']);
      toastMsg(
          'Retrieving your profile data, one moment please...', colorGreen);
      if (profileDetails) {
        toastMsg('Operation was successful!', colorGreen);
        return true;
      } else {
        toastMsg('Data retrieval unsuccessful. Please retry.', colorRed);
        return false;
      }
    } else {
      return false;
    }
  } else {
    toastMsg(
        'Login failed. Please check your credentials and try again.', colorRed);
    return false;
  }
}

Future<bool> registrationRequest(
  String email,
  String firstName,
  String lastName,
  String mobile,
  String password,
) async {
  Map<String, String> body = {
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'mobile': mobile,
    'password': password,
  };

  Uri registrationUri = Uri.parse('$baseURL/Registration');
  Response registrationResponse = await post(
    registrationUri,
    headers: header,
    body: jsonEncode(body),
  );

  Map<String, dynamic> registrationData = jsonDecode(registrationResponse.body);
  if (registrationResponse.statusCode == 200 &&
      registrationData['status'] == 'success') {
    toastMsg('Welcome! Your registration was successful!', colorGreen);
    return true;
  } else {
    toastMsg('Registration failed. Please try again.', colorRed);
    return false;
  }
}

Future<bool> recoveryEmailVerifyRequest(String email) async {
  Uri recoveryEmailUri = Uri.parse('$baseURL/RecoverVerifyEmail/$email');
  Response recoveryEmailResponse = await get(recoveryEmailUri);

  Map<String, dynamic> recoveryEmailData =
      jsonDecode(recoveryEmailResponse.body);

  if (recoveryEmailResponse.statusCode == 200 &&
      recoveryEmailData['status'] == 'success') {
    toastMsg(recoveryEmailData['data'], colorGreen);
    return true;
  } else {
    toastMsg(recoveryEmailData['data'], colorRed);
    return false;
  }
}

Future<bool> recoveryEmailOTPRequest(String email, String otp) async {
  Uri recoveryOTPUri = Uri.parse('$baseURL/RecoverVerifyOtp/$email/$otp');
  Response recoveryOTPResponse = await get(recoveryOTPUri);

  Map<String, dynamic> recoveryOTPData = jsonDecode(recoveryOTPResponse.body);

  if (recoveryOTPResponse.statusCode == 200 &&
      recoveryOTPData['status'] == 'success') {
    toastMsg(recoveryOTPData['data'], colorGreen);
    return true;
  } else {
    toastMsg(recoveryOTPData['data'], colorRed);
    return false;
  }
}

Future<bool> changePasswordRequest(
  String email,
  String otp,
  String password,
) async {
  Map<String, String> body = {
    'email': email,
    'OTP': otp,
    'password': password,
  };

  Uri changePasswordUri = Uri.parse('$baseURL/RecoverResetPassword');
  Response changePasswordResponse = await post(
    changePasswordUri,
    headers: header,
    body: jsonEncode(body),
  );

  Map<String, dynamic> changePasswordData =
      jsonDecode(changePasswordResponse.body);
  if (changePasswordResponse.statusCode == 200 &&
      changePasswordData['status'] == 'success') {
    toastMsg(changePasswordData['data'], colorGreen);
    return true;
  } else {
    toastMsg(changePasswordData['data'], colorRed);
    return false;
  }
}

Future<bool> profileDetailsRequest(String token) async {
  Uri profileDetailsUri = Uri.parse('$baseURL/ProfileDetails');
  var profileDetailsHeader = {"token": token};

  Response profileDetailsResponse = await get(
    profileDetailsUri,
    headers: profileDetailsHeader,
  );

  Map<String, dynamic> profileDetailsData =
      jsonDecode(profileDetailsResponse.body);
  if (profileDetailsResponse.statusCode == 200 &&
      profileDetailsData['status'] == 'success') {
    profileDetailsData['token'] = token;
    writeUserData(profileDetailsData);
    return true;
  } else {
    toastMsg('Too many requests, please try again later.', colorRed);

    return false;
  }
}

Future<Map<String, dynamic>?> taskStatusCountRequest(String token) async {
  Uri taskStatusCountUri = Uri.parse('$baseURL/taskStatusCount');
  var taskStatusHeader = {"token": token};
  Response taskStatusCountResponse =
      await get(taskStatusCountUri, headers: taskStatusHeader);

  if (taskStatusCountResponse.statusCode == 200) {
    Map<String, dynamic> taskStatusCountData =
        jsonDecode(taskStatusCountResponse.body);
    if (taskStatusCountData['status'] == 'success') {
      return taskStatusCountData;
    } else {
      return null;
    }
  } else {
    toastMsg('Too many requests, please try again later.', colorRed);

    return null;
  }
}

Future<bool> createTaskRequest(
  String token,
  String title,
  String description,
) async {
  Uri createTaskUri = Uri.parse('$baseURL/createTask');
  Map<String, String> createTaskHeader = {
    "Content-Type": "application/json",
    "token": token,
  };

  Map<String, String> body = {
    'title': title,
    'description': description,
    'status': "New",
  };

  Response createTaskResponse = await post(
    createTaskUri,
    headers: createTaskHeader,
    body: jsonEncode(body),
  );
  if (createTaskResponse.statusCode == 200) {
    Map<String, dynamic> createTaskData = jsonDecode(createTaskResponse.body);
    if (createTaskData['status'] == 'success' &&
        createTaskData['data']['status'] == 'New') {
      return true;
    } else {
      return false;
    }
  } else {
    toastMsg('Too many requests, please try again later.', colorRed);
    return false;
  }
}

Future<List<TaskListModel>?> listTaskByStatusRequest(
  String status,
  String token,
) async {
  List<TaskListModel> taskList = [];

  Uri listTaskByStatusUri = Uri.parse('$baseURL/listTaskByStatus/$status');
  Map<String, String> listTaskByStatusHeader = {
    "Content-Type": "application/json",
    "token": token,
  };
  Response listTaskByStatusResponse = await get(
    listTaskByStatusUri,
    headers: listTaskByStatusHeader,
  );
  if (listTaskByStatusResponse.statusCode == 200) {
    Map<String, dynamic> listTaskByStatusData =
        jsonDecode(listTaskByStatusResponse.body);

    if (listTaskByStatusData['status'] == 'success') {
      for (var item in listTaskByStatusData['data']) {
        TaskListModel taskListModel = TaskListModel(
          id: item['_id'],
          title: item['title'],
          description: item['description'],
          status: item['status'],
          createdDate: item['createdDate'],
        );

        taskList.add(taskListModel);
      }
    }
  } else {
    toastMsg('Too many requests, please try again later.', colorRed);
  }

  return taskList;
}

Future<bool> deleteTaskRequest(String id, String token) async {
  Uri listTaskByStatusUri = Uri.parse('$baseURL/deleteTask/$id');
  Map<String, String> listTaskByStatusHeader = {
    "Content-Type": "application/json",
    "token": token,
  };
  Response listTaskByStatusResponse = await get(
    listTaskByStatusUri,
    headers: listTaskByStatusHeader,
  );
  if (listTaskByStatusResponse.statusCode == 200) {
    Map<String, dynamic> listTaskByStatusData =
        jsonDecode(listTaskByStatusResponse.body);

    if (listTaskByStatusData['status'] == 'success') {
      return true;
    } else {
      return false;
    }
  } else {
    toastMsg('Too many requests, please try again later.', colorRed);
    return false;
  }
}

Future<bool> updateTaskRequest(String id, String token, String status) async {
  Uri updateTaskUri = Uri.parse('$baseURL/updateTaskStatus/$id/$status');
  Map<String, String> updateTaskHeader = {
    "Content-Type": "application/json",
    "token": token,
  };

  Response listTaskByStatusResponse = await get(
    updateTaskUri,
    headers: updateTaskHeader,
  );
  if (listTaskByStatusResponse.statusCode == 200) {
    Map<String, dynamic> listTaskByStatusData =
        jsonDecode(listTaskByStatusResponse.body);

    if (listTaskByStatusData['status'] == 'success') {
      if (listTaskByStatusData['data']['modifiedCount'] == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    toastMsg('Too many requests, please try again later.', colorRed);
    return false;
  }
}

Future<bool> updateProfileRequest(String token, String email, String firstName,
    String lastName, String mobile, String password) async {
  Uri updateTaskUri = Uri.parse('$baseURL/ProfileUpdate');
  Map<String, String> updateTaskHeader = {
    "Content-Type": "application/json",
    "token": token,
  };

  Map<String, String> updateProfileBody = {
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "mobile": mobile,
    "password": password,
  };

  Response listTaskByStatusResponse = await post(
    updateTaskUri,
    headers: updateTaskHeader,
    body: jsonEncode(updateProfileBody),
  );

  if (listTaskByStatusResponse.statusCode == 200) {
    Map<String, dynamic> listTaskByStatusData =
        jsonDecode(listTaskByStatusResponse.body);

    if (listTaskByStatusData['status'] == 'success') {
      if (listTaskByStatusData['data']['modifiedCount'] == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    toastMsg('Too many requests, please try again later.', colorRed);
    return false;
  }
}
