###
                  Verdict.coffee 0.0.0.0.0.1
 (c) 2011 Radagaisus MIT open-source license
 Inspired by tangle.js - http://worrydream.com/Tangle/

 requirements: jQuery        http://www.jquery.com/
###
###
 usage:
  add adjustable-number class if you want some spiffy css
  $("#cookies").numbers
    max: 200
    min: 0
    step: 1
    integer: false
###

(($) ->
  # -34234235 => -34,234,235
  # I am so gonna regret this later
  $.format ||= {}
  $.format.num = (num) -> (''+num).replace(/(\d+)(\..*)?/, ($0,$1,$2) -> $1.replace(/(\d)(?=(\d{3})+$)/g,'$1,') + ($2 || ''))

  $.fn.numbers = (opts) ->
    defaults =
      # max: 200
      # min: 0
      step: 1
      integer: true
      growth: 2

    o = $.extend {}, defaults, opts

    # Add the event handlers
    numberDrag = (elem) ->
      elem.css('cursor', 'col-resize')
      elem.data("value", Number(elem.text().replace(/,/g,'')))
      elem.mousedown (e) ->
        document.body.onselectstart = -> false
        document.body.style.MozUserSelect = "none"
        document.body.onmousedown = -> false
        document.body.style.cursor = "col-resize"
        x = e.pageX
        $(window).bind 'mousemove.numbers', (change) ->
          # pageX is cross-browser normalized by jQuery
          dir = 2 * (x < change.pageX) - 1 # if x < lastX then 1 else -1 :-)
          val = elem.data("value")
          val = Math.max(Math.min(val + dir * o.step * (Math.abs(change.pageX - x) / o.growth), if o.max == 0 then o.max else (o.max || Infinity) ), if o.min == 0 then o.min else (o.min || -Infinity))
          val = Math.floor(val) if o.integer
          elem.data('value', val)
          elem.text($.format.num val)
          x = change.pageX

          elem.trigger 'verdictChange', val

      $(window).mouseup ->
        $(window).unbind 'mousemove.numbers'
        document.body.onselectstart = null
        document.body.style.MozUserSelect = ""
        document.body.onmousedown = null
        document.body.style.cursor = "inherit"

    @each ->
      numberDrag $(@)
)(window.jQuery)


### 
 usage:
  add adjustable-bool class if you want some spiffy css
  $("#cookies").boolSelect
    first: 'something'
    second: 'another thing'
###
(($) ->
  $.fn.boolSelect = (o) ->

    # Add the event handlers
    bool = (elem, first) ->
      elem.click (e) ->
        if elem.text() == o.first then elem.text(o.second) else elem.text(o.first)
        elem.trigger('verdictChange', elem.text())

    @each ->
      bool $(@)
)(window.jQuery)
