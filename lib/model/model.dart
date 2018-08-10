import 'dart:convert' show json;

class BaseResp<T> {
  String msg;
  int code;
  T data;

  BaseResp(String data) {
    Map<String, dynamic> map = json.decode(data);
    this.msg = map["msg"];
    this.code = map["code"];
    switch (T) {
      case UserProfile:
        map["data"] =
            map["data"] == null ? null : UserProfile.fromJson(map["data"]);
        break;
      case Login:
        map["data"] = map["data"] == null ? null : Login.fromJson(map["data"]);
        break;
      case Applicant:
        map["data"] =
            map["data"] == null ? null : Applicant.fromJson(map["data"]);
    }
    this.data = map["data"];
  }

  BaseResp.fromType(String data, Type t) {
    Map<String, dynamic> map = json.decode(data);
    this.msg = map["msg"];
    this.code = map["code"];
    switch (t) {
      case UserProfile:
        map["data"] =
            map["data"] == null ? null : new UserProfile.fromJson(map["data"]);
        break;
      case Login:
        map["data"] =
            map["data"] == null ? null : new Login.fromJson(map["data"]);
        break;
      case Applicant:
        map["data"] =
            map["data"] == null ? null : new Applicant.fromJson(map["data"]);
    }
    this.data = map["data"];
  }

  BaseResp.fromMap(Map map) {
    this.msg = map["msg"];
    this.code = map["code"];
    switch (T) {
      case Profile:
        map["data"] =
            map["data"] == null ? null : Profile.fromJson(map["data"]);
        break;
      case Login:
        map["data"] = map["data"] == null ? null : Login.fromJson(map["data"]);
        break;
      case Applicant:
        map["data"] =
            map["data"] == null ? null : Applicant.fromJson(map["data"]);
        break;
    }
    this.data = map["data"];
  }

  bool isSuccess() {
    return code == 200;
  }
}

class UserProfile {
  int is_master;
  int is_real;
  int type; //0 代理 1 客户经理
  String mobile;
  String parent_mobile;
  String parent_real_name;

  UserProfile.fromParams(
      {this.is_master,
      this.is_real,
      this.type,
      this.mobile,
      this.parent_mobile,
      this.parent_real_name});

  factory UserProfile(jsonStr) => jsonStr is String
      ? UserProfile.fromJson(json.decode(jsonStr))
      : UserProfile.fromJson(jsonStr);

  UserProfile.fromJson(jsonRes) {
    is_master = jsonRes['is_master'];
    is_real = jsonRes['is_real'];
    type = jsonRes['type'];
    mobile = jsonRes['mobile'];
    parent_mobile = jsonRes['parent_mobile'];
    parent_real_name = jsonRes['parent_real_name'];
  }

  @override
  String toString() {
    return '{"is_master": $is_master,"is_real": $is_real,"type": $type,"mobile": ${mobile !=
                                                                                   null ?
                                                                                   '${json
                                                                                       .encode(
                                                                                       mobile
                                                                                       )}' :
                                                                                   'null'},"parent_mobile": ${parent_mobile != null ?
                                                                                                              '${json
                                                                                                                  .encode(
                                                                                                                  parent_mobile
                                                                                                                  )}' :
                                                                                                              'null'},"parent_real_name": ${parent_real_name != null ?
                                                                                                                                            '${json
                                                                                                                                                .encode(
                                                                                                                                                parent_real_name
                                                                                                                                                )}' :
                                                                                                                                            'null'}}';
  }
}

class Login {
  String access_token;

  Login.fromParams({this.access_token});

  factory Login(jsonStr) => jsonStr is String
      ? Login.fromJson(json.decode(jsonStr))
      : Login.fromJson(jsonStr);

  Login.fromJson(jsonRes) {
    access_token = jsonRes['access_token'];
  }

  @override
  String toString() {
    return '{"access_token": ${access_token != null ? '${json.encode(
        access_token
        )}' : 'null'}}';
  }
}

class Applicant {
  List<Vehicle> vehicle;
  int application_id;
  bool is_editable;
  List<House> house;
  Job job;
  Profile profile;

