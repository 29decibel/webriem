$(document).ready(function () {
    //$(':input:text:first').focus();            
    $(':input:enabled').addClass('enterIndex');
    // get only input tags with class data-entry
    textboxes = $('.enterIndex');
    // now we check to see which browser is being used
    if ($.browser.mozilla) {
        $(textboxes).bind('keypress', CheckForEnter);                
    } else {
        $(textboxes).bind('keydown', CheckForEnter);                
    }
});
function CheckForEnter(event) {
    if (event.keyCode == 13 && $(this).attr('type') != 'button' && $(this).attr('type') != 'submit' && $(this).attr('type') != 'textarea' && $(this).attr('type') != 'reset') {
				//add a change trigger,added by 29decibel
				$(this).change();
				//original logic
        var i = $('.enterIndex').index($(this));  
        var n = $('.enterIndex').length; 
        if (i < n - 1) {
            if ($(this).attr('type') != 'radio') 
            {                                                                                                                     
                NextDOM($('.enterIndex'),i);                                                                           
            }
            else {  
                var last_radio = $('.enterIndex').index($('.enterIndex[type=radio][name=' + $(this).attr('name') + ']:last'));
                NextDOM($('.enterIndex'),last_radio);                        
            }                    
        }
        return false;
    }
} 
function NextDOM(myjQueryObjects,counter) {
    if (myjQueryObjects.eq(counter+1)[0].disabled) {
        NextDOM(myjQueryObjects, counter + 1);
    }
    else {
        myjQueryObjects.eq(counter + 1).trigger('focus');
    }
}