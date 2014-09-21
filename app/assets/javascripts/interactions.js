(function(){
var en = {
    tabPromptDefault: "Add more contact information",
    tabPromptFocused: "Tip: Press Enter to add more contact information"
};

var resetPage = (function () {
    $("#button-add-another #tab-prompt").text(en.tabPromptDefault);

});

var addAnother = (function () {
    var elem = $(contactInfoItemFactory(getNumberOfImmediateSubnodes('#contact-info-list', '.contact-info-item')));
    $('#contact-info-list').append(elem);
    // connectListeners();
    return elem;
});

var getDataFromForm = (function () {
    return {
        "pebble": $('.form-name-card #input-pebble-id').val(),
        "name": $('.form-name-card #input-name').val(),
        "info": JSON.stringify(contactDataToArray())
    }
});

var contactDataToArray = (function () {
    var returnArray = [];
    $('.form-name-card .input-contact-source').each(function(index) {
        returnArray.push($(this).val());
    });
    return returnArray;
});

var getNumberOfImmediateSubnodes = (function (parent, selector) {
    console.log(parent);
    console.log(selector);
    return $(parent).find(selector).length;
});

var contactInfoItemFactory = (function (numberOfItems) {
    return '<div class="contact-info-item"> \
                                <div class="form-group"> \
                                    <label for="input-contact-source" class="col-sm-2 control-label">Other:</label> \
                                    <div class="col-sm-10"> \
                                        <input class="form-control input-contact-source" type="text" placeholder="Type or paste your URL, phone number or email address.."> \
                                    </div> \
                                </div> \
                            </div>';
});

var connectListeners = (function () {
    $('.input-contact-source').focusin(function() {
        $("#button-add-another #tab-prompt").text(en.tabPromptFocused);
        console.log("focusin");
    }).add('.input-contact-source').focusout(function() {
        $("#button-add-another #tab-prompt").text(en.tabPromptDefault);
        console.log("focusout");
    });

    $('.input-contact-source').keypress(function(event){
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if(keycode == '13' && $(this).val().length > 0){
            addAnother();
            $('.contact-info-item .input-contact-source').last().focus();
        }
    });
});

window.nameCardInit = function(callback) {

    console.log("ready");

    resetPage();

    // connectListeners();

    $( ".form-name-card" ).submit(function( event ) {
        console.log(getDataFromForm());
        $.ajax({
            url: '/profile',
            type: 'put',
            dataType: 'json',
            data: getDataFromForm()
        }).done(function(data){
            window.location.href = "/profile";
        }).fail(function(jqXHr, textStatus, errorThrown) {
            alert(['error',jqXHr, textStatus, errorThrown]);
        });
        event.preventDefault();
    });

    $('button#button-add-another').click(function() {
        addAnother();
    });

    callback();
}

window.addMoreField = addAnother;
})();