  Applicant.fromParams(
      {this.vehicle,
      this.application_id,
      this.is_editable,
      this.house,
      this.job,
      this.profile});

  Applicant.empty() {
    vehicle = [];
    application_id = 0;
    is_editable = false;
    house = [];
    job = Job.empty();
    profile = Profile.empty();
  }

  factory Applicant(jsonStr) => jsonStr is String
      ? Applicant.fromJson(json.decode(jsonStr))
      : Applicant.fromJson(jsonStr);

  Applicant.fromJson(jsonRes) {
    //vehicle = jsonRes['vehicle'];
    application_id = jsonRes['application_id'];
    is_editable = jsonRes['is_editable'];

    vehicle = [];

    for (var vehicleItem in jsonRes['vehicle']) {
      vehicle.add(new Vehicle.fromJson(vehicleItem));
    }

    house = [];

    for (var houseItem in jsonRes['house']) {
      house.add(new House.fromJson(houseItem));
    }

    job = new Job.fromJson(jsonRes['job']);
    profile = new Profile.fromJson(jsonRes['profile']);
  }

  @override
  String toString() {
    return '{"vehicle": $vehicle,"application_id": $application_id,"is_editable": $is_editable,"house": $house,"job": $job,"profile": $profile}';
  }
}

class Profile {
  int agent_id;
  int gender;
  int id;
  int marital_status;
  int repayment_type;
  int status;
  int term;
  String allow_field;
  String couple_id_card_no;
  String couple_real_name;
  String credit_account;
  String credit_account_code;
  String credit_account_password;
  String foundation_account;
  String foundation_account_password;
  String foundation_month_amount;
  String gov_affairs_account;
  String gov_affairs_account_password;
  String id_card_no;
  String real_name;
  String year_income;

  Profile.empty() {
    agent_id = 0;
    gender = 0;
    id = 0;
    marital_status = 0;
    repayment_type = 0;
    status = 0;
  }

  Profile.fromParams(
      {this.agent_id,
      this.gender,
      this.id,
      this.marital_status,
      this.repayment_type,
      this.status,
      this.term,
      this.allow_field,
      this.couple_id_card_no,
      this.couple_real_name,
      this.credit_account,
      this.credit_account_code,
      this.credit_account_password,
      this.foundation_account,
      this.foundation_account_password,
      this.foundation_month_amount,
      this.gov_affairs_account,
      this.gov_affairs_account_password,
      this.id_card_no,
      this.real_name,
      this.year_income});

  Profile.fromJson(jsonRes) {
    agent_id = jsonRes['agent_id'];
    gender = jsonRes['gender'];
    id = jsonRes['id'];
    marital_status = jsonRes['marital_status'];
    repayment_type = jsonRes['repayment_type'];
    status = jsonRes['status'];
    term = jsonRes['term'];
    allow_field = jsonRes['allow_field'];
    couple_id_card_no = jsonRes['couple_id_card_no'];
    couple_real_name = jsonRes['couple_real_name'];
    credit_account = jsonRes['credit_account'];
    credit_account_code = jsonRes['credit_account_code'];
    credit_account_password = jsonRes['credit_account_password'];
    foundation_account = jsonRes['foundation_account'];
    foundation_account_password = jsonRes['foundation_account_password'];
    foundation_month_amount = jsonRes['foundation_month_amount'];
    gov_affairs_account = jsonRes['gov_affairs_account'];
    gov_affairs_account_password = jsonRes['gov_affairs_account_password'];
    id_card_no = jsonRes['id_card_no'];
    real_name = jsonRes['real_name'];
    year_income = jsonRes['year_income'];
  }

  @override
  String toString() {
    return '{"agent_id": ${agent_id != null ? '${json.encode(
        agent_id
        )}' :
                           'null'},"gender": $gender,"id": $id,"marital_status": $marital_status,"repayment_type": $repayment_type,"status": $status,"term": $term,"allow_field": ${allow_field !=
                                                                                                                                                                                    'null'}}';
  }
}

class Job {
  int id;
  int staffing;
  String allow_field;
  String company_name;
  String department;
  String position_level;

