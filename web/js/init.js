var picker, picker2;
$(document).ready(function() {
  /*IssueDate init*/
  // $("#IssueDate").val(new Date().Format("yyyy-MM-dd hh:mm:ss"));

  /*Termination Date datepicker init*/
  picker = new Pikaday({
  field: document.getElementById('TerminationDate'),
  firstDay: 1,
  minDate: new Date('2015-01-01'),
  maxDate: new Date('2030-12-31'),
  yearRange: [2015,2030],
  });
  if(document.getElementById('incidentDate') != null) {
    picker2 = new Pikaday({
    field: document.getElementById('incidentDate'),
    firstDay: 1,
    minDate: new Date('2015-01-01'),
    maxDate: new Date('2030-12-31'),
    yearRange: [2015,2030],
    });
  }

  $('#Port').comboSelect();
  $('#Category').comboSelect();

  if(document.getElementById('incidentDate') == null) {
    $('#Picture').fileinput({
      uploadUrl: '#',
      overwriteInitial: false,
      maxFileSize: 300,
      minFileCount: 1,
      maxFileCount: 4,
      showBrowse:false,
      showCaption:false,
      browseOnZoneClick:true,
      previewSettings:{image: {width: "260px", height: "auto"}},
      allowedFileExtensions : ['jpg', 'png', 'gif'],
      dropZoneTitle:"Picture file Drag & Drop here !"
    });
  } else {
    $('#Picture').fileinput({
        uploadUrl: '#',
        overwriteInitial: false,
        maxFileSize: 100,
        maxFileCount: 2,
        showBrowse:false,
        showCaption:false,
        browseOnZoneClick:true,
        previewSettings:{image: {width: "400px", height: "auto"}},
        allowedFileExtensions : ['pdf'],
        dropZoneTitle:"PDF file Drag & Drop here !"
    });
  }

  $("#noPeriod").click();

  /*Add submitBtn active listener*/
  $('input').blur(function () {
    submitBtnActive();
    // alert("submit");
  });
  $('select').blur(function () {
    submitBtnActive();
    // alert("submi11111t");
  });
  $('textarea').blur(function () {
    submitBtnActive();
    // alert("submi11111t");
  });
  $("input[class='combo-input text-input']").blur(function () {
    submitBtnActive();
    // alert("222");
  });

});


/*Termination Date and Period Btn click*/
$("#noPeriod").click(function() {
  $("#noPeriod").attr("class","btn btn-blue");
  $("#Period").attr("class","btn btn-grey");
  $("#TerminationDate").val("-");
  $("#TerminationDate").attr("readonly","true");
  if(picker != null) {
    picker.destroy();
    picker = null;
  }
});
$("#Period").click(function() {
  $("#Period").attr("class","btn btn-blue");
  $("#noPeriod").attr("class","btn btn-grey");

  // $("#TerminationDate").removeAttr("readonly");
  if(picker == null) {
    picker = new Pikaday({
      field: document.getElementById('TerminationDate'),
      firstDay: 1,
      minDate: new Date('2015-01-01'),
      maxDate: new Date('2030-12-31'),
      yearRange: [2015,2030],
    });
  }

  var date = addDay(30);
  $("#TerminationDate").val(date.Format("yyyy-MM-dd"));
});

