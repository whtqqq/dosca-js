var dataroot="/dosca-js/contents/message.json";
$.getJSON(dataroot, function(data){
  MSG_NEWPAGE           = data.newPage;
  MSG_DELITEM           = data.delItem;
  MSG_REQUIRE           = data.inputRequired;
  MSG_ILLEGAL           = data.inputIllegal;
  MSG_URL               = data.URL;
  MSG_TERMINATIONSTART  = data.terminationStart;
  MSG_SUMMARYLINE       = data.summaryLine;
  MSG_LOGINERROR        = data.loginError;
  MSG_LOGINNAME         = data.loginName;
  MSG_LOGINPWD          = data.loginPWD;
  MSG_LOGINEMAIL        = data.loginEmail;
  MSG_LOGINEMAILILLEGAL = data.loginMailIllegal;
});
