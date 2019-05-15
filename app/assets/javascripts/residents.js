$(function () {

	//Mass update Submit
	$("#submit-mass-assign").click(function () {
		var checked = $('.resident_select:checkbox:checked');
		var residentIDs = jQuery.map(checked, function (a) {
			return a.id;
		});
		var buildingID = $("select#building_id").val();
		$.post('/mass_update_residents', {building_id: buildingID, resident_ids: residentIDs}, function (evt) {
			window.location.href = "/communities/" + evt.community_id + "/residents";
		});
	});

	//Select all/none residents
	$("#master_select_chk").change(function () {
		var status = this.checked; // "select all" checked status
		$('.resident_select').each(function () { //iterate all listed checkbox items
			this.checked = status; //change ".checkbox" checked status
		});
	});

	$('#role_ids_active, #role_ids_inactive, #role_ids_defunct').change(function () {
		var comm_id = $("#community_field").val();
		var val = [];
		$('.status_checkbox').each(function (i) {
			if ($('.status_checkbox')[i].checked) {
				val[i] = $(this).val();
			}
		});
		//$(this).prop("checked");
		$.ajax('/filter_residents?checked=' + val + '&community_id=' + comm_id)
		.done(function (resp) {
			//location.reload(true);
			location.href = '/communities/' + comm_id + '/residents'
		});

	});

	$('#rec_per_page').change(function () {
    var comm_id = $("#community_field").val();
      $.ajax('/filter_residents?recpage='+$("#rec_per_page").val()+'&community_id='+comm_id)
        .done(function (resp) {
          location.href='/communities/' + comm_id + '/residents'
      });

  	});

  	$('#res_search').blur(function () {
    var comm_id = $("#community_field").val();
      location.href = '/communities/' + comm_id + '/residents?search=' + $("#res_search").val();
	});

	$('#res_search').keypress(function (event) {
		var comm_id = $("#community_field").val();
		if (event.which == 13 || event.keyCode == 13) {
			console.log("We're in keypress.");
			location.href = '/communities/' + comm_id + '/residents?search=' + $("#res_search").val();
		}
	});

	$("#resident_table").DataTable({
		"order": [[2, "asc"]],
		"iDisplayLength": 100,
		"aoColumnDefs": [
			{"bSortable": false, "aTargets": [0, 10, 11]}
		],
		"columns": [
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			{"orderDataType": "dom-checkbox"},
			{"orderDataType": "dom-checkbox"},
			null,
			null
		],
		"language": {
			"lengthMenu": "Show: _MENU_"
		}
	});
	$("#ledger_visit_table").DataTable({
		"iDisplayLength": 50,
		"aoColumnDefs": [
			{'bSortable': false, 'aTargets': [11]}
		],
		"columns": [
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null
		],
		"language": {
			"lengthMenu": "Show: _MENU_"
		}
	});
	$("#ledger_sign_out_table").DataTable({
		"iDisplayLength": 50,
		"columns": [
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null
		],
		"language": {
			"lengthMenu": "Show: _MENU_"
		}
	});
	$("#staff_members_table").DataTable({
		"aoColumnDefs": [
			{'bSortable': false, 'aTargets': [7, 8]}
		],
		"columns": [
			null,
			null,
			null,
			null,
			null,
			null,
			{"orderDataType": "dom-checkbox"},
			null,
			null
		],
		"language": {
			"lengthMenu": "Show: _MENU_"
		}
	});

	$('#visit-alert-config-form').submit(function () {
		var alerts_only = $("input#only_alerts").val();
		var community_id = $("input#community_id").val();
		var section = $("input#section").val();
		if (alerts_only) {
			window.location.href = "/community/" + community_id + "/alerts?tab=" + section;
		}
		else {
			var status = $("#status");
			var spinner = $("#waiting");
			$(this).prop("disabled", "disabled");//Disable submit for a few seconds
			status.empty();//Clear status
			spinner.show(); //Show spinner
			setTimeout(updateAlertStatus, 2000, $(this), status, spinner);
		}
	});
});

function updateAlertStatus(submitBtn, statusField, spinner) {
	submitBtn.removeProp("disabled");
	spinner.hide();
	statusField.html("Last successfully updated <strong>" + downcaseFirstLetter(moment().calendar()) + "</strong>");
	statusField.show();
}

function downcaseFirstLetter(string) {
	return string.charAt(0).toLowerCase() + string.slice(1);
}