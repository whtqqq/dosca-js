var dataroot="/dosca-js/contents/message.json";
$.ajaxSetup({async:false});

function getMsg(key) {
  var msg;
  $.getJSON(dataroot, function(data) {
    $.each(data, function(k, v) {
      if(k == key) {
        msg = v;
        return false;
      }
    });
  });
  return msg;
}
