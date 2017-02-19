/*##########Termination Date and Period Btn click##########*/
$("#noPeriod").click(function() {
  $("#noPeriod").attr("class", "btn btn-blue");
  $("#Period").attr("class", "btn btn-grey");
  $("#TerminationDate").val(" ");
  $("#TerminationDate").attr("readonly", "true").attr("style", "cursor:disabled;");
  if(picker != null) {
    picker.destroy();
    picker = null;
  }
});
$("#Period").click(function() {
  $("#Period").attr("class", "btn btn-blue");
  $("#noPeriod").attr("class", "btn btn-grey");

  // $("#TerminationDate").removeAttr("readonly");
  if(picker == null) {
    picker = new Pikaday({
      field: document.getElementById('TerminationDate'),
      firstDay: 1,
      minDate: new Date(),
      maxDate: new Date('2030-12-31'),
      yearRange: [2017,2030],
    });
  }

  var date = addDay(30);
  $("#TerminationDate").attr("style", "cursor:pointer;");
  $("#TerminationDate").val(date.Format("yyyy-MM-dd"));
});

/*##########Historical Contents select##########*/
function selectHistory() {
  // $("#pageStatus").val("2");
  // $("#historyList span").each(function(index) {
  //   $(this).removeClass("active");
  // });
  // $(e).addClass("active");

  $(".combo-arrow").attr("class", "combo-arrow1");

  // var text = $(e).text();
  // var date = text.substring(0, 19);
  // var sub = text.substring(20, text.length);
  $("#editBtn").attr("class", "btn btn-blue").removeAttr("disabled");
  $("#delBtn").attr("class", "btn btn-pink delJump").removeAttr("disabled");
  $("#IssueDate").removeClass("bg-white");
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
  $("#Subject").attr("readonly", "readonly");
  $("#Summary").attr("readonly", "readonly");
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
  reSetForm();

}

/*##########EditBtn Click##########*/
function editBtnAction() {
  $("#editBtn").attr("class", "btn btn-grey").attr("disabled", "disabled");
  $("#delBtn").attr("class", "btn btn-grey").attr("disabled", "disabled");
  $("#PictureDownload").removeAttr("disabled");
  $("#IssueDate").addClass("bg-white");
  $("#TerminationDate").addClass("bg-white");
  $("#incidentDate").addClass("bg-white");
  $("#Period").removeAttr("disabled");
  $("#noPeriod").removeAttr("disabled");
  var terminationDate = $("#TerminationDate").val();
  picker = new Pikaday({
    field: document.getElementById('TerminationDate'),
    firstDay: 1,
    minDate: new Date(),
    maxDate: new Date('2030-12-31'),
    yearRange: [2017,2030],
  });
  if(terminationDate != " ") {
    $("#TerminationDate").val(terminationDate);
  } else {
    $("#noPeriod").click();
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
      minDate: new Date('1980-01-01'),
      maxDate: new Date(),
      yearRange: [2017,2030],
    });
  }
  $("#pageStatus").val(3);
  $(".combo-arrow1").attr("class", "combo-arrow");
  reSetForm();
  submitBtnActive();
};

// function editBtnAction2() {
//   $("#editBtn").attr("class", "btn btn-grey").attr("disabled", "disabled");
//   $("#delBtn").attr("class", "btn btn-grey").attr("disabled", "disabled");
//
//
//   $('#Picture').fileinput('enable');
//   $('.file-preview').removeClass("bg-disable");
//
//   $("#submitBtn").attr("class", "btn btn-pink").removeAttr("disabled");
//
//   $("#pageStatus").val(3);
//   reSetForm();
//   submitBtnActive();
// };

function reSetForm() {
    $("#Category").parent().parent().parent().attr("class","");
    $(".combo-input").attr("style", "");
    $("#CategoryMsg").hide();

    $("#Subject").parent().parent().attr("class", "form-group");
    $("#Subject").next().text("");

    $("#Summary").parent().parent().attr("class", "form-group");
    $("#Summary").next().text("");

    $("#Position").parent().parent().attr("class", "form-group");
    $("#Position").next().text("");

    $("#TerminationDate").parent().parent().parent().attr("class", "");
    $("#TerminationDate").parent().next().text("");

    $("#Vessel").parent().parent().attr("class", "form-group");
    $("#Vessel").next().text("");

    $("#Cargo").parent().parent().attr("class", "form-group");
    $("#Cargo").next().text("");

    $("#incidentGroup").attr("class", "form-group");
    $("#incidentMsg").text("");
}

function delAction() {
  console.log("/dosca-js/edit/delete?contents_code=" + $("#ContentCode").val() + "&contents_no=" + $("#ContentNo").val());
  $.ajax({
    async:false,
    type:"GET",
    url:"/dosca-js/edit/delete?contents_code=" + $("#ContentCode").val() + "&contents_no=" + $("#ContentNo").val(),
    success:function(data,textStatus,jqXHR){
        console.log(data)
        console.log(textStatus)
        console.log(jqXHR)
        $.alert(getMsg("MSG_DELSUCCESS"));
        $("#newJumpN").click();
    },
    error:function(xhr,textStatus){
        console.log('错误')
        console.log(xhr)
        console.log(textStatus)
    }
  });
}
