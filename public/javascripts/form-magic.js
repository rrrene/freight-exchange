
function onClickSideTrackAvailable() {
  //freight_origin*_*track_number_input
  var name = $(this).attr('id');
  var origin_or_destination = name.match(/origin/) ? 'origin' : 'destination';
  
  var arr = name.match(/(.+)_(.+)/);
  var trackNoElement = $("#"+RegExp.$1+"_track_number_input");
  trackNoElement.css('display', $(this).val() == "false" ? 'none' : 'block' );
  
  if( name.match(/_true$/) && $(this).attr('checked') ) {
    $('#'+origin_or_destination+'_with_station').show();
  } else {
    $('#'+origin_or_destination+'_with_station').hide();
    $('#freight_transport_type, #loading_space_transport_type').val('intermodal_transport');
  }
  $('#'+origin_or_destination+'_address').show();
}

function showOrHideFields(show_more, fields) {
  if( show_more ) {
    $(fields).show().addClass("more_info");
  } else {
    $(fields).hide().removeClass("more_info");
  }
}

function showHazmatFields() {
  var show_more = $("#freight_hazmat_true").attr("checked");
  var fields = "#freight_hazmat_class_input, #freight_un_no_input";
  showOrHideFields(show_more, fields);
}
function showDesiredMeansOfTransportFields() {
  var show_more = $("#freight_desired_means_of_transport").val() == "custom";
  var fields = "#freight_desired_means_of_transport_custom_input";
  showOrHideFields(show_more, fields);
}

function showFrequencyFields() {
  var show_more = $("#freight_frequency, #loading_space_frequency").val() == "once";
  var fields = "#freight_first_transport_at_input, #loading_space_first_transport_at_input";
  showOrHideFields(show_more, fields);
}

function showOwnMeansOfTransportFields() {
  var show_more = $("#freight_own_means_of_transport, #loading_space_own_means_of_transport").val() == "custom";
  var fields = "#freight_own_means_of_transport_custom_input, #loading_space_own_means_of_transport_custom_input";
  showOrHideFields(show_more, fields);
}

function showOwnMeansOfTransportPresentFields() {
  var show_more = $("#freight_own_means_of_transport_present_true, #loading_space_own_means_of_transport_present_true").attr("checked");
  var show_more_fields = "#freight_own_means_of_transport_input, #freight_own_means_of_transport_custom_input, #loading_space_own_means_of_transport_input, #loading_space_own_means_of_transport_custom_input";
  var show_less_fields = "#freight_requirements_means_of_transport_input";
  showOrHideFields(show_more, show_more_fields);
  showOrHideFields(!show_more, show_less_fields);
  if( show_more ) showOwnMeansOfTransportFields();
}

jQuery(function() {
  var elements = [
    "#freight_origin_side_track_available_false",
    "#freight_origin_side_track_available_true",
    "#freight_destination_side_track_available_false",
    "#freight_destination_side_track_available_true",
    "#loading_space_origin_side_track_available_false",
    "#loading_space_origin_side_track_available_true",
    "#loading_space_destination_side_track_available_false",
    "#loading_space_destination_side_track_available_true"
  ];
  $(elements).each(function(index, element) {
    $(element).bind({
      'click': onClickSideTrackAvailable
    });
  });

  $("#freight_hazmat_true, #freight_hazmat_false").click(showHazmatFields);
  showHazmatFields();

  $("#freight_frequency, #loading_space_frequency").bind("change", showFrequencyFields);
  showFrequencyFields();

  $("#freight_desired_means_of_transport").bind("change", showDesiredMeansOfTransportFields);
  showDesiredMeansOfTransportFields();

  $("#freight_own_means_of_transport, #loading_space_own_means_of_transport").bind("change", showOwnMeansOfTransportFields);
  showOwnMeansOfTransportFields();
  
  var selector = "#freight_own_means_of_transport_present_true, #freight_own_means_of_transport_present_false, #loading_space_own_means_of_transport_present_true, #loading_space_own_means_of_transport_present_false";
  $(selector).click(showOwnMeansOfTransportPresentFields);
  showOwnMeansOfTransportPresentFields();
});