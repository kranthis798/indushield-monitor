$(document).ready(function() {
    var objValue = $('#obj').val();
    if ( objValue != undefined ) {
        var obj = JSON.parse(objValue);

        $('.add').click(function() {
            var unit_number = $('#unit_number').val();
            var unit = $('#unit').val();
            var result = $('#unit_hash').val();
            if (unit in obj)
                unit_number = parseInt(obj[unit]) + parseInt(unit_number);
            $('#' + unit).remove();
            obj[unit] = unit_number;
            $('#community_info_unit_hash').val(JSON.stringify(obj));
            $('#obj').val(JSON.stringify(obj));
            $(".append_list").append('<li id='+unit+'>' + '<u>' + unit + '-' + unit_number + '</u>'  +' ' + '<a id='+unit+' class="" onclick="removeRow(this)">'+ '<img src="/images/delete.png" alt="Plus">' +'</a>' + '</li>');
        });

        var installDate = $("#community_info_install_date").fdatepicker({});

        var avatar = $('#community_info_avatar');

        avatar.change(function() {
            return $('#file-display').val($(this).val().replace(/^.*[\\\/]/, ''));
        });
    }
});

function removeRow(data) {
  $('#' + $(data).attr('id')).remove();
  var obj2 = JSON.parse($('#obj').val());
  delete obj2[$(data).attr('id')];
  $('#community_info_unit_hash').val(JSON.stringify(obj2));
  return false;
}

function modifyClick(){
  $('#community_info_avatar').click();
  return false;
}
