$(function() {
  var name_select = $("#remote_command_action_name");
  var delay_field = $("#remote_command_cmd_delay");

  name_select.on("change", function() {
    delay_field.attr("disabled", true);
    if ( this.value == "reboot_tablet" ) {
      delay_field.attr("disabled", false);
    }
  });
});

function getConfirmMsg() {
  var serial = $("#remote_command_serial").val();
  var command = $("#remote_command_action_name").val();
  return "This will send the command '"+command+"' to device serial "+serial;
}