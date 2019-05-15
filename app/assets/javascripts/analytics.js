$(function() {
    $("#acct-mgmt-data").DataTable({
        "order": [[0, "asc"]],
        "paging": false,
        "language": {
            "lengthMenu": "Show: _MENU_"
        }
    });
});