import 'dart:convert' show json;
class BaseResp<T> {
  String msg;
  int code;
  T data;

  BaseResp.fromType(String data, Type t) {
    Map<String, dynamic> map = json.decode(data);
    this.msg = map["msg"];
    this.code = map["code"];
    switch (t) {
      case Profile:
        map["data"] =
        map["data"] == null ? null : new Profile.fromJson(map["data"]);
        break;
      case Application:
        map["data"] =
        map["data"] == null ? null : new Application.fromJson(map["data"]);
    }
    this.data = map["data"];
  }

  bool isSuccess() {
    return code == 200;
  }

  @override
  String toString() {
    return 'BaseResp{msg: $msg, code: $code, data: $data}';
  }


}

class Application {

  int application_id;
  bool is_editable;
  List<House> house;
  List<Vehicle> vehicle;
  Job job;
  Profile profile;


  Application.fromParams({this.application_id, this.is_editable, this.house, this.vehicle, this.job, this.profile});

  factory Application(jsonStr) => jsonStr is String ? Application.fromJson(json.decode(jsonStr)) : Application.fromJson(jsonStr);

  Application.fromJson(jsonRes) {
    application_id = jsonRes['application_id'];
    is_editable = jsonRes['is_editable'];
    house = [];
    if(jsonRes['house']!=null)
    for (var houseItem in jsonRes['house']){

      house.add(new House.fromJson(houseItem));
    }

    vehicle = [];
    if(jsonRes['vehicle']!=null)
    for (var vehicleItem in jsonRes['vehicle']){

      vehicle.add(new Vehicle.fromJson(vehicleItem));
    }

    job = new Job.fromJson(jsonRes['job']);
    profile = new Profile.fromJson(jsonRes['profile']);

  }

  @override
  String toString() {
    return '{"application_id": $application_id,"is_editable": $is_editable,"house": $house,"vehicle": $vehicle,"job": $job,"profile": $profile}';
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


  Profile.fromParams({this.agent_id, this.gender, this.id, this.marital_status, this.repayment_type, this.status, this.term, this.allow_field, this.couple_id_card_no, this.couple_real_name, this.credit_account, this.credit_account_code, this.credit_account_password, this.foundation_account, this.foundation_account_password, this.foundation_month_amount, this.gov_affairs_account, this.gov_affairs_account_password, this.id_card_no, this.real_name, this.year_income});

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
    return '{"agent_id": $agent_id,"gender": $gender,"id": $id,"marital_status": $marital_status,"repayment_type": $repayment_type,"status": $status,"term": $term,"allow_field": ${allow_field != null?'${json.encode(allow_field)}':'null'},"couple_id_card_no": ${couple_id_card_no != null?'${json.encode(couple_id_card_no)}':'null'},"couple_real_name": ${couple_real_name != null?'${json.encode(couple_real_name)}':'null'},"credit_account": ${credit_account != null?'${json.encode(credit_account)}':'null'},"credit_account_code": ${credit_account_code != null?'${json.encode(credit_account_code)}':'null'},"credit_account_password": ${credit_account_password != null?'${json.encode(credit_account_password)}':'null'},"foundation_account": ${foundation_account != null?'${json.encode(foundation_account)}':'null'},"foundation_account_password": ${foundation_account_password != null?'${json.encode(foundation_account_password)}':'null'},"foundation_month_amount": ${foundation_month_amount != null?'${json.encode(foundation_month_amount)}':'null'},"gov_affairs_account": ${gov_affairs_account != null?'${json.encode(gov_affairs_account)}':'null'},"gov_affairs_account_password": ${gov_affairs_account_password != null?'${json.encode(gov_affairs_account_password)}':'null'},"id_card_no": ${id_card_no != null?'${json.encode(id_card_no)}':'null'},"real_name": ${real_name != null?'${json.encode(real_name)}':'null'},"year_income": ${year_income != null?'${json.encode(year_income)}':'null'}}';
  }
}



class Job {

  int id;
  int staffing;
  String allow_field;
  String company_name;
  String department;
  String position_level;


  Job.fromParams({this.id, this.staffing, this.allow_field, this.company_name, this.department, this.position_level});

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
    return '{"id": $id,"staffing": $staffing,"allow_field": ${allow_field != null?'${json.encode(allow_field)}':'null'},"company_name": ${company_name != null?'${json.encode(company_name)}':'null'},"department": ${department != null?'${json.encode(department)}':'null'},"position_level": ${position_level != null?'${json.encode(position_level)}':'null'}}';
  }
}



class Vehicle {

  int id;
  String allow_field;
  String brand;
  String colour;
  String license;


  Vehicle.fromParams({this.id, this.allow_field, this.brand, this.colour, this.license});

  Vehicle.fromJson(jsonRes) {
    id = jsonRes['id'];
    allow_field = jsonRes['allow_field'];
    brand = jsonRes['brand'];
    colour = jsonRes['colour'];
    license = jsonRes['license'];

  }

  @override
  String toString() {
    return '{"id": $id,"allow_field": ${allow_field != null?'${json.encode(allow_field)}':'null'},"brand": ${brand != null?'${json.encode(brand)}':'null'},"colour": ${colour != null?'${json.encode(colour)}':'null'},"license": ${license != null?'${json.encode(license)}':'null'}}';
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


  House.fromParams({this.id, this.is_mortgage, this.address, this.allow_field, this.area, this.mortgage_amount, this.mortgage_creditor, this.opt_mortgage_amount, this.opt_mortgage_creditor, this.owner});

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
    return '{"id": $id,"is_mortgage": $is_mortgage,"address": ${address != null?'${json.encode(address)}':'null'},"allow_field": ${allow_field != null?'${json.encode(allow_field)}':'null'},"area": ${area != null?'${json.encode(area)}':'null'},"mortgage_amount": ${mortgage_amount != null?'${json.encode(mortgage_amount)}':'null'},"mortgage_creditor": ${mortgage_creditor != null?'${json.encode(mortgage_creditor)}':'null'},"opt_mortgage_amount": ${opt_mortgage_amount != null?'${json.encode(opt_mortgage_amount)}':'null'},"opt_mortgage_creditor": ${opt_mortgage_creditor != null?'${json.encode(opt_mortgage_creditor)}':'null'},"owner": ${owner != null?'${json.encode(owner)}':'null'}}';
  }
}

