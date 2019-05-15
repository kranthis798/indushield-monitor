$(function () {
    $("#resident-care-visits").DataTable({
        "language": {
            "lengthMenu": "Show: _MENU_"
        }
    });
    $("#comm-employee-visits").DataTable({
        "language": {
            "lengthMenu": "Show: _MENU_"
        }
    });
    $("#vendor-care-visits").DataTable({
        "language": {
            "lengthMenu": "Show: _MENU_"
        }
    });
    $("#company-care-visits").DataTable({
        "language": {
            "lengthMenu": "Show: _MENU_"
        }
    });
    $("#service-type-visits").DataTable({
        "language": {
            "lengthMenu": "Show: _MENU_"
        }
    });
    $("#report_comm_breakdown").DataTable({
        "processing":true,
        "serverSide":true,
        "ajax":"community_breakdown_paginate",
        "searchDelay":3000,
        "aoColumnDefs": [
            {"bSortable": false, "aTargets": [1,2,3,4,5]}
        ],
        "bLengthChange": false,
        "oLanguage": {
            "sSearch": "Search Community Names:"
        },
        "language": {
            "lengthMenu": "Show: _MENU_"
        }
    });
    $("#report_comm_service_summary").DataTable({
        "language": {
            "lengthMenu": "Show: _MENU_"
        }
    });
    $("#service_type_details").DataTable({
        "language": {
            "lengthMenu": "Show: _MENU_"
        }
    });
    $("#staff_details").DataTable({
        "language": {
            "lengthMenu": "Show: _MENU_"
        }
    });
    $("#service_type_summary").DataTable({
        "order": [[ 2, "desc" ]],
        "language": {
            "lengthMenu": "Show: _MENU_"
        }
    });

    //Staff List.
    $("#report_comm_vendors").DataTable({
        "processing":true,
        "serverSide":true,
        "ajax":"staff_list_paginate",
        "searchDelay":3000,
        "bLengthChange": false,
        "aoColumnDefs": [
            {"bSortable": false, "aTargets": [3,4,5,6,7,8,9,10,11]}
        ],
        "oLanguage": {
            "sSearch": "Search Staff/Phone/Community :"
        },
        "language": {
            "lengthMenu": "Show: _MENU_"
        }
    });

    $("select#vendor_sugar_id").select2();

    $(".mcom_select").change(function(){
        var nam = $(this).attr("name")
        $("input[name='"+nam+"']").closest('tr').removeClass('bg_highlight');
        $(this).closest('tr').addClass("bg_highlight");
        
    });

    $(".mast_select").change(function(){
        var nam = $(this).attr("name");
        var selval = $(this).val();
        $('tr').removeClass("bg_highlight");
        $('#'+selval+' tr:has(td)').find('input[type="radio"]').prop('checked', true);
        $('#'+selval+' tr').addClass("bg_highlight");
        $('#sel_first_com').val($("#com_id"+selval).val());
        $('#sel_first_com_opt').val($("#com_opt_id"+selval).val());
        // $("input[name='"+nam+"']").closest('tr').removeClass('bg_highlight');
        // $(this).closest('tr').addClass("bg_highlight");
        // $("input[name='selchk[name]']")[selval].checked = true;
        // $("input[name='selopt[billing_id]']")[selval].checked = true;
        // $("input[name='selchk[name]']").closest('tr').removeClass("bg_highlight");
        // $("input[name='selopt[billing_id]']").closest('tr').removeClass("bg_highlight");
        // $("input[name='selchk[name]']").each(function() {
        //      if ($(this).is(':checked')){
        //         $(this).closest('tr').addClass("bg_highlight");
        //      }
        // });
        // $("input[name='selopt[billing_id]']").each(function() {
        //      if ($(this).is(':checked')){
        //         $(this).closest('tr').addClass("bg_highlight");
        //      }
        // });

    });

    $("#ac_srch").on("click", function() {
        $("#ftype_lab").hide();
        srchstr = $("#search_com").val();
        if(srchstr!=''){
            $("#loadbg").addClass("loading"); 
            $("#search_com").attr('readonly', true);
            $.ajax('/companies_duplicates?search=' + srchstr)
            .done(function (resp) {
                $("#loadbg").removeClass("loading");
                $("#search_com").attr('readonly', false);
                $("#company_ids").empty();
                if(resp.companies_list.length>0){
                    arry = resp.companies_list 
                    /*arry.sort(function(a, b){
                        var a1= a.us_state, b1= b.us_state;
                        if(a1== b1) return 0;
                        return a1> b1? -1: 1;
                    });*/
                    $.each(arry, function(val){
                        $("#company_ids").append('<option value="'+ this.id +'">'+ this.name +'</option>');
                        $('#sel_company_ids').html('');
                    });
                }else{
                   $("#ftype_lab").show();
                   $("#ftype_lab").html("No companies available"); 
                }
                //+' ('+this.type+')'
            });
            return false;
        }else{
            $("#ftype_lab").show();
            $("#ftype_lab").html("Please enter keyword to get list of companies"); 
        }
    });

    $('#search_com').keypress(function (event) {
        console.log("event--?",event.keyCode)
         $("#ftype_lab").hide();
        if (event.which == 13 || event.keyCode == 13) {
            srchstr = $("#search_com").val()
            if(srchstr!=''){
                $("#loadbg").addClass("loading"); 
                $("#search_com").attr('readonly', true);
                $.ajax('/companies_duplicates?search=' + srchstr)
                .done(function (resp) {
                    $("#loadbg").removeClass("loading");
                    $("#search_com").attr('readonly', false);
                    $("#company_ids").empty();
                    if(resp.companies_list.length>0){
                        arry = resp.companies_list 
                        /*arry.sort(function(a, b){
                            var a1= a.us_state, b1= b.us_state;
                            if(a1== b1) return 0;
                            return a1> b1? -1: 1;
                        });*/
                    $.each(arry, function(val){
                            $("#company_ids").append('<option value="'+ this.id +'">'+ this.name +'</option>');
                            $('#sel_company_ids').html('');
                        });
                    }else{
                       $("#ftype_lab").show();
                       $("#ftype_lab").html("No companies available"); 
                    }
                });
                return false;
            }else{
                $("#ftype_lab").show();
                $("#ftype_lab").html("Please enter keyword to get list of companies"); 
            }
        }
    });

    $("#bt_cancel").click(function (e) {
        location.href='/companies_duplicates';
        e.preventDefault();
    });

    $('#btnRight').click(function (e) {
        $("#ftype_lab").hide();
        var selectedOpts = $('#company_ids option:selected');
        if (selectedOpts.length == 0) {
            alert("Nothing to move.");
            e.preventDefault();
        }
        var sel_selectedOpts = $('#sel_company_ids option');
        if (selectedOpts.length <=3 && sel_selectedOpts.length<3) {
            $('#sel_company_ids').append($(selectedOpts).clone());
            $(selectedOpts).remove();
            $("#fcom_submit").removeProp("disabled");
        }else{
            $("#ftype_lab").show();
            $("#ftype_lab").html("You are not allowed to select more than 3companies");
        }
        e.preventDefault();
    });

    $('#btnLeft').click(function (e) {
        $("#ftype_lab").hide();
        var selectedOpts = $('#sel_company_ids option:selected');
        if (selectedOpts.length == 0) {
            alert("Nothing to move.");
            e.preventDefault();
        }

        $('#company_ids').append($(selectedOpts).clone());
        $(selectedOpts).remove();
        e.preventDefault();
    });

    $('#fcom_submit').click(function() {
        var sel_selectedOpts = $('#sel_company_ids option');
        $.each(sel_selectedOpts, function(){
            $(this).attr('selected', true);
        });
        $("#loadbg").addClass("loading"); 
        return true;
    });
    $('#m_submit').click(function() {
        $("#loadbg").addClass("loading"); 
        return true;
    });

});

function render_checkbox(data, type, full) {
    var checked = "";
    if (data == true) {
        { checked = "checked='true'" };
        return "";
    }
}