/*Historical Contents select*/
function selectHistory(e) {
  $("#historyList span").each(function(index) {
    $(this).removeClass("active");
  });
  $(e).addClass("active");

  var text = $(e).text();
  var date = text.substring(0, 19);
  var sub = text.substring(20, text.length);
  $("#pageStatus").val(2);
  $("#editBtn").attr("class", "btn btn-blue").removeAttr("disabled");
  $("#delBtn").attr("class", "btn btn-pink").removeAttr("disabled");
  $("#IssueDate").val(date.replace("_"," ")).removeClass("bg-white");
  /*TerminationDate-start*/
  $("#TerminationDate").removeClass("bg-white");
  $("#incidentDate").removeClass("bg-white");
  $("#noPeriod").click();
  $("#Period").attr("disabled", "disabled");
  $("#noPeriod").attr("disabled", "disabled");
  if(picker != null){
    picker.destroy();
  }
  /*TerminationDate-end*/
  $(".combo-input").attr("disabled", "disabled");
  /*PictureSelect-start*/
  $('#Picture').fileinput('disable');
  $('.file-preview').addClass("bg-disable");
  /*PictureSelect-end*/
  $("#Subject").val(sub).attr("readonly", "readonly");
  $("#Summary").val(sub + "          " + date).attr("readonly", "readonly");
  $("#WebPage").attr("readonly", "readonly");
  $("#Position").attr("readonly", "readonly");
  $("#submitBtn").attr("class", "btn btn-grey").attr("disabled", "disabled");
  $("#preBtn").attr("class", "btn btn-grey").attr("disabled", "disabled");

  $("#Vessel").attr("readonly", "readonly");
  $("#incidentDate").attr("readonly", "readonly");
  $("#Cargo").attr("readonly", "readonly");

  if(picker2 != null){
    picker2.destroy();
  }
  $("#incidentDateMin").attr("disabled", "disabled");
  $("#incidentDateHour").attr("disabled", "disabled");

}

/*EditBtn Click*/
$("#editBtn").on("click", function() {
  $("#pageStatus").val(3);
  $("#editBtn").attr("class", "btn btn-grey").attr("disabled", "disabled");
  $("#delBtn").attr("class", "btn btn-grey").attr("disabled", "disabled");
  $("#IssueDate").addClass("bg-white");
  $("#TerminationDate").addClass("bg-white");
  $("#incidentDate").addClass("bg-white");
  $("#Period").removeAttr("disabled");
  $("#noPeriod").removeAttr("disabled");
  var terminationDate = $("#TerminationDate").val();
  picker = new Pikaday({
    field: document.getElementById('TerminationDate'),
    firstDay: 1,
    minDate: new Date('2015-01-01'),
    maxDate: new Date('2030-12-31'),
    yearRange: [2015,2030],
  });
  if(terminationDate != "-") {
    $("#TerminationDate").val(terminationDate);
  } else {
    $("#TerminationDate").val("-");
  }
  $(".combo-input").removeAttr("disabled");
  $('#Picture').fileinput('enable');
  $('.file-preview').removeClass("bg-disable");

  $("#Subject").removeAttr("readonly");
  $("#Summary").removeAttr("readonly");
  $("#WebPage").removeAttr("readonly");
  $("#Position").removeAttr("readonly");
  $("#submitBtn").attr("class", "btn btn-pink").removeAttr("disabled");
  $("#preBtn").attr("class", "btn btn-blue").removeAttr("disabled");

  $("#Vessel").removeAttr("readonly");
  $("#incidentDate").removeAttr("readonly");
  $("#Cargo").removeAttr("readonly");

  $("#incidentDateMin").removeAttr("disabled");
  $("#incidentDateHour").removeAttr("disabled");
  if(document.getElementById('incidentDate') != null) {
    picker2 = new Pikaday({
      field: document.getElementById('incidentDate'),
      firstDay: 1,
      minDate: new Date('2015-01-01'),
      maxDate: new Date('2030-12-31'),
      yearRange: [2015,2030],
    });
  }
  submitBtnActive();
});


/*Time Format*/
Date.prototype.Format = function(fmt)
{
  var o = {
    "M+" : this.getMonth()+1,                 //月份
    "d+" : this.getDate(),                    //日
    "h+" : this.getHours(),                   //小时
    "m+" : this.getMinutes(),                 //分
    "s+" : this.getSeconds(),                 //秒
    "q+" : Math.floor((this.getMonth()+3)/3), //季度
    "S"  : this.getMilliseconds()             //毫秒
  };
  if(/(y+)/.test(fmt))
    fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
  for(var k in o)
    if(new RegExp("("+ k +")").test(fmt))
  fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
  return fmt;
}

