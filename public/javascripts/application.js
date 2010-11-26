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
  jQuery("ul.action_list li").each(function(i, li) {
    jQuery(li).hover(function(evt) { var item=evt.currentTarget; jQuery(item).addClass('hovered'); }, function(evt) { var item=evt.currentTarget; jQuery(item).removeClass('hovered') });
    jQuery(li).click(function(evt) {
    var a = jQuery(evt.currentTarget).find("a").first();
    self.location.href = jQuery(a).attr('href');
    });
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
    var ele = jQuery("#"+site_info_prefix+'_'+origin_or_destination+'_site_info_attributes_'+i);
    if( ele ) {
      ele.val(site_info[i]);
    }
  }
}

jQuery(function() {
  actionListMagic();
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
  
});
