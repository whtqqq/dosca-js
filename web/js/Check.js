/*##########Submit Chk##########*/
function submitChk(){
  var flg = 0;
  var category         = $("#Category").val();
  var subject          = $("#Subject").val();
  var summary          = $("#Summary").val();
  var position         = $("#Position").val();
  var terminationDate  = $("#TerminationDate").val();
  var vessel           = $("#Vessel").val();
  var cargo            = $("#Cargo").val();
  var incidentDate     = $("#incidentDate").val();
  var incidentDateHour = $("#incidentDateHour").val();
  var incidentDateMin  = $("#incidentDateMin").val();

  if(category.length == 0) {
    $("#Category").parent().parent().parent().attr("class", "has-error");
    $("#Category").nextAll("input").attr("style", "border:1px solid #a94442;");
    $("#Category").parent().attr("style", "margin-bottom: 0px;");
    $("#CategoryMsg").removeAttr("hidden").text(getMsg("MSG_REQUIRE")).show();
    flg++;
  } else {
    $("#Category").parent().parent().parent().attr("class","");
    $(".combo-input").attr("style", "");
    $("#CategoryMsg").attr("hidden", "true");
  }

  if(subject != undefined && subject != null && subject.trim().length == 0) {
    $("#Subject").parent().parent().attr("class", "form-group has-error");
    $("#Subject").next().text(getMsg("MSG_REQUIRE"));
    $("#Subject").show();
    flg++;
  } else {
    $("#Subject").parent().parent().attr("class", "form-group");
    $("#Subject").next().text("");
    if(!inputChk($("#Subject"))) {
      flg++;
    }
  }
  if(summary != undefined && summary != null && summary.trim().length == 0) {
    $("#Summary").parent().parent().attr("class", "form-group has-error");
    $("#Summary").next().text(getMsg("MSG_REQUIRE"));
    $("#Summary").show();
    flg++;
  } else {
    $("#Summary").parent().parent().attr("class", "form-group");
    $("#Summary").next().text("");
    if(!inputChk($("#Summary"))) {
      flg++;
    }
  }
  if(position != undefined && position != null && position.trim().length == 0) {
    $("#Position").parent().parent().attr("class", "form-group has-error");
    $("#Position").next().text(getMsg("MSG_REQUIRE"));
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
    $("#TerminationDate").parent().next().text(getMsg("MSG_REQUIRE"));
    flg++;
  } else {
    $("#TerminationDate").parent().parent().parent().attr("class", "");
    $("#TerminationDate").parent().next().text("");
  }

  if(vessel != undefined && vessel != null && vessel.trim().length == 0) {
    $("#Vessel").parent().parent().attr("class", "form-group has-error");
    $("#Vessel").next().text(getMsg("MSG_REQUIRE"));
    flg++;
  } else {
    $("#Vessel").parent().parent().attr("class", "form-group");
    $("#Vessel").next().text("");
  }

  if(cargo != undefined && cargo != null && cargo.trim().length == 0) {
    $("#Cargo").parent().parent().attr("class", "form-group has-error");
    $("#Cargo").next().text(getMsg("MSG_REQUIRE"));
    flg++;
  } else {
    $("#Cargo").parent().parent().attr("class", "form-group");
    $("#Cargo").next().text("");
  }

  if((incidentDate != undefined && incidentDate != null && incidentDate.length == 0) ||
    (incidentDateHour != undefined && incidentDateHour != null && incidentDateHour.length == 0) ||
    (incidentDateMin != undefined && incidentDateMin != null && incidentDateMin.length == 0)
  ) {
    $("#incidentGroup").attr("class", "form-group has-error");
    $("#incidentMsg").text(getMsg("MSG_REQUIRE"));
    flg++;
  } else {
    $("#incidentGroup").attr("class", "form-group");
    $("#incidentMsg").text("");
    $("#dateTime").val(incidentDate + " " + incidentDateHour + ":" + incidentDateMin);
  }

  if(subject != undefined && subject != null && subject.trim().length != 0) {
    if(!inputChk($("#Subject"))){
      flg ++;
    }
  }

  if(summary != undefined && summary != null && summary.trim().length != 0) {
    if(!inputChk($("#Summary"))){
      flg ++;
    }
    summaryLineNumChk(flg);
  }

  if(position != undefined && position != null && position.trim().length != 0) {
    if(!inputChk($("#Position"))){
      flg ++;
    }
    if(!pointChk()){
      flg ++;
    }
  }

  if(vessel != undefined && vessel != null && vessel.trim().length != 0) {
    if(!inputChk($("#Vessel"))){
      flg ++;
    }
  }

  if(cargo != undefined && cargo != null && cargo.trim().length != 0) {
    if(!inputChk($("#Cargo"))){
      flg ++;
    }
  }

  if($("#pageID").val() == "edit") {
    if(!afterDateChk()) {
      flg ++;
    }
  }

  if(!URLChk($('#WebPage'))) {
    flg ++;
  }


  var submitStatus = true;
  if(flg != 0) {
    submitStatus = false;
  } else {
    //D3 pic save
    svgAsPngUri($('svg')[0], {}, function(uri) {
      $("#d3Map").val(uri);
    });
    //file upload submit
    $('#Picture')
    .on("filebatchuploaderror", function(event, data) {
      if(data.response) {
          submitStatus = false;
      }
    })
    .on("filecustomerror", function(event, data) {
      if(data.response) {
          submitStatus = false;
      }
    })
    .on("fileuploaderror", function(event, data) {
      if(data.response) {
          submitStatus = false;
      }
    })
    .on("filebatchuploadsuccess", function(event, data) {
      if(data.response) {
          submitStatus = true;
      }
    });
    //new page
    if($('#Picture').fileinput('getFilesCount') > 0 ) {
      $('#Picture').fileinput('upload');
    }
    //past page
    if($("#pageID").val() == "past" && $('#Picture').fileinput('getFilesCount') == 0 && $("#picUp").val() == "false") {
      submitStatus = false;
      $('#Picture').fileinput('upload');
    }
    if($("#pageID").val() == "past") {
      $('#Picture').fileinput('upload');
    }
    //Todo submit
    alert("submitStatus:"+submitStatus);
  }
  return submitStatus;
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
    $(e).next().text(getMsg("MSG_ILLEGAL"));
    $(e).next().show();
    return false;
  }
}

