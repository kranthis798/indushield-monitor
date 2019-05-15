$(document).ready(function() {
   /* $('#staff_role_ids_1, #staff_role_ids_2, #staff_role_ids_3').change(function() {
            var comm_id = $("#community_field").val();
            var val = [];
            $('.status_checkbox').each(function(i){
              if ($('.status_checkbox')[i].checked){
                val[i] = $(this).val();
              }
            });
            $.ajax('/communities/'+comm_id+'/staff_members?checked='+val)
                .done(function(resp) {
                  location.reload(true);
                });
    }); */

    $('#showactive').change(function() {
        var comm_id = $("#community_field").val();
        var status  = 0;
        if ($(this).is(":checked"))
        {
            status = 1;  
        }

             $.ajax('/communities/'+comm_id+'/staff_members?checked='+status)
             .done(function(resp) {
               location.reload(true);
             }); 
         

});

    /*  validations */


    var  onlyAlphbets =  /^[a-zA-Z]*$/;
    var  emailValidation =  /^\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b$/i ;
    var  numbervalidation  = /^\d*$/;
   
  /*
    $('#addUserForm').on('click',function(){
  
          var  errorMsgs = [];
          var isFormValidated = true;
          var firstName = $('#firstName').val(); 
          var lastName = $('#lastName').val(); 
          console.log(firstName,lastName,"lrakkkksss");
          var email  = $("#email").val();
          var paswd = $('#password').val();
          var title  =  $("input#title").val();
          if (firstName  == '' ){
              isFormValidated = false;
              //errorMsgs.push("Please enter first name");
              $('#firstNameErro').attr('style','display:inline')
              .text("Please enter first name")
              .css("color","red");
              
          }else{
              
              $('span#firstNameErro').text('');
          }
  
          if (firstName.length >0 ){
              if (!onlyAlphbets.test(firstName)){
                  isFormValidated = false;
                 // errorMsgs.push("0nly alphabets are accepted ");
                 $('#firstNameErro').attr('style','display:inline')
                 .text("0nly alphabets are accepted")
                 .css("color","red");
     
              }else{
                  $('#firstNameErro').attr('style','display:hide');
              }
          }
  
          if (lastName  == '' ){
              isFormValidated = false;
              errorMsgs.push("Please enter last name");
  
  
              $('#lastNameErro').attr('style','display:inline')
              .text("Please enter last name")
              .css("color","red");
          }
          if (lastName.length >0 ){
              if (!onlyAlphbets.test(lastName)){
                  isFormValidated = false;
                  $('#lastNameErro').attr('style','display:inline')
                 .text("0nly alphabets are accepted")
                 .css("color","red");
                  //errorMsgs.push("0nly alphabets are accepted ");
              }else{ 
                  $('#lastNameErro').text("");
  
              }
          }
  
          if (email  == '' ){
              isFormValidated = false;
              //errorMsgs.push("Please enter email");
              $('#emailErro').attr('style','display:inline')
                 .text("Please enter email")
                 .css("color","red");
          }else{
              $('#emailErro').text("");
          }
          if (email.length >0 ){
              if (!emailValidation.test(email)){
                  isFormValidated = false;
                  //errorMsgs.push("Please enter valid email");
                  $('#emailErro').attr('style','display:inline')
                  .text("Please enter valid email")
                  .css("color","red");
              }else{
                  $('#emailErro').text("");
              }
              
              
          }
  
          if (title  == '' ){
  
              isFormValidated = false;
              
              $('#titleErro').attr('style','display:inline')
              .text("Please enter title")
              .css("color","red");
  
  
          }else{
              console.log("title is empty.........")
              $('span#titleErro').text("");
          }
  
  
  
          if ($('#addUserForm').attr("value") == 'Create User'){
              if (paswd  == '' ){
                  isFormValidated = false;
                  //errorMsgs.push("Please enter title");
                  $('#passdErro').attr('style','display:inline')
                  .text("Please enter password")
                  .css("color","red");
  
  
              }else{
                  $('#passdErro').text("");
              }
          }
          if(!isFormValidated ){
      
          
              return false;
              
          }else{
              
  
          }
  
          
           
          
          console.log(errorMsgs,"ssssssssssssssssssss")
  
    });

    */
   if ($('#email').val ==''){
    $('#reports_enabled ,#can_view_visit_photos,#access_residents_c,#addcommunityContact,#userrole,#accushieldChamp,#billing_contract,#offline_kiosk_contact').attr("disabled", true);	
   }
    $('#email').keyup(function(){
    
        if ($(this).val() !=''){
            $('#reports_enabled ,#can_view_visit_photos,#access_residents_c,#addcommunityContact,#userrole,#accushieldChamp,#billing_contract,#offline_kiosk_contact').attr("disabled", false);	
        }else{
            $('#reports_enabled ,#can_view_visit_photos,#access_residents_c,#addcommunityContact,#userrole,#accushieldChamp,#billing_contract,#offline_kiosk_contact').attr("disabled", true);	
        }

    });
  
    $('input#mobileNumber').keyup(function(){
          
       
      if (!numbervalidation.test($(this).val())){
          var  replace =  $(this).val().replace(/.$/,"")
          $(this).val(replace);
  
      }
  
          if($(this).val().length >10){
              var  replace =  $(this).val().replace(/.$/,"")
              $(this).val(replace);
          }
      
  
  
   });
  
  
   $('input#phoneNumber').keyup(function(){
     
      if (!numbervalidation.test($(this).val())){
         
          var  replace =  $(this).val().replace(/.$/,"")
          $(this).val(replace);
      } 
        if($(this).val().length >10){
               var  replace =  $(this).val().replace(/.$/,"")
               $(this).val(replace);
       }
      
      
  
   });
  


    /* ***************************** */


    $("#staff_members_table").on('click','.kisoclass',function(){
    
      var checked;
      var  uncheckStatus; 
      if ($(this).is(':checked')) {
        checked = true;
        uncheckStatus = "Active"
      
      } else {
        checked = false;
        uncheckStatus = "In-Active"
      }
      if (confirm("Are you sure .You want to update  Kiosk Staff List ? ")) {
          txt = true
          } else {
            txt = false
        }
       var id  = $(this).attr('data');
       if(txt){
           $.ajax({
              type: "POST",
              url: "/staff/updatekioskstaffid",
              data: { user_id:  $(this).attr('data'), checked:checked  },
              success:function(html){
                  
                  $("#staff_"+id).text(uncheckStatus)
                }
  
           });
       }
  
  });
  
  
  
  $("#staff_members_table").on('click','.communityclass',function(){
      var checked;
      var  uncheckStatus; 
      if ($(this).is(':checked')) {
        checked = true;
      } else {
        checked = false;
      }
      if (confirm("Are you sure. You want to update Community Admin ? ")) {
          txt = true
          } else {
            txt = false
        }
       if(txt){
           $.ajax({
              type: "POST",
              url: "/staff/updateCommunityAdmin",
              data: { email:  $(this).attr('data'), checked:checked  },
              success:function(html){
              console.log(html.status);
              if (html.status == "error"){
                  location.reload();
                      
                   }   
              }
             
      
  
           });
       }
  
  });
  
  
  $("#staff_members_table").on('click','.dashboardclass',function(){
      var checked;
      var  uncheckStatus; 
      if ($(this).is(':checked')) {
        checked = true;
      } else {
        checked = false;
      }
      if (confirm("Are you sure. You want to update Dashboard Access ? ")) {
          txt = true
          } else {
            txt = false
        }
       if(txt){
           $.ajax({
              type: "POST",
              url: "/staff/updateDashboard",
              data: { email:  $(this).attr('data'), checked:checked  },
             
      
  
           });
       }
  
  });
  
  
  
  $("#staff_members_table").on('click','.assigncomu',function(){
      var checked;
      var  uncheckStatus; 
      if ($(this).is(':checked')) {
        checked = true;
      } else {
        checked = false;
      }
      if (confirm("Are you sure. you want to update   ")) {
          txt = true
          } else {
            txt = false
        }
        console.log($(this).attr('data'));
       if(txt){
           $.ajax({
              type: "POST",
              url: "/staff/updateContactrole",
              data: { email:  $(this).attr('data'), checked:checked  },
          
           });
       }
  
  });
});
