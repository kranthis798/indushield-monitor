$(function() {

  //Enable date/time pickers in Visit form.
  //Got from http://www.jqueryrain.com/?lo_EWr2U
  var nowTemp = new Date();
  var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
  var initObj = {"enableTime": true, "maxDate":now};

  $("#from_datetime").flatpickr(initObj);
  $("#to_datetime").flatpickr(initObj);

  //Listen for Find Vendor AJAX call
  $("#find_vendor_btn").click(function(e) {
    //Get the phone #
    var phone = $("#phone").val();
    var state_id = gon.us_state_id;
    var resultField = $("#vendor-result");
    var vendorIdHiddenField = $("#visit_visitor_id");
    var phoneHiddenField = $("#visit_phone_num");

    //use our controller action to find this visitor
    var url = "/visits/find_visitor?phone="+phone+"&state="+state_id;
    $.get(url, function( data ) {
      if ( data.visitor && data.type == "vendor") {
        //We're good.
        var vendor_name = String(data.visitor.first_name).toLowerCase()+" "+String(data.visitor.last_name).toLowerCase();
        resultField.html("Found Vendor: "+vendor_name);
        vendorIdHiddenField.val(data.visitor.sugar_id);
        phoneHiddenField.val(data.visitor.phone_mobile);
      }
      else {
        //Nope.
        console.log("Lookup failed.");
        resultField.html("We were unable to locate a vendor with the phone number provided.");
        vendorIdHiddenField.val("");
        phoneHiddenField.val("");
      }
    });
  });


  //Listen for resident/staff changes and erase the other.
  var resident_select = $("#visit_resident_id");
  var staff_select = $("#visit_staff_id");
  resident_select.change(function(e){
    //erase staff select
    staff_select.val("");
  });
  staff_select.change(function(e){
    //erase staff select
    resident_select.val("");
  });
});
