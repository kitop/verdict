###
                  Verdict.coffee 0.0.0.0.0.1
 (c) 2011 Radagaisus MIT open-source license
 Inspired by tangle.js - http://worrydream.com/Tangle/
 
 requirements: jQuery        http://www.jquery.com/
###
###
 usage:
  add adjustable_number class if you want some spiffy css
  $("#cookies").numbers
    max: 200
    min: 0
    step: 1
    integer: false
###

# FIXME: velocity, no need for max or min, flots

(($) ->
  # -34234235 => -34,234,235
  # I am so gonna regret this later
  $.format ||= {}
  $.format.num = (num) -> (''+num).replace(/(\d+)(\..*)?/, ($0,$1,$2) -> $1.replace(/(\d)(?=(\d{3})+$)/g,'$1,') + $2)
  
  $.fn.numbers = (o) ->
    defaults =
      # max: 200
      # min: 0
      step: 1
      integer: true
      growth: 2
    
    o = $.extend defaults, o
    
    # Add the event handlers
    number_drag = (elem) ->
      elem.css('cursor', 'col-resize')
      elem.mousedown (e) ->
        document.body.onselectstart = -> false
        document.body.style.MozUserSelect = "none"
        document.body.onmousedown = -> false
        document.body.style.cursor = "col-resize"
        x = e.pageX
        $(window).bind 'mousemove.numbers', (change) ->
          # pageX is cross-browser normalized by jQuery
          dir = 2 * (x < change.pageX) - 1 # if x < last_x then 1 else -1 :-)
          val = Number(elem.text().replace(/,/g,''))
          val = Math.max(Math.min(val + dir * o.step * (Math.abs(change.pageX - x) / o.growth), o.max || Infinity), o.min || -Infinity)
          val = Math.floor(val) if o.integer?
          elem.text($.format.num val)
          x = change.pageX
          
          elem.trigger 'verdict_change', val
      
      $(window).mouseup ->
        $(window).unbind 'mousemove.numbers'
        document.body.onselectstart = null
        document.body.style.MozUserSelect = ""
        document.body.onmousedown = null
        document.body.style.cursor = "inherit"
    
    @each ->
      number_drag $(@)
)(window.jQuery)


### 
 usage:
  add adjustable_bool class if you want some spiffy css
  $("#cookies").bool_select
    first: 'something'
    second: 'another thing'
###
(($) ->
  $.fn.bool_select = (o) ->
    
    # Add the event handlers
    bool = (elem, first) ->
      elem.click (e) ->
        if elem.text() == o.first then elem.text(o.second) else elem.text(o.first)
        elem.trigger('verdict_change', elem.text())
    
    @each ->
      bool $(@), 
)(window.jQuery)