/*
  Main javascript, depends on jQuery
  @author:  Andre van Toly
  @version: '$Id$'
*/

function tweets() {
    $('li.tweet em a').each(function(i) {
        var time = $(this).text();
        $(this).text( relative(time) );
    });
    $('li.tweet').each(function(i) {
        var txt = $(this).html();
        txt = txt.replace(/\B@([_a-z0-9]+)/ig, function(r) { return r.charAt(0)+'<a href="http://twitter.com/'+r.substring(1)+'">'+r.substring(1)+'</a>';});
        $(this).html(txt);
    });
}

function relative(time_value) {
    var values = time_value.split(" ");
    time_value = values[1] + " " + values[2] + ", " + values[5] + " " + values[3];
    var parsed_date = Date.parse(time_value);
    var relative_to = (arguments.length > 1) ? arguments[1] : new Date();
    var delta = parseInt((relative_to.getTime() - parsed_date) / 1000);
    delta = delta + (relative_to.getTimezoneOffset() * 60);
  
    if (delta < 60) {
        return 'less than a minute ago';
    } else if(delta < 120) {
        return 'about a minute ago';
    } else if(delta < (60*60)) {
        return (parseInt(delta / 60)).toString() + ' minutes ago';
    } else if(delta < (120*60)) {
        return 'about an hour ago';
    } else if(delta < (24*60*60)) {
        return 'about ' + (parseInt(delta / 3600)).toString() + ' hours ago';
    } else if(delta < (48*60*60)) {
        return '1 day ago';
    } else {
        return (parseInt(delta / 86400)).toString() + ' days ago';
    }
}

$(document).ready(function() {
    tweets();
});