  Job.empty() {
    this.staffing = 0;
    this.id = 0;
  }

  Job.fromParams(
      {this.id,
      this.staffing,
      this.allow_field,
      this.company_name,
      this.department,
      this.position_level});

  Job.fromJson(jsonRes) {
    id = jsonRes['id'];
    staffing = jsonRes['staffing'];
    allow_field = jsonRes['allow_field'];
    company_name = jsonRes['company_name'];
    department = jsonRes['department'];
    position_level = jsonRes['position_level'];
  }

  @override
  String toString() {
    return '{"id": $id,"staffing": $staffing,"allow_field": ${allow_field !=
                                                              null ? '${json
        .encode(
        allow_field
        )}' : 'null'},"company_name": ${company_name != null ? '${json.encode(
        company_name
        )}' : 'null'},"department": ${department != null ? '${json.encode(
        department
        )}' : 'null'},"position_level": ${position_level != null ? '${json
        .encode(
        position_level
        )}' : 'null'}}';
  }
}

class House {
  int id;
  int is_mortgage;
  String address;
  String allow_field;
  String area;
  String mortgage_amount;
  String mortgage_creditor;
  String opt_mortgage_amount;
  String opt_mortgage_creditor;
  String owner;

  House.fromParams(
      {this.id,
      this.is_mortgage,
      this.address,
      this.allow_field,
      this.area,
      this.mortgage_amount,
      this.mortgage_creditor,
      this.opt_mortgage_amount,
      this.opt_mortgage_creditor,
      this.owner});

  House.fromJson(jsonRes) {
    id = jsonRes['id'];
    is_mortgage = jsonRes['is_mortgage'];
    address = jsonRes['address'];
    allow_field = jsonRes['allow_field'];
    area = jsonRes['area'];
    mortgage_amount = jsonRes['mortgage_amount'];
    mortgage_creditor = jsonRes['mortgage_creditor'];
    opt_mortgage_amount = jsonRes['opt_mortgage_amount'];
    opt_mortgage_creditor = jsonRes['opt_mortgage_creditor'];
    owner = jsonRes['owner'];
  }

  @override
  String toString() {
    return '{"id": $id,"is_mortgage": $is_mortgage,"address": ${address !=
                                                                null ? '${json
        .encode(
        address
        )}' : 'null'},"allow_field": ${allow_field != null ? '${json.encode(
        allow_field
        )}' : 'null'},"area": ${area != null ? '${json.encode(
        area
        )}' : 'null'},"mortgage_amount": ${mortgage_amount != null ? '${json
        .encode(
        mortgage_amount
        )}' : 'null'},"mortgage_creditor": ${mortgage_creditor != null ? '${json
        .encode(
        mortgage_creditor
        )}' : 'null'},"opt_mortgage_amount": ${opt_mortgage_amount !=
                                               null ? '${json.encode(
        opt_mortgage_amount
        )}' : 'null'},"opt_mortgage_creditor": ${opt_mortgage_creditor !=
                                                 null ? '${json.encode(
        opt_mortgage_creditor
        )}' : 'null'},"owner": ${owner != null ? '${json.encode(
        owner
        )}' : 'null'}}';
  }
}

class Vehicle {
  String allow_field;
  String brand;
  String colour;
  int id;
  String license;

  Vehicle.fromParams(
      {this.allow_field, this.brand, this.colour, this.id, this.license});

  Vehicle.fromJson(jsonRes) {
    allow_field = jsonRes['allow_field'];
    brand = jsonRes['brand'];
    colour = jsonRes['colour'];
    id = jsonRes['id'];
    license = jsonRes['license'];
  }

  @override
  String toString() {
    return '{"allow_field": ${allow_field != null ? '${json.encode(
        allow_field
        )}' : 'null'},"brand": ${brand != null ? '${json.encode(
        brand
        )}' : 'null'},"colour": ${colour != null ? '${json.encode(
        colour
        )}' : 'null'},"id": ${id != null ? '${json.encode(
        id
        )}' : 'null'},"license": ${license != null ? '${json.encode(
        license
        )}' : 'null'}}';
  }
}
