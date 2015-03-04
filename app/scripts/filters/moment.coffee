'use strict'

###*
 # @ngdoc filter
 # @name swarmApp.filter:moment
 # @function
 # @description
 # # moment
 # Filter in the swarmApp.
###
angular.module('swarmApp').filter 'duration', (options) ->
  (input, unitOfTime, template, precision) ->
    if input is Infinity
      return ''
    if input.toNumber?
      input = input.toNumber()
    return '' if not input
    nonexact = if input?.nonexact?  and input.nonexact then 'less than ' else ''
    duration = moment.duration input, unitOfTime
    if not template?
      template = 'd[d] h:mm:ss'
      switch options.durationFormat?()
        when 'human' then return nonexact + duration.humanize()
        when 'full' 
          template = switch
            when duration.asSeconds() < 60 then 's [seconds]'
            else 'y [yr] M [mth] d [day] hh:mm:ss'
        when 'abbreviated'
          template = switch
            when duration.asYears() > 1 then 'y [years] M [months]'
            when duration.asMonths() > 1 then 'M [months] d [days]'
            when duration.asDays() > 1 then 'd [days] h [hours]'
            when duration.asSeconds() < 60 then 's [seconds]'
            else template

    return nonexact + duration.format template, precision
# could just pass the template from the view, but this is testable
angular.module('swarmApp').filter 'warpDuration', ($filter) ->
  (input, unitOfTime, precision) ->
    $filter('duration')(input, unitOfTime, 'd [days] h [hours and] m [minutes]', precision)

angular.module('swarmApp').filter 'momentFromNow', ($filter) ->
  (input) ->
    return moment(input).fromNow()
