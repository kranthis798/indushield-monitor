$(function() {
  var generateBtn = $("#generate-btn");
  var billingForm = $(".billing_req");
  $("#bill-err").hide();
  $("#intacct-err").hide();
  $("input.report-month-picker").fdatepicker({});
  billingForm.on("ajax:success", function(evt) {
    $("#billing-status").text("We have started working on your request. Please do not submit another one until we've emailed results from this one. Thank you!");
    generateBtn.attr('disabled','disabled');
  });

   var billingImportForm = $(".billing_reqn");
  billingImportForm.on("ajax:success", function(evt, resp) {
    $("#bill-err").hide()
    if(resp.billing_id==''){
      //$("#bill-err").text("Please enter billing ids")
      $("#bill-err").show();
    }else{
      $("#billing-import-status").text("We have started working on your request.");
      $("#bill_act_btn, #bill_act_btn1").attr('disabled','disabled');
    }
  });

  var intacctUpdateForm = $(".sugar_intacct");
  intacctUpdateForm.on("ajax:success", function(evt, resp) {
    $("#intacct-err").hide()
    if(resp.intacct_id==''){
      $("#intacct-err").show();
    }else{
      $("#intacct-update-status").text("We have started working on your request. Please do not submit another one until we've emailed results from this one. Thank you!");
      $("#sugar_intacct_btn").attr('disabled','disabled');
    }
  });
  
});