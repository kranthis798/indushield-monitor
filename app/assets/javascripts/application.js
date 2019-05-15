// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require jquery.turbolinks
//= require moment
//= require foundation-datepicker.min
//= require select2
//= require_tree .
!function(){var analytics=window.analytics=window.analytics||[];if(!analytics.initialize)if(analytics.invoked)window.console&&console.error&&console.error("Segment snippet included twice.");else{analytics.invoked=!0;analytics.methods=["trackSubmit","trackClick","trackLink","trackForm","pageview","identify","reset","group","track","ready","alias","debug","page","once","off","on"];analytics.factory=function(t){return function(){var e=Array.prototype.slice.call(arguments);e.unshift(t);analytics.push(e);return analytics}};for(var t=0;t<analytics.methods.length;t++){var e=analytics.methods[t];analytics[e]=analytics.factory(e)}analytics.load=function(t,e){var n=document.createElement("script");n.type="text/javascript";n.async=!0;n.src="https://cdn.segment.com/analytics.js/v1/"+t+"/analytics.min.js";var a=document.getElementsByTagName("script")[0];a.parentNode.insertBefore(n,a);analytics._loadOptions=e};analytics.SNIPPET_VERSION="4.1.0";
  analytics.load("nneCiU8OJCVmCW8AsuxurLQL1xNTiceh");
  analytics.page();
  }
}();

$(function () {
  $(document).foundation();

  //Custom field modal: Used for editing SMS content generically
  //Listen for "Cancel" button and update chars left field.
  $(".close-modal").on("click", function() {
    $("#custom_field_modal").foundation("close");
  });

  $("#custom_field").on("keyup", function (event) {
    var left = 140 - $(this).val().length;
    $("#chars_left").html(left + " chars left");
  });

});

function closeVendorConfirm() {
  $('#remind_modal').foundation('close');
}

function openVendorConfirm(vendor_path, lead_copy) {
  $("#yes_link").attr("disabled", false);
  $("#yes_link").attr("href", vendor_path);
  $("#lead").html(lead_copy);
  $('#remind_modal').foundation('open');
}

function disableRemindYes() {
  $("#yes_link").attr("disabled", true);
}

function showMsgModal(title, msg) {
  $("#msg_modal #msg").html(msg);
  $("#msg_modal #title").html(title);
  $('#msg_modal').foundation('open');
}

function closeMsgModal() {
  $('#msg_modal').foundation('close');
}

function resetFoundation() {
  $(document).foundation('alert', 'reflow');
}

function unescapeHtml(safe) {
  return $('<div />').html(safe).text();
}

$(document).ready(function() {
  $("#company_id").select2(); $("#community_id").select2();

$("#reports-submit").on("click", function(e){
  var value = $("#service_type").val();
  if (value === null){
    alert("Please select any service type");
      return false;
  }
})


var  routingUrls =  {
        "?is_tab=edit":"staff",
        "?show_sign_out=false":"reports",
           "?menuHover=visitor" :"alerts",
           "?menuHover=status": "alerts",
           "?menuHover=resident": "alerts",
           "?menuHover=staff":"alerts",
           "residents": "residents",
           "staff_members":'staff',
           "staff_members/new":'staff',
           "buildings":"settings",
           "devices":"settings",
           "?logo=logo":"settings",
           "?alerts=alerts&menuHover=resident":"residents",
           "?menuHover=staff&staff=staff":"staff",
           "?menuflag=residents&show_sign_out=false":"residents",
           "?show_sign_out=true":"reports",
           "?menuflag=residents&show_sign_out=true":"residents",
           "community_logo":"settings",
           "reports":"reports",
           "home":"home",
           "set_intacct_accnts":"billing",
           "billing":"billing",
           "import_billing":"billing",
           "?end_picker=05%2F03%2F2019&show_sign_out=false&start_picker=05%2F02%2F2019":"reports"
        } ;
      var seachingData = '';
      if (window.location.search){
        seachingData = window.location.search;
      }else{
        var pathname =  window.location.pathname;
       
        if (pathname !='/'){
          var matchString = "community_logo";
          var data  = pathname.match(/community_logo/g);
          seachingData  = data;
      
          if (seachingData ==null){
              data  = pathname.match(/staff_members/g);
              seachingData  = data;
          }
          
          if(!seachingData ){
           
                var url = pathname.split("/");
                if (url.length > 1){
                  seachingData = url[url.length -1]
                }else {
                  seachingData = url[0]
                }
          }
        
        }else {
          seachingData = "home"
        }
        
        
      }
     // $('#reports_link','#alerts_link','#residents_link','#staff_link','#buildings_link','#home_link').removeClass('main-tab-active')
      var  searchString= routingUrls[seachingData] ;
      switch(searchString){
        case 'reports':
          $('#reports_link').addClass('main-tab-active');
          break;
        case 'alerts':
            $('#alerts_link').addClass('main-tab-active');
            break; 
        case 'residents':
            $('#residents_link').addClass('main-tab-active');
            break
        case 'staff':
           $('#staff_link').addClass('main-tab-active');
           break
        case 'settings':
           $('#settings_link').addClass('main-tab-active');
            break
        case 'home':
            $('#home_link').addClass('main-tab-active');
            break
        case 'billing':
            $('#billing_link').addClass('main-tab-active');
            break
        /*default :
            $('#home_link').addClass('main-tab-active'); */

      }


   $("#navbarDiv").show();

});