//+---------------------------------------------------
//| 日期计算
//+---------------------------------------------------
Date.prototype.DateAdd = function(strInterval, Number) {
    var dtTmp = this;
    switch (strInterval) {
        case 's' :return new Date(Date.parse(dtTmp) + (1000 * Number));
        case 'n' :return new Date(Date.parse(dtTmp) + (60000 * Number));
        case 'h' :return new Date(Date.parse(dtTmp) + (3600000 * Number));
        case 'd' :return new Date(Date.parse(dtTmp) + (86400000 * Number));
        case 'w' :return new Date(Date.parse(dtTmp) + ((86400000 * 7) * Number));
        case 'q' :return new Date(dtTmp.getFullYear(), (dtTmp.getMonth()) + Number*3, dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(), dtTmp.getSeconds());
        case 'm' :return new Date(dtTmp.getFullYear(), (dtTmp.getMonth()) + Number, dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(), dtTmp.getSeconds());
        case 'y' :return new Date((dtTmp.getFullYear() + Number), dtTmp.getMonth(), dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(), dtTmp.getSeconds());
    }
}

function addDay(dayNumber, date) {
    date = date ? date : new Date();
    var ms = dayNumber * (1000 * 60 * 60 * 24)
    var newDate = new Date(date.getTime() + ms);
    return newDate;
}

/*Submit Chk*/
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
    $("#CategoryMsg").show();
    flg++;
  } else {
    $("#Category").parent().parent().parent().attr("class","");
    $(".combo-input").attr("style", "");
    $("#CategoryMsg").hide();
  }

  if(subject != undefined && subject != null && subject.length == 0) {
    $("#Subject").parent().parent().attr("class", "form-group has-error");
    $("#Subject").next().text("Please input the Subject.");
    flg++;
  } else {
    $("#Subject").parent().parent().attr("class", "form-group");
    $("#Subject").next().text("");
  }

  if(summary != undefined && summary != null && summary.length == 0) {
    $("#Summary").parent().parent().attr("class", "form-group has-error");
    $("#Summary").next().text("Please input the Summary.");
    flg++;
  } else {
    $("#Summary").parent().parent().attr("class", "form-group");
    $("#Summary").next().text("");
  }

  if(position.length == 0) {
    $("#Position").parent().parent().attr("class", "form-group has-error");
    $("#Position").next().text("Please input the Position.");
    flg++;
  } else {
    $("#Position").parent().parent().attr("class", "form-group");
    $("#Position").next().text("");
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
    $("#Vessel").next().text("Please input the Vessel.");
    flg++;
  } else {
    $("#Vessel").parent().parent().attr("class", "form-group");
    $("#Vessel").next().text("");
  }

  if(cargo != undefined && cargo != null && cargo.length == 0) {
    $("#Cargo").parent().parent().attr("class", "form-group has-error");
    $("#Cargo").next().text("Please input the Cargo.");
    flg++;
  } else {
    $("#Cargo").parent().parent().attr("class", "form-group");
    $("#Cargo").next().text("");
  }

  if(flg == 0) {
    //Todo submit
    alert("submit");
  }

}

function submitBtnActive() {
  var flg = 0;
  var category        = $("#Category").val();
  var subject         = $("#Subject").val();
  var summary         = $("#Summary").val();
  var position        = $("#Position").val();
  var terminationDate = $("#TerminationDate").val();
  var vessel          = $("#Vessel").val();
  var cargo           = $("#Cargo").val();

  if(category.length == 0) {
    console.log("**category**");
    flg++;
  }
  if(subject != undefined && subject != null && subject.length == 0) {
    console.log("**subject**");
    flg++;
  }
  if(summary != undefined && summary != null && summary.length == 0) {
    console.log("**summary**");
    flg++;
  }
  if(position.length == 0) {
    console.log("**position**");
    flg++;
  }
  if(terminationDate != undefined && terminationDate != null && terminationDate.length == 0) {
    console.log("**terminationDate**");
    flg++;
  }
  if(vessel != undefined && vessel != null && vessel.length == 0) {
    console.log("**vessel**");
    flg++;
  }
  if(cargo != undefined && cargo != null && cargo.length == 0) {
    console.log("**cargo**");
    flg++;
  }

  if(flg == 0) {
    $("#submitBtn").attr("class", "btn btn-pink").removeAttr("disabled");
  } else {
    $("#submitBtn").attr("class", "btn btn-grey").attr("disabled", "disabled");
  }

}
