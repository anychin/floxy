#= require jquery
#= require jquery_ujs
#= require jquery.role/lib/jquery.role
#= require bootstrap
#= require moment
#= require bootstrap-datetimepicker
#= require moment/ru
#= require cocoon

$ ->
  $('@datetimepicker').datetimepicker
    locale: 'ru'
    icons:
      time: "fa fa-clock-o datetimepicker-icon",
      date: "fa fa-calendar datetimepicker-icon",
      up: "fa fa-arrow-up datetimepicker-icon",
      down: "fa fa-arrow-down datetimepicker-icon"
      previous: 'fa fa-arrow-left'
      next: 'fa fa-arrow-right'
      today: 'fa fa-crosshairs'
      clear: 'fa fa-trash'
    format: 'DD/MM/YYYY'

  $('@tooltip').tooltip()
