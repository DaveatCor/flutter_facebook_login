class validationMixin {
  String validationEmail(val) {
    if(!val.contains('@')){
      return 'Please input valid email.';
    } 
    // else { email = val;}
    return null;
  }
  String validationPassword(String value){
    if(value.length < 4){
      return 'Password must be at least 4 character.';
    } 
    // else { password = value; }
    return null;
  }
}