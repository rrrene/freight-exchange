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

var site_info_prefix = "";

function fillSiteInfo(site, station_id) {
  var station = all_stations[station_id];
  for(var i in station) {
    var ele = jQuery("#"+site_info_prefix+'_'+site+'_site_info_attributes_'+i);
    if( ele ) {
      ele.val(station[i]);
    }
  }
}