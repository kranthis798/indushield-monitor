//= require_tree .

$(function() {
	//Look for any selects that we need to confirm from Sugar IDs to postgres IDs.
	$.map($("div.linked-visits").find("option"), function(optionElement) {
		//	text value of these options is "something | something | id"...split by pipe, it's the last element.
		var parts = optionElement.text.split("|");
		var pgID = parts[parts.length - 1].trim();
		optionElement.value = pgID;
	});
});