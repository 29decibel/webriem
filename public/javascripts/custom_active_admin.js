$(function(){
  $('.is_self_dep input[type=checkbox]').live('change',function(){
    if($(this).attr('checked'))
    {
      $(this).closest('fieldset').find("li.dep").hide();
    }
    else
    {
      $(this).closest('fieldset').find("li.dep").show();
    }
  });
  $('.is_self_dep input[type=checkbox]').change();
});
