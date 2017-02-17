var picker, picker2;
$(document).ready(function() {
  /*IssueDate init*/
  // $("#IssueDate").val(new Date().Format("yyyy-MM-dd hh:mm:ss"));
/*##########Termination Date datepicker init##########*/

  changeLayout();
  picker = new Pikaday({
  field: document.getElementById('TerminationDate'),
  firstDay: 1,
  minDate: new Date(),
  maxDate: new Date('2030-12-31'),
  yearRange: [2017,2030],
  });
  if(document.getElementById('incidentDate') != null) {
    picker2 = new Pikaday({
    field: document.getElementById('incidentDate'),
    firstDay: 1,
    minDate: new Date('1980-01-01'),
    maxDate: new Date(),
    yearRange: [2017,2030],
    });
  }
  $('#Port').comboSelect();
  $('#Category').comboSelect();
  if(document.getElementById('incidentDate') == null) {
    $('#Picture').fileinput({
      theme: "explorer",
      uploadAsync:false,
      // uploadUrl: '#',
      overwriteInitial: false,
      // maxFileSize: 300,
      minFileCount: 1,
      maxFileCount: 4,
      showBrowse:false,
      showCaption:false,
      showUpload:false,
      browseOnZoneClick:true,
      resizeImage: true,
      maxImageWidth: 200,
      maxImageHeight: 200,
      resizePreference: 'width',
      fileActionSettings:{showUpload:false},
      // previewSettings:{image: {width: "260px", height: "auto"}},
      allowedFileExtensions : ['jpg', 'png', 'gif'],
      dropZoneTitle:"Picture file（jpeg/jpg/png） Drag & Drop here !"
    });
  } else {
    $('#Picture').fileinput({
        theme: "explorer",
        // uploadUrl: '#',
        uploadAsync:false,
        overwriteInitial: false,
        maxFileSize: 100,
        minFileCount: 1,
        maxFileCount: 2,
        showBrowse:false,
        showCaption:false,
        showUpload:false,
        browseOnZoneClick:true,
        resizeImage: true,
        maxImageWidth: 200,
        maxImageHeight: 200,
        resizePreference: 'width',
        fileActionSettings:{showUpload:false},
        // previewSettings:{image: {width: "400px", height: "auto"}},
        allowedFileExtensions : ['pdf'],
        dropZoneTitle:"PDF file Drag & Drop here !"
    });
  }
  $("#noPeriod").click();
  submitBtnActive();
//+---------------------------------------------------
//| listener
//+---------------------------------------------------
/*##########Add Change listener##########*/
  $('input').change(function () {
    $("#pageStatus").val("4");
    submitBtnActive();
  });
  $('select').change(function () {
    $("#pageStatus").val("4");
    submitBtnActive();
  });
  $('textarea').change(function () {
    $("#pageStatus").val("4");
    submitBtnActive();
  });
  $("input[class='combo-input text-input']").change(function () {
    $("#pageStatus").val("4");
    submitBtnActive();
  });
/*##########Add submitBtn active listener##########*/
  // $('#Subject').blur(function () {
  //   inputBlurChk($('#Subject'));
  // });
  // $('#Summary').blur(function () {
  //   inputBlurChk($('#Summary'));
  //   summaryLineNumChk();
  // });
  // $('#Position').blur(function () {
  //   inputBlurChk($('#Position'));
  // });
  // $('#WebPage').blur(function () {
  //   URLChk($('#WebPage'));
  // });

  if($("#pageStatus").val() == 2 && $("#pageID").val() == "past") {
    $("#PictureDownload").attr("style", "display:block;");
  }

});

//+---------------------------------------------------
//| 日期計算
//+---------------------------------------------------
/*##########Time Format##########*/
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

function changeLayout() {
  var historyH = $("#leftPanel").height() - $("#locationPanel").height() - 50;
  var historyH_str = "height: " + historyH +"px";
  $("#historyList").attr("style", historyH_str);
}
