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

var requestStationsTimeoutId = null;
function requestStations(ele) {
  $.ajax({
    url: $(ele).data("query"),
    data: {
      query: $(ele).val(),
      dom_element_id: $(ele).data("dom-element-id"),
      field_name: $(ele).data("field-name")
    },
    dataType: "script",
    method: "GET"
  });
}

jQuery(function() {

  $('input[data-query]').bind("keyup", function(event) {
    console.log(event)
    var self = this;
    clearTimeout(requestStationsTimeoutId);
    requestStationsTimeoutId = setTimeout(function() {
      requestStations(self);
    }, 300);
  });

  actionListMagic();
  bindMiniButtons();

  rearrangeSearchForm();
  popover('#search-label');
  $('#q').focus(function() { $('#search_form').addClass('focussed') }).blur(function() { $('#search_form').removeClass('focussed') });

  $('.chosen').chosen();

  // Clicks anywhere outside the menus should close any active menus.

  $('html').click(function() {
    $('.top-navigation-menu').each(function(index, item) {
      deactivateMenu($(item).attr('id'));
    });
  });
  $('.top-navigation-menu, .top-navigation-menu-link').click(function(event){
    event.stopPropagation();
  });

  $('.history_step').hover(
    function(event) {
      var klass = $(this).attr('class').split(" ");
      var all = $('.'+klass[klass.length-1]);
      all.addClass("hovered");
    },
    function(event) {
      var klass = $(this).attr('class').split(" ");
      var all = $('.'+klass[klass.length-1]);
      all.removeClass("hovered");
    }
  );

});

