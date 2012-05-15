// Generated by CoffeeScript 1.3.3
/*
                  Verdict.coffee 0.0.0.0.0.1
 (c) 2011 Radagaisus MIT open-source license
 Inspired by tangle.js - http://worrydream.com/Tangle/

 requirements: jQuery        http://www.jquery.com/
*/

/*
 usage:
  add adjustable-number class if you want some spiffy css
  $("#cookies").numbers
    max: 200
    min: 0
    step: 1
    integer: false
*/

(function($) {
  $.format || ($.format = {});
  $.format.num = function(num) {
    return ('' + num).replace(/(\d+)(\..*)?/, function($0, $1, $2) {
      return $1.replace(/(\d)(?=(\d{3})+$)/g, '$1,') + ($2 || '');
    });
  };
  return $.fn.numbers = function(opts) {
    var defaults, numberDrag, o;
    defaults = {
      step: 1,
      integer: true,
      growth: 2
    };
    o = $.extend({}, defaults, opts);
    numberDrag = function(elem) {
      elem.css('cursor', 'col-resize');
      elem.data("value", Number(elem.text().replace(/,/g, '')));
      elem.mousedown(function(e) {
        var x;
        document.body.onselectstart = function() {
          return false;
        };
        document.body.style.MozUserSelect = "none";
        document.body.onmousedown = function() {
          return false;
        };
        document.body.style.cursor = "col-resize";
        x = e.pageX;
        return $(window).bind('mousemove.numbers', function(change) {
          var dir, val;
          dir = 2 * (x < change.pageX) - 1;
          val = elem.data("value");
          val = Math.max(Math.min(val + dir * o.step * (Math.abs(change.pageX - x) / o.growth), o.max === 0 ? o.max : o.max || Infinity), o.min === 0 ? o.min : o.min || -Infinity);
          if (o.integer) {
            val = Math.floor(val);
          }
          elem.data('value', val);
          elem.text($.format.num(val));
          x = change.pageX;
          return elem.trigger('verdictChange', val);
        });
      });
      return $(window).mouseup(function() {
        $(window).unbind('mousemove.numbers');
        document.body.onselectstart = null;
        document.body.style.MozUserSelect = "";
        document.body.onmousedown = null;
        return document.body.style.cursor = "inherit";
      });
    };
    return this.each(function() {
      return numberDrag($(this));
    });
  };
})(window.jQuery);

/* 
 usage:
  add adjustable-bool class if you want some spiffy css
  $("#cookies").boolSelect
    first: 'something'
    second: 'another thing'
*/


(function($) {
  return $.fn.boolSelect = function(o) {
    var bool;
    bool = function(elem, first) {
      return elem.click(function(e) {
        if (elem.text() === o.first) {
          elem.text(o.second);
        } else {
          elem.text(o.first);
        }
        return elem.trigger('verdictChange', elem.text());
      });
    };
    return this.each(function() {
      return bool($(this));
    });
  };
})(window.jQuery);
