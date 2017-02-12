/*##########Submit Chk##########*/
function submitChk(){
  var flg = 0;
  var category        = $("#Category").val();
  var subject         = $("#Subject").val();
  var summary         = $("#Summary").val();
  var position        = $("#Position").val();
  var terminationDate = $("#TerminationDate").val();
  var vessel          = $("#Vessel").val();
  var cargo           = $("#Cargo").val();

  if(category.length == 0) {
    $("#Category").parent().parent().parent().attr("class", "has-error");
    $("#Category").nextAll("input").attr("style", "border:1px solid red;");
    $("#Category").parent().attr("style", "margin-bottom: 0px;");
    $("#CategoryMsg").removeAttr("hidden");
    $("#CategoryMsg").show();
    flg++;
  } else {
    $("#Category").parent().parent().parent().attr("class","");
    $(".combo-input").attr("style", "");
    $("#CategoryMsg").attr("hidden", "true");
  }

  if(subject != undefined && subject != null && subject.length == 0) {
    $("#Subject").parent().parent().attr("class", "form-group has-error");
    $("#Subject").next().text("Please input the Item.");
    flg++;
  } else {
    $("#Subject").parent().parent().attr("class", "form-group");
    $("#Subject").next().text("");
    if(!inputChk($("#Subject"))) {
      flg++;
    }
  }
  if(summary != undefined && summary != null && summary.length == 0) {
    $("#Summary").parent().parent().attr("class", "form-group has-error");
    $("#Summary").next().text("Please input the Item.");
    flg++;
  } else {
    $("#Summary").parent().parent().attr("class", "form-group");
    $("#Summary").next().text("");
    if(!inputChk($("#Summary"))) {
      flg++;
    }
  }
  if(position != undefined && position != null && position.length == 0) {
    $("#Position").parent().parent().attr("class", "form-group has-error");
    $("#Position").next().text("Please input the Item.");
    flg++;
  } else {
    $("#Position").parent().parent().attr("class", "form-group");
    $("#Position").next().text("");
    if(!inputChk($("#Position"))) {
      flg++;
    }
  }

  if(terminationDate != undefined && terminationDate != null && terminationDate.length == 0) {
    $("#TerminationDate").parent().parent().parent().attr("class", "has-error");
    $("#TerminationDate").parent().next().text("Please select the Termination Date.");
    flg++;
  } else {
    $("#TerminationDate").parent().parent().parent().attr("class", "");
    $("#TerminationDate").parent().next().text("");
  }

  if(vessel != undefined && vessel != null && vessel.length == 0) {
    $("#Vessel").parent().parent().attr("class", "form-group has-error");
    $("#Vessel").next().text("Please input the Item.");
    flg++;
  } else {
    $("#Vessel").parent().parent().attr("class", "form-group");
    $("#Vessel").next().text("");
  }

  if(cargo != undefined && cargo != null && cargo.length == 0) {
    $("#Cargo").parent().parent().attr("class", "form-group has-error");
    $("#Cargo").next().text("Please input the Item.");
    flg++;
  } else {
    $("#Cargo").parent().parent().attr("class", "form-group");
    $("#Cargo").next().text("");
  }

  if(subject != undefined && subject != null && subject.length != 0) {
    if(!inputChk($("#Subject"))){
      flg ++;
    }
  }

  if(summary != undefined && summary != null && summary.length != 0) {
    if(!inputChk($("#Summary"))){
      flg ++;
    }
  }

  if(position != undefined && position != null && position.length != 0) {
    if(!inputChk($("#Position"))){
      flg ++;
    }
  }

  if($("#pageID").val() == "edit") {
    if(!afterDateChk()) {
      flg ++;
    }
  }

  if(flg != 0) {
    return false;
  } else {
    //Todo submit
    alert("submit");
    return true;
  }

}


function submitBtnActive() {
  var status = $("#pageStatus").val();
  if(status == 4) {
    $("#submitBtn").attr("class", "btn btn-pink").removeAttr("disabled");
    $("#preBtn").attr("class", "btn btn-blue").removeAttr("disabled");
  } else {
    $("#submitBtn").attr("class", "btn btn-grey").attr("disabled", "disabled");
    $("#preBtn").attr("class", "btn btn-grey").attr("disabled", "disabled");
  }
}
// function submitBtnActive() {
//   var flg = 0;
//   var category        = $("#Category").val();
//   var subject         = $("#Subject").val();
//   var summary         = $("#Summary").val();
//   var position        = $("#Position").val();
//   var terminationDate = $("#TerminationDate").val();
//   var vessel          = $("#Vessel").val();
//   var cargo           = $("#Cargo").val();
//
//   if(category.length == 0) {
//     console.log("**category**");
//     flg++;
//   }
//   if(subject != undefined && subject != null && subject.length == 0) {
//     console.log("**subject**");
//     flg++;
//   }
//   if(summary != undefined && summary != null && summary.length == 0) {
//     flg++;
//     console.log("**summary**");
//   }
//   if(position != undefined && position != null && position.length == 0) {
//     console.log("**position**");
//     flg++;
//   }
//   if(terminationDate != undefined && terminationDate != null && terminationDate.length == 0) {
//     console.log("**terminationDate**");
//     flg++;
//   }
//   if(vessel != undefined && vessel != null && vessel.length == 0) {
//     console.log("**vessel**");
//     flg++;
//   }
//   if(cargo != undefined && cargo != null && cargo.length == 0) {
//     console.log("**cargo**");
//     flg++;
//   }
//
//   if(flg == 0) {
//     $("#submitBtn").attr("class", "btn btn-pink").removeAttr("disabled");
//   } else {
//     $("#submitBtn").attr("class", "btn btn-grey").attr("disabled", "disabled");
//   }
//
// }

/*##########input chk##########*/
function inputChk(e) {
  var input = $(e).val();
  var reg = /^[ -~\n]+$/;

  if(reg.test(input)) {
    $(e).parent().parent().attr("class","form-group");
    $(e).next().hide();
    return true;
  }else{
    $(e).parent().parent().attr("class","form-group has-error");
    $(e).next().text("Illegal characters, please re-fill.");
    $(e).next().show();
    return false;
  }
}

function inputBlurChk(e) {
  var value = $(e).val();
  if($("#pageStatus").val() == "4") {
    if(value != undefined && value != null && value.length == 0) {
      $(e).parent().parent().attr("class", "form-group has-error");
      $(e).next().text("Please input the Item.").show();
    } else {
      $(e).parent().parent().attr("class", "form-group");
      $(e).next().text("").hide();
      inputChk($(e));
    }
  }
}

function URLChk(e) {
  var url = $(e).val();
  var reg=/^[a-zA-z]+:\/\/[^s]*/;
  if(url != null && url.length != 0) {
    if(reg.test(url)) {
      $(e).parent().parent().attr("class","form-group");
      $(e).next().hide();
    } else {
      $(e).parent().parent().attr("class","form-group has-error");
      $(e).next().text("Illegal characters, please re-fill. (Example: http://www.google.com)");
      $(e).next().show();
    }
  } else {
    $(e).parent().parent().attr("class","form-group");
    $(e).next().hide();
  }
}

function afterDateChk() {
  var date = $("#TerminationDate").val();
  var now = new Date().Format("yyyy-MM-dd");
  if(date != "-") {
    var pageDate = new Date(date);
    var nowDate = new Date(now);
    if(nowDate.getTime() > pageDate.getTime()){
      $("#TerminationDate").parent().parent().parent().attr("class", "has-error");
      $("#TerminationDate").parent().next().text("Please since today select the Termination Date.");
      return false;
    } else {
      return true;
    }
  }
}
