//render the partial
$("#edit_fcm_<%= @fee_code_match.id%>").html("<%= escape_javascript(render :partial=>'edit_fcm')%>");
//show it
$("#edit_fcm_<%= @fee_code_match.id%>").show("slow");
