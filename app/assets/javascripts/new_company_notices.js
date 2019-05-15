$(function () {
    $("#new-company-notices").DataTable({
        "language": {
            "lengthMenu": "Show: _MENU_"
        }
    });

    $("select.company_notice").change(function(e){
        $.ajax({
            url: '/new_company_notices/'+this.dataset.id,
            type: 'PUT',
            data: {new_company_notice:{status:this.value}}
        });
    });

    var nowTemp = new Date();
    var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
    var initObj = {"maxDate":now};
    $("#new_notice_start_picker").flatpickr(initObj);
    $("#new_notice_end_picker").flatpickr(initObj);
});