function inputBlurChk(e) {
  var value = $(e).val();
  if($("#pageStatus").val() == "4") {
    if(value != undefined && value != null && value.length == 0) {
      $(e).parent().parent().attr("class", "form-group has-error");
      $(e).next().text(getMsg("MSG_REQUIRE")).show();
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
      return true;
    } else {
      $(e).parent().parent().attr("class","form-group has-error");
      $(e).next().text(getMsg("MSG_URL"));
      $(e).next().show();
      return false;
    }
  } else {
    $(e).parent().parent().attr("class","form-group");
    $(e).next().hide();
    return true;
  }
}


function pointChk() {
  var input = $('#Position').val();
  if(input != null && input.length > 0) {
    var reg = /^(([1-9]\d?)(\.\d{1,5})?|(1[0-7]\d)(\.\d{1,5})?|180(\.0{1,5})?|0(\.\d{1,5})?)[EW]\,(([1-9])(\.\d{1,5})?|([1-8]\d)(\.\d{1,5})?|90(\.0{1,5})?)[SN]$/;

    if(reg.test(input)) {
      $('#Position').parent().parent().attr("class","form-group");
      $('#Position').next().hide();
      return true;
    }else{
      $('#Position').parent().parent().attr("class","form-group has-error");
      $('#Position').next().text(getMsg("MSG_POSITIONILLEGAL"));
      $('#Position').next().show();
      return false;
    }
  }
}

function afterDateChk() {
  var date = $("#TerminationDate").val();
  var now = new Date().Format("yyyy-MM-dd");
  if(date != " ") {
    var pageDate = new Date(date);
    var nowDate = new Date(now);
    if(nowDate.getTime() > pageDate.getTime()){
      $("#TerminationDate").parent().parent().parent().attr("class", "has-error");
      $("#TerminationDate").parent().next().text(getMsg("MSG_TERMINATIONSTART"));
      return false;
    } else {
      return true;
    }
  }
}

function summaryLineNumChk(flg) {
  var strs = new Array();
  strs = $("#Summary").val().split("\n");
  var lineNum = strs.length;

  if(lineNum > 25) {
    $("#Summary").parent().parent().attr("class", "form-group has-error");
    $("#Summary").next().text(getMsg("MSG_SUMMARYLINE"));
    $("#Summary").next().show();
    flg++;
  } else {
    for(var line in strs) {
      var tmp = Math.ceil(strs[line].length/120)-1;
      if(tmp > 0) {
        lineNum += tmp;
      }
      if(lineNum > 25) {
        $("#Summary").parent().parent().attr("class", "form-group has-error");
        $("#Summary").next().text(getMsg("MSG_SUMMARYLINE"));
        $("#Summary").next().show();
        flg++
        break;
      }
    }
  }
}
