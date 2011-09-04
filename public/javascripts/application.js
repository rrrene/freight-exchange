// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function login_from_name(name) {
  var login = name.toLowerCase();
  login = login.replace(/ä/g, 'ae');
  login = login.replace(/ö/g, 'oe');
  login = login.replace(/ü/g, 'ue');
  login = login.replace(/(à|À|á|Á|â|Â|ã|ä|Ä|å|æ)/g, 'a');
  login = login.replace(/(ç)/g, 'c');
  login = login.replace(/(è|È|é|É|ê|Ê|ë)/g, 'e');
  login = login.replace(/(ì|Ì|í|Í|î|Î|ï)/g, 'i');
  login = login.replace(/(ñ)/g, 'n');
  login = login.replace(/(ò|Ò|ó|Ó|õ|ö|Ö|ø|ô|Ô)/g, 'o');
  login = login.replace(/(ù|Ù|ú|Ú|û|Û|ü|Ü)/g, 'u');
  login = login.replace(/(ý|Ý|ÿ)/g, 'y');
  login = login.replace(/[^A-Za-z0-9]+/g, '_');
  return login;
}

function actionListMagic() {
  jQuery("ul.action_list li").each(function(index, li, arr) {
    var links = jQuery(li).find("a");
    if( links.length > 0 ) {
      jQuery(li).hover(function(evt) { var item=evt.currentTarget; jQuery(item).addClass('hovered'); }, function(evt) { var item=evt.currentTarget; jQuery(item).removeClass('hovered') });
      jQuery(li).click(function(evt) {
        var a = jQuery(evt.currentTarget).find("a").first();
        self.location.href = jQuery(a).attr('href');
      });
    }
  });
}

function changeLocalizedInfoLanguage(ele, langs) {
  ele = jQuery(ele);
  var id = ele.attr('id');
  var show_lang = ele.val();
  jQuery(langs).each(function(index, lang) {
    var field = jQuery("#"+id+"_"+lang);
    if( lang == show_lang ) {
      field.show();
    } else {
      field.hide();
    }
  });
}

var site_info_prefix = "";

function fillSiteInfo(origin_or_destination, site_info_id) {
  var site_info = all_site_infos[site_info_id];
  for(var i in site_info) {
    var ele = jQuery("#"+site_info_prefix+'_'+origin_or_destination+'_'+i);
    if( ele ) {
      ele.val(site_info[i]);
    }
  }
}

function bindMiniButtons() {
  jQuery('a.minibutton').bind({
    mousedown: function() {
      jQuery(this).addClass('mousedown');
    },
    blur: function() {
      jQuery(this).removeClass('mousedown');
    },
    mouseup: function() {
      jQuery(this).removeClass('mousedown');
    }
  });
}

function rearrangeSearchForm() {
  var labelWidth = parseInt($('#search-label').css('width'));
  var wrapperWidth = parseInt($('.input-wrapper').css('width'));
  $('#q').css('width', (wrapperWidth-labelWidth-40)+'px')
}

function switchSearchContext(context, text) {
  var form = $('#search_form form');
  form.attr('action', '/'+context);
  var label = $('#search-label');
  label.html(text);
  label.attr('class', 'search-label search-label-'+context)
  rearrangeSearchForm();
  $(document).trigger('hidePopover');
  $('#q').select();
}

// Clicks anywhere outside the menus should close any active menus.
jQuery(function() {
  $('html').click(function() {
    $('.top-navigation-menu').each(function(index, item) {
      deactivateMenu($(item).attr('id'));
    });
  });
  $('.top-navigation-menu, .top-navigation-menu-link').click(function(event){
    event.stopPropagation();
  });
});

function deactivateMenu(name) {
  $('#'+name).hide();
  var a = $('#'+name+'_link');
  a.removeClass('menu-active');
}

function toggleMenu(name) {
  $('.top-navigation-menu').each(function(index, item) {
    item = $(item);
    if( item.attr('id') != name ) deactivateMenu(item.attr('id'));
  });
  $('#'+name).toggle();
  var a = $('#'+name+'_link');
  console.log(a)
  if( a.hasClass('menu-active') ) {
    a.removeClass('menu-active');
  } else {
    a.addClass('menu-active');
  }
}

function popover(base_selector) {
  var popover_selector = base_selector+'-popover';
  $(base_selector).popover({header: popover_selector + ' > .header', content: popover_selector + ' > .content'});
}

function onClickSideTrackAvailable() {
  //freight_origin*_*track_number_input
  var name = $(this).attr('id');
  var origin_or_destination = name.match(/origin/) ? 'origin' : 'destination';
  
  var arr = name.match(/(.+)_(.+)/);
  console.log(name, arr)
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
  console.log($("#freight_desired_means_of_transport").val())
  var fields = "#freight_desired_means_of_transport_custom_input";
  showOrHideFields(show_more, fields);
}

function showOwnMeansOfTransportFields() {
  var show_more = $("#freight_own_means_of_transport").val() == "custom";
  console.log($("#freight_own_means_of_transport").val())
  var fields = "#freight_own_means_of_transport_custom_input";
  showOrHideFields(show_more, fields);
}

function showOwnMeansOfTransportPresentFields() {
  var show_more = $("#freight_own_means_of_transport_present_true").attr("checked");
  var fields = "#freight_own_means_of_transport_input, #freight_own_means_of_transport_custom_input";
  showOrHideFields(show_more, fields);
  if( show_more ) showOwnMeansOfTransportFields();
}

jQuery(function() {
  actionListMagic();
  bindMiniButtons();

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

  $("#freight_desired_means_of_transport").bind("change", showDesiredMeansOfTransportFields);
  showDesiredMeansOfTransportFields();

  $("#freight_own_means_of_transport").bind("change", showOwnMeansOfTransportFields);
  showOwnMeansOfTransportFields();

  $("#freight_own_means_of_transport_present_true, #freight_own_means_of_transport_present_false").click(showOwnMeansOfTransportPresentFields);
  showOwnMeansOfTransportPresentFields();

  rearrangeSearchForm();
  popover('#search-label');
  $('#q').focus(function() { $('#search_form').addClass('focussed') }).blur(function() { $('#search_form').removeClass('focussed') });

  $('.chosen').chosen();
});
