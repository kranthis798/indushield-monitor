$(function() {
  window.openCustomMsgModal = function(title, lead, smsContent, continueGetURL) {
    var modal = $("#custom_field_modal");
    var customField = $("#custom_field");
    var continueLink = $("#continue_link");

    continueLink.unbind('click');

    modal.contents("h2").html(title);
    modal.contents("p").html(lead);

    //set msg field and watch it.
    customField.val(smsContent);
    $("#chars_left").html((140 - smsContent.length) + " chars left");

    //define continue path
    continueLink.on("click", function(){
      $.get(continueGetURL+"&msg="+customField.val());
      modal.foundation("close");
    });

    //Open up the modal.
    modal.foundation("open");
  }

  $(".vmast_select").change(function(){
        var nam = $(this).attr("name");
        var selval = $(this).val();
        $('tr').removeClass("bg_highlight");
        $('#'+selval+' tr:has(td)').find('input[type="radio"]').prop('checked', true);
        $('#'+selval+' tr').addClass("bg_highlight");
        $('#sel_first_vendor').val($("#vndr_id"+selval).val());
    });

  $("#vac_srch").on("click", function() {
        $("#ftype_lab").hide();
        srchstr = $("#search_vndor").val();
        if(srchstr!=''){
            $("#loadbg").addClass("loading"); 
            $("#search_vndor").attr('readonly', true);
            $.ajax('/vendors_duplicates?search=' + srchstr)
            .done(function (resp) {
                $("#loadbg").removeClass("loading");
                $("#search_vndor").attr('readonly', false);
                $("#vendor_ids").empty();
                if(resp.vendors_list.length>0){
                    arry = resp.vendors_list 
                      arry.sort(function(a, b){
                          var a1= a.us_state, b1= b.us_state;
                          if(a1== b1) return 0;
                          return a1> b1? -1: 1;
                      });
                      $.each(arry, function(val){
                        $("#vendor_ids").append('<option value="'+ this.id +'">'+ this.name +'</option>');
                        $('#sel_vendor_ids').html('');
                    });
                }else{
                   $("#ftype_lab").show();
                   $("#ftype_lab").html("No vendors available"); 
                }
            });
            return false;
        }else{

            $("#ftype_lab").show();
            $("#ftype_lab").html("Please enter keyword to get list of vendors"); 
        }
    });

    $('#search_vndor').keypress(function (event) {
        console.log("event--?",event.keyCode)
         $("#ftype_lab").hide();
        if (event.which == 13 || event.keyCode == 13) {
            srchstr = $("#search_vndor").val()
            if(srchstr!=''){
                $("#loadbg").addClass("loading"); 
                $("#search_vndor").attr('readonly', true);
                $.ajax('/vendors_duplicates?search=' + srchstr)
                .done(function (resp) {
                    $("#loadbg").removeClass("loading");
                    $("#search_vndor").attr('readonly', false);
                    $("#vendor_ids").empty();
                    if(resp.vendors_list.length>0){
                      arry = resp.vendors_list 
                        arry.sort(function(a, b){
                            var a1= a.us_state, b1= b.us_state;
                            if(a1== b1) return 0;
                            return a1> b1? -1: 1;
                        });
                        $.each(arry, function(val){
                            $("#vendor_ids").append('<option value="'+ this.id +'">'+ this.name +'</option>');
                            $('#sel_vendor_ids').html('');
                        });
                    }else{
                       $("#ftype_lab").show();
                       $("#ftype_lab").html("No vendors available"); 
                    }
                });
                return false;
            }else{
              $("#ftype_lab").show();
              $("#ftype_lab").html("Please enter keyword to get list of vendors"); 
            }
        }
    });

    $("#vbt_cancel").click(function (e) {
        location.href='/vendors_duplicates';
        e.preventDefault();
    });

    $(".mcom_select").change(function(){
        var nam = $(this).attr("name")
        $("input[name='"+nam+"']").closest('tr').removeClass('bg_highlight');
        $(this).closest('tr').addClass("bg_highlight");
        
    });

    $('#vbtnRight').click(function (e) {
        $("#ftype_lab").hide();
        var selectedOpts = $('#vendor_ids option:selected');
        if (selectedOpts.length == 0) {
            alert("Nothing to move.");
            e.preventDefault();
        }
        var sel_selectedOpts = $('#sel_vendor_ids option');
        if (selectedOpts.length <=3 && sel_selectedOpts.length<3) {
            $('#sel_vendor_ids').append($(selectedOpts).clone());
            $(selectedOpts).remove();
            $("#vfcom_submit").removeProp("disabled");
        }else{
            $("#ftype_lab").show();
            $("#ftype_lab").html("You are not allowed to select more than 3vendors");
        }
        e.preventDefault();
    });

    $('#vbtnLeft').click(function (e) {
        $("#ftype_lab").hide();
        var selectedOpts = $('#sel_vendor_ids option:selected');
        if (selectedOpts.length == 0) {
            alert("Nothing to move.");
            e.preventDefault();
        }

        $('#vendor_ids').append($(selectedOpts).clone());
        $(selectedOpts).remove();
        e.preventDefault();
    });

    $('#vfcom_submit').click(function() {
        var sel_selectedOpts = $('#sel_vendor_ids option');
        $.each(sel_selectedOpts, function(){
            $(this).attr('selected', true);
        });
        $("#loadbg").addClass("loading"); 
        return true;
    });
    $('#vm_submit').click(function() {
        $("#loadbg").addClass("loading"); 
        return true;
    });
});