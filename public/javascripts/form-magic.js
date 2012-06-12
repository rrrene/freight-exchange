
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

function showOrHideFields(show, fields) {
  if( show ) {
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
  if( show_more ) $(addToStyleQueries(fields, "input")).select();
}

function showFrequencyFields() {
  var val = $("#freight_frequency, #loading_space_frequency").val();
  if( val == "" ) {
    showOrHideFields(false, "#freight_first_transport_at_input, #loading_space_first_transport_at_input");
    showOrHideFields(false, "#freight_last_transport_at_input, #loading_space_last_transport_at_input");
    showOrHideFields(false, "#freight_transport_count_input, #loading_space_transport_count_input");
  } else if( val == "once" ) {
    showOrHideFields(true, "#freight_first_transport_at_input, #loading_space_first_transport_at_input");
    showOrHideFields(false, "#freight_last_transport_at_input, #loading_space_last_transport_at_input");
    showOrHideFields(false, "#freight_transport_count_input, #loading_space_transport_count_input");
  } else {
    showOrHideFields(true, "#freight_first_transport_at_input, #loading_space_first_transport_at_input");
    showOrHideFields(true, "#freight_last_transport_at_input, #loading_space_last_transport_at_input");
    showOrHideFields(true, "#freight_transport_count_input, #loading_space_transport_count_input");
  }
}

function showOwnMeansOfTransportFields() {
  var show_more = $("#freight_own_means_of_transport, #loading_space_own_means_of_transport").val() == "custom";
  var fields = "#freight_own_means_of_transport_custom_input, #loading_space_own_means_of_transport_custom_input";
  showOrHideFields(show_more, fields);
  if( show_more ) $(addToStyleQueries(fields, "input")).select();
}

function addToStyleQueries(original_query, additional_query) {
  var q = " "+additional_query.trim();
  return original_query.split(",").join(q+",")+q;
}

function showOwnMeansOfTransportPresentFields() {
  var own_means_present = $("#freight_own_means_of_transport_present_true, #loading_space_own_means_of_transport_present_true").attr("checked");
  var show_own_means_present = "#freight_own_means_of_transport_input, #freight_own_means_of_transport_custom_input, #loading_space_free_capacities_input, #loading_space_own_means_of_transport_input, #loading_space_own_means_of_transport_custom_input";
  var show_own_means_not_present = "#freight_requirements_means_of_transport_input, #freight_desired_means_of_transport_input";
  showOrHideFields(own_means_present, show_own_means_present);
  showOrHideFields(!own_means_present, show_own_means_not_present);
  if( own_means_present ) {
    showOwnMeansOfTransportFields();
    $("#freight_desired_means_of_transport_custom_input, #loading_space_desired_means_of_transport_custom_input").hide();
  } else {
    showDesiredMeansOfTransportFields();
  }
}

function showCustomFieldsOnDemandHandler(id) {
  var show_more = $("#"+id).val() == "custom";
  var fields = "#"+id+"_custom_input";
  showOrHideFields(show_more, fields);
  if( show_more ) $(addToStyleQueries(fields, "input")).select();
}

function showCustomFieldsOnDemand(id) {
  $("#"+id).bind("change", function(event) {
    showCustomFieldsOnDemandHandler(id);
  });
  showCustomFieldsOnDemandHandler(id);
}

function changeConditionAttributeName(event) {
  console.log("change attribute name:", $(this).val())
  var resourceKey = $(this).attr('id').replace("_attribute_name", "");
  var originalInput = $(this).parents('form').find('[id$="_value"]')[0];
  var oldInput = $(this).parents('form').find('[name*="value"]')[0];

  console.log(resourceKey, originalInput, oldInput)

  var optional_id = "#" + $(this).attr('id') + "_" + $(this).val();
  if( $(optional_id).length > 0 ) {
    var replacementInput = $(optional_id).find('input, select').first().clone();
    if( oldInput != originalInput ) $(oldInput).remove();
    $(originalInput).attr("name", "");
    $(originalInput).hide();
    $(originalInput).after(replacementInput);
  } else {
    console.log("remove old input?", originalInput != oldInput)
    if( oldInput != originalInput ) $(oldInput).remove();
    $(originalInput).attr("name", resourceKey+"[value]");
    $(originalInput).show();
  }
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

  showCustomFieldsOnDemand("company_category");

  $("#company_custom_category, #freight_custom_category, #loading_space_custom_category").before('<input type="checkbox" class="checkbox" disabled="disabled">');

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

  $('#advanced-search-controls input[type="checkbox"]').bind("change", function(event) {
      if( $('#q').val() != "" ) $(this).parents('form').submit();
  });


  $('#notification_condition_freight_attribute_name, #notification_condition_loading_space_attribute_name').bind("change", changeConditionAttributeName);
  $('#notification_condition_freight_attribute_name, #notification_condition_loading_space_attribute_name').each(function(index) {
    changeConditionAttributeName.apply(this);
  });